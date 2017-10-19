#
# HeLmod bash function.
# Wraps some of the module load functionality and provides a few other tidbits 
# specific to HeLmod
#

join_by() { 
    local IFS="$1"; shift; echo "$*"; 
}

helmod() {
    case $1 in 
        os)
            shift;
            if [ -z "$1" ]; then 
                echo "$FASRCSW_OS"
                return 0
            else
                export FASRCSW_OS="${1}" 
            fi
            unset MODULEPATH_ROOT && source lmod.sh
            ;;
        prod)
            shift;
            if [ -z "$1" ]; then
                echo "$FASRCSW_PROD" 
                return 0
            else
                export FASRCSW_PROD="${1}"
            fi
            unset MODULEPATH_ROOT && source lmod.sh
            ;;
        env)
            shift;
            unsets=""
            for e in FASRCSW_PROD FASRCSW_DEV FASRCSW_OS FASRCSW_COMPS FASRCSW_MPIS FASRCSW_CUDAS NAME VERSION RELEASE TYPE; do 
                test -z "${!e}" && unsets="$unsets $e" || echo "$e=${!e}"
            done
            test -n "$unsets" && echo ""; echo "Unset variables"; join_by , $unsets
            ;;
        spider | query)
            shift;
            test `which module-query.py >/dev/null 2>&1` && module-query.py $@ || eval $($LMOD_CMD bash "$@") && eval $(${LMOD_SETTARG_CMD:-:} -s sh)
            ;;
        *)
            eval $($LMOD_CMD bash "$@") && eval $(${LMOD_SETTARG_CMD:-:} -s sh)
            ;;
    esac
}
export -f helmod
