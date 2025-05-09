#alias "000"="echo try 000-help"

alias "000"="000-help"

export __000_TESTS=$(dirname ${BASH_SOURCE[0]})/tests
export __000_FLAG_TRACE=~/000.flag.trace
000-help () {
    echo help for 000
}

000_reset () {
    unset _000_DEPTH
}

000-trace-on () {
    touch ${__000_FLAG_TRACE}
}

000-trace-off () {
    rm ${__000_FLAG_TRACE}
}

000-trace-stat () {
    [ -f ${__000_FLAG_TRACE} ]
}

000_tab () {
    # If trace is on, tab the arguments to stderr
    [ -f ~/000.flag.trace ] || return
    local x=$(seq -s "  " 0 ${_000_DEPTH})
    echo "$x" $@ >&2
}

000_indent () {
    [[ .${_000_DEPTH} == . ]] && _000_DEPTH=-1
    export _000_DEPTH=$(( ${_000_DEPTH} + 1 ))
    000_tab $@
}

000_dedent () {
    000_tab $@
    export _000_DEPTH=$(( ${_000_DEPTH} - 1 ))
}

000_hardin () {
    000_indent "++[${FUNCNAME[1]}()]" $@
}

000_hardout () {
    000_dedent "--[${FUNCNAME[1]}()]" $@
}

000_usage () {
    local bin=$(${1}:000:bin)
    local xx
    echo usage:
    for xx in $(ls $bin); do
        echo "    ${1} $(basename $xx)"
    done
    for xx in $(declare -f | grep ^${1}_); do
        [[ "$xx" == "()" ]] && continue
        echo "    $xx()"
    done
}

000_subfn () {
    local arg=${1}
    shift
    local fn0=${FUNCNAME[1]}
    local fn1=${fn0}_${arg}
    local bin=$( ${fn0}:000:bin )
    local script=${bin}/${arg}
    if [[ "$(type -t ${fn1})" == "function" ]]; then
        000_tab ::function:: ${fn1} $@
        ${fn1} $@
    elif [[ ! -f ${script} ]]; then
        000_tab :usage ${fn0}
        000_usage $fn0
    elif [[ -x ${script} ]]; then
        000_tab ::execute:: $ ${script} $@
        ${script} $@
    else
        000_tab ::source:: $ . ${script} $@
        . ${script} $@
    fi
    return
}

000_test () {
    local err
    000-trace-stat
    err=$?
    000-trace-on
    . $(dirname ${BASH_SOURCE[0]})/tests/runtests
    [ ! ${err} == 0 ] && 000-trace-off
}
