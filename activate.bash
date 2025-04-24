000_reset () {
    unset _000_DEPTH
}

000_tab () {
    local x=$(seq -s "  " 0 ${_000_DEPTH})
    echo "$x" $@
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
    local bin=$(${1}:bin)
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
    local bin=$( ${fn0}:bin )
    local script=${bin}/${arg}
    if [[ "$(type -t ${fn1})" == "function" ]]; then
        000_tab :fun ${fn1} $@
        ${fn1} $@
    elif [[ ! -f ${script} ]]; then
        000_tab :usage ${fn0}
        000_usage $fn0
    elif [[ -x ${script} ]]; then
        000_tab exe $ ${script} $@
    else
        000_tab src $ . ${script} $@
    fi
    return
}
