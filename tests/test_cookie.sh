#!/bin/bash

# shellcheck disable=SC2154

source ./cookie

my_target="myTarget"
my_template="myTemplate"

tmpdir=/tmp/foodir
tmpdir2=/tmp/bardir
foobar=/tmp/foobar
foobaz=/tmp/foobaz
fake_temp=cookie.tmp

setUp() {
    echo "Fake Template" > /tmp/"${fake_temp}"
    mkdir -p "${tmpdir}" &> /dev/null
    mkdir -p "${tmpdir2}" &> /dev/null
}

tearDown() {
    export ROOT_DIR=
    export DEFAULT_TARGET_DIR=
    export target_dir=

    rm -rf "${tmpdir}"
    rm -rf "${tmpdir2}"
    rm -rf "${foobar}"
    rm -rf "${foobaz}"
    rm -rf /tmp/"${fake_temp}"
}

###############################################################################
#  Test parse_args                                                            #
###############################################################################
test_parse_args__NOX_NOF() {
    parse_args "-T" "${my_template}" "${my_target}"
    assertEquals 0 "$?"

    assertEquals "${template}" "${my_template}"
    assertEquals "${my_target}" "${target}"
    assertEquals "n" "${executable}"
    assertEquals false "${force}"
}

test_parse_args__X_F() {
    parse_args "-T" "${my_template}" "-x" "-f" "${my_target}"
    assertEquals 0 "$?"

    assertEquals "y" "${executable}"
    assertEquals true "${force}"
}

test_parse_args__CONFIG() {
    export EDITOR="echo"
    assertContains "$(parse_args -c)" "/config"
}

test_parse_args__EDIT_NO_EXISTS() {
    export EDITOR="echo"
    export COOKIE_DIR=/tmp

    assertEquals "/tmp/my_template" "$(parse_args -e my_template)"
}

test_parse_args__EDIT_EXISTS() {
    export EDITOR="echo"
    export COOKIE_DIR=/tmp

    assertEquals "${foobar}" "$(parse_args -e foobar)"
}

test_parse_args__REMOVE() {
    export COOKIE_DIR=/tmp

    assertTrue "${fake_temp} NEVER existed to begin with" "[[ -f /tmp/${fake_temp} ]]"
    (parse_args "-r" "${fake_temp}" < <(printf "y"))
    assertFalse "${fake_temp} STILL exists" "[[ -f /tmp/${fake_temp} ]]"
}

###############################################################################
#  Test get_dest_dir                                                          #
###############################################################################
test_get_dest_dir__NO_CONFIG() {
    export ROOT_DIR=./
    get_dest_dir "${my_target}"
    assertEquals "./" "${dest_dir}"
}

test_get_dest_dir__ROOT() {
    export ROOT_DIR=/tmp
    get_dest_dir "${my_target}"
    assertEquals "/tmp" "${dest_dir}"
}

test_get_dest_dir__ROOT_AND_TARGET() {
    export ROOT_DIR=/tmp
    export DEFAULT_TARGET_DIR=foobar

    get_dest_dir "${my_target}"
    assertEquals "${foobar}" "${dest_dir}"
    rm -rf "${foobar}"
}

test_get_dest_dir__ROOT_AND_TARGET_IN_ROOT() {
    export ROOT_DIR=/tmp
    export DEFAULT_TARGET_DIR=foobar

    cd /tmp || return 1

    get_dest_dir "${my_target}"
    assertEquals "${foobar}" "${dest_dir}"
    rm -rf "${foobar}"
}

test_get_dest_dir__ROOT_AND_TARGET_IN_ROOT_SUBDIR() {
    export ROOT_DIR=/tmp
    export DEFAULT_TARGET_DIR=foodir

    OLD_PWD=$PWD
    cd "${tmpdir2}" || return 1

    get_dest_dir "${my_target}"
    assertEquals "${tmpdir2}" "${dest_dir}"

    cd "$OLD_PWD" || return 1
}

test_get_dest_dir__ABSOLUTE_PATH() {
    export ROOT_DIR=/tmp
    get_dest_dir "/home/$HOME/my_target"

    assertEquals "/home/$HOME" "${dest_dir}"
}

###############################################################################
#  Test editor_cmd                                                            #
###############################################################################
test_editor_cmd__VIM() {
    export EDITOR="vim"
    read editor_cmd < <(editor_cmd "" "" "${my_target}")
    assertEquals "vim  ${my_target}" "${editor_cmd}"
}

test_editor_cmd__VIM_NSTART() {
    export EDITOR="vim"
    read editor_cmd < <(editor_cmd "5" "" "${my_target}")
    assertEquals "vim +5 ${my_target}" "${editor_cmd}"
}

test_editor_cmd__VIM_ISTART() {
    export EDITOR="vim"
    read editor_cmd < <(editor_cmd "5" "INSERT" "${my_target}")
    assertEquals "vim +5 +startinsert ${my_target}" "${editor_cmd}"
}

test_editor_cmd__NOVIM() {
    export EDITOR="nano"
    read editor_cmd < <(editor_cmd "5" "INSERT" "${my_target}")
    assertEquals "nano ${my_target}" "${editor_cmd}"
}

###############################################################################
#  Test template_engine                                                       #
###############################################################################
test_template_engine__START() {
    read -r -d '' old_contents <<-EOM
	FOO
	{% INSERT %}
	EOM

    template_engine "${old_contents}"

    IFS= read -r -d '' expected <<-EOM
	FOO
	EOM

    assertEquals "${expected}" "${new_contents}"

    read -r -d '' old_contents <<-EOM
	FOO
	{% NORMAL %}
	EOM

    template_engine "${old_contents}"
    assertEquals "${expected}" "${new_contents}"
}

test_template_engine__ENVVAR() {
    read -r -d '' old_contents <<-EOM
	FOO
	{{ my_variable }}
	EOM
    export my_variable="BAR"
    template_engine "${old_contents}"
    read -r -d '' expected <<-EOM
	FOO
	BAR
	EOM
    
    assertEquals "${expected}" "${new_contents}"
}

test_template_engine__CC_ENVVAR() {
    read -r -d '' old_contents <<-EOM
	FOO
	{{ cookiecutter.my_variable }}
	EOM
    export my_variable="BAR"
    template_engine "${old_contents}"
    read -r -d '' expected <<-EOM
	FOO
	BAR
	EOM
    
    assertEquals "${expected}" "${new_contents}"
}

test_template_engine__ENVVAR_NOT_DEFINED() {
    export my_variable=
    read -r -d '' old_contents <<-EOM
	FOO
	{{ my_variable }}
	EOM

    read -r -d '' expected <<-EOM
	FOO
	BAR
	EOM

    template_engine "${old_contents}" < <(echo "BAR")
    
    assertEquals "${expected}" "${new_contents}"
}

test_template_engine__NO_SPACES() {
    read -r -d '' old_contents <<-EOM
	FOO
	{{my_variable}}
	EOM
    export my_variable="BAR"
    template_engine "${old_contents}"
    read -r -d '' expected <<-EOM
	FOO
	BAR
	EOM
    
    assertEquals "${expected}" "${new_contents}"
}

###############################################################################
#  Test Exit Handler                                                          #
###############################################################################
test_exit_handler__CREATED_ZERO_EC() {
    exit_handler 0 true "${tmpdir}"
    assertTrue "${tmpdir} is NOT a directory" "[[ -d ${tmpdir} ]]"
}

test_exit_handler__NOT_CREATED_NONZERO_EC() {
    exit_handler 1 false "${tmpdir}"
    assertTrue "${tmpdir} is NOT a directory" "[[ -d ${tmpdir} ]]"
}

test_exit_handler__CREATED_ZERO_EC() {
    exit_handler 1 true "${tmpdir}"
    assertFalse "${tmpdir} still exists" "[[ -d ${tmpdir} ]]"
}

###############################################################################
#  Test main                                                                  #
###############################################################################
test_main() {
    export EDITOR=":"
    export PARENT_DIR=/tmp
    export DEFAULT_TARGET_DIR=
    export COOKIE_DIR=/tmp

    main "-T" "${fake_temp}" "-x" "foobar" &> /dev/null
    assertTrue "foobar is NOT a file." "[ -f foobar ]"
    assertTrue "foobar is NOT executable." "[ -x foobar ]"
}

test_main__LIST() {
    export COOKIE_DIR="${tmpdir2}"

    mkdir -p "${COOKIE_DIR}"

    template1="${COOKIE_DIR}"/footemp
    template2="${COOKIE_DIR}"/bartemp

    echo "FOOBAR" > "${template1}"
    touch "${template2}"

    read -r -d '' expected <<-EOM
    bartemp
	footemp 
	EOM

    assertEquals "${expected}" "$(main "-l")"
    assertEquals "FOOBAR" "$(main "-l" "footemp")"
}

test_main__TEMPLATE_NOT_EXIST() {
    (main -T fake_template.sh foobar 2> /dev/null); EC=$?
    assertTrue "cookie fails to die when the template doesn't exist" "[[ ${EC} -ne 0 ]]"
}

test_main__USAGE_ERROR() {
    (main 2> /dev/null); EC=$?
    assertTrue "cookie failed to die with a usage message" "[[ ${EC} -eq 2 ]]"
}

test_main__TARGET_ALREADY_EXISTS() {
    export COOKIE_DIR=/tmp

    echo ":)" > "${foobar}"

    (main "-T" "${fake_temp}" "${foobar}" 2> /dev/null); EC=$?
    assertTrue "cookie fails when the target already exists" "[[ ${EC} -eq 0 ]]"
    assertEquals ":)" "$(cat ${foobar})"
}

test_main__EXEC_HOOK_CMD() {
    export EXEC_HOOK_CMD="echo \"Hook Output: \${TARGET}\" > ${foobaz}"
    (main -T "${fake_temp}" --executable=y "${foobar}" 2> /dev/null)

    assertEquals "Hook Output: ${foobar}" "$(cat "${foobaz}")"
}

test_main__BIN_SUBDIR() {
    export ROOT_DIR=/tmp

    (main "-T" "${fake_temp}" "-D" "foodir" "foobar"); EC=$?
    assertTrue "cookie fails when using -D option" "[[ ${EC} -eq 0 ]]"
    assertTrue "cookie does not respect the -D option" "[[ -f /tmp/foodir/foobar ]]"
}

test_main__DEEP_TARGET() {
    export ROOT_DIR=/tmp

    (main "-T" "${fake_temp}" "foo/bar"); EC=$?
    assertTrue "cookie fails when using deep target" "[[ ${EC} -eq 0 ]]"
    assertTrue "cookie fails to initialize deep target" "[[ -f /tmp/foo/bar ]]"
}

source shunit2
