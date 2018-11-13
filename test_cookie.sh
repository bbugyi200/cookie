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
    read dest_dir < <(get_dest_dir "${my_target}")
    assertEquals "./" "${dest_dir}"
}

test_get_dest_dir__ROOT() {
    export ROOT_DIR=/tmp
    read dest_dir < <(get_dest_dir "${my_target}")
    assertEquals "/tmp" "${dest_dir}"
}

test_get_dest_dir__ROOT_AND_TARGET() {
    export ROOT_DIR=/tmp
    export TARGET_DIR=foobar
    read dest_dir < <(get_dest_dir "${my_target}")
    assertEquals "/tmp/foobar" "${dest_dir}"
}

######################
#  Test open_editor  #
######################
test_open_editor__VIM() {
    export EDITOR="vim"
    read editor_cmd < <(open_editor "" "" "${my_target}")
    assertEquals "vim  ${my_target}" "${editor_cmd}"
}

test_open_editor__VIM_NSTART() {
    export EDITOR="vim"
    read editor_cmd < <(open_editor "5" "" "${my_target}")
    assertEquals "vim +5 ${my_target}" "${editor_cmd}"
}

test_open_editor__VIM_ISTART() {
    export EDITOR="vim"
    read editor_cmd < <(open_editor "5" "INSERT" "${my_target}")
    assertEquals "vim +5 +startinsert ${my_target}" "${editor_cmd}"
}

test_open_editor__NOVIM() {
    export EDITOR="nano"
    read editor_cmd < <(open_editor "5" "INSERT" "${my_target}")
    assertEquals "nano ${my_target}" "${editor_cmd}"
}

##########################
#  Test template_engine  #
##########################
test_template_engine__START() {
    read -r -d '' old_contents << EOM
FOO
{% START INSERT MODE %}
EOM
    new_contents="$(template_engine "${old_contents}")"
    read -r -d '' expected << EOM
FOO

EOM

    assertEquals "${expected}" "${new_contents}"

    read -r -d '' old_contents <<-EOM
FOO
{% START NORMAL MODE %}
EOM

    new_contents="$(template_engine "${old_contents}")"
    assertEquals "${expected}" "${new_contents}"
}

test_template_engine__ENVVAR() {
    read -r -d '' old_contents << EOM
FOO
{{ my_variable }}
EOM
    export my_variable="BAR"
    new_contents="$(template_engine "${old_contents}")"
    read -r -d '' expected << EOM
FOO
BAR
EOM
    
    assertEquals "${expected}" "${new_contents}"
}

test_template_engine__CC_ENVVAR() {
    read -r -d '' old_contents << EOM
FOO
{{ cookiecutter.my_variable }}
EOM
    export my_variable="BAR"
    new_contents="$(template_engine "${old_contents}")"
    read -r -d '' expected << EOM
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
    export TARGET_DIR=
    export COOKIE_DIR=/tmp/cookie
    mkdir -p "${COOKIE_DIR}"

    template="${COOKIE_DIR}"/template
    touch "${template}"

    main "-T" "template" "-x" "foobar" &> /dev/null
    assertTrue '/tmp/foobar is NOT a file.' "[ -f /tmp/foobar ]"
    assertTrue '/tmp/foobar is NOT executable.' "[ -x /tmp/foobar ]"
}

source shunit2
