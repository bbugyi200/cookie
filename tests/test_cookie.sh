#!/bin/bash

# shellcheck disable=SC2154

source ./cookie

#########################################
#  Test Variables and Setup / TearDown  #
#########################################
my_target="myTarget"
my_template="myTemplate"

tearDown() {
    rm -rf /tmp/foobar
    rm -rf /tmp/cookie
}

#####################
#  Test parse_args  #
#####################
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

#######################
#  Test get_dest_dir  #
#######################
test_get_dest_dir__NO_CONFIG() {
    get_dest_dir "${my_target}"
    assertEquals "./" "${dest_dir}"
}

test_get_dest_dir__ROOT() {
    export ROOT_DIR=/tmp
    export DEFAULT_TARGET_DIR=
    export target_dir=

    get_dest_dir "${my_target}"
    assertEquals "/tmp" "${dest_dir}"
}

test_get_dest_dir__ROOT_AND_TARGET() {
    export ROOT_DIR=/tmp
    export DEFAULT_TARGET_DIR=foobar
    export target_dir=

    get_dest_dir "${my_target}"
    assertEquals "/tmp/foobar" "${dest_dir}"
}

test_get_dest_dir__ROOT_AND_TARGET_IN_ROOT() {
    export ROOT_DIR=/tmp
    export DEFAULT_TARGET_DIR=foobar
    export target_dir=

    cd /tmp || return 1

    get_dest_dir "${my_target}"
    assertEquals "/tmp/foobar" "${dest_dir}"
}

test_get_dest_dir__ROOT_AND_TARGET_IN_ROOT_SUBDIR() {
    export ROOT_DIR=/tmp
    export DEFAULT_TARGET_DIR=foobar
    export target_dir=

    other=/tmp/other
    mkdir "${other}"
    OLD_PWD=$PWD
    cd "${other}" || return 1

    get_dest_dir "${my_target}"
    assertEquals "/tmp/other" "${dest_dir}"

    cd "$OLD_PWD" || return 1
    rm -rf "${other}"
}

######################
#  Test editor_cmd  #
######################
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

##########################
#  Test template_engine  #
##########################
test_template_engine__START() {
    read -r -d '' old_contents <<-EOM
	FOO
	{% START INSERT MODE %}
	EOM

    template_engine "${old_contents}"

    IFS= read -r -d '' expected <<-EOM
	FOO
	EOM

    assertEquals "${expected}" "${new_contents}"

    read -r -d '' old_contents <<-EOM
	FOO
	{% START NORMAL MODE %}
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

###############
#  Test main  #
###############
test_main() {
    export EDITOR=":"
    export PARENT_DIR=/tmp
    export DEFAULT_TARGET_DIR=
    export COOKIE_DIR=/tmp/cookie

    mkdir -p "${COOKIE_DIR}"

    template="${COOKIE_DIR}"/template
    touch "${template}"

    main "-T" "template" "-x" "foobar" &> /dev/null
    assertTrue '/tmp/foobar is NOT a file.' "[ -f /tmp/foobar ]"
    assertTrue '/tmp/foobar is NOT executable.' "[ -x /tmp/foobar ]"
}

test_main__LIST() {
    export COOKIE_DIR=/tmp/cookie

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

source shunit2
