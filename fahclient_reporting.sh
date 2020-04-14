#!/bin/bash

set -e

JOURNAL_ARGS=()
SINCE_PERIOD=""
UNTIL_PERIOD=""
FS_REPORT=All

function show_help() {
  echo
  echo "Usage: $0 [-s journalctl start date string] [-e journalctl end date string] [-u (UTC time)] [-f (two digit folding slot number)]"
  echo
  echo "Defaults: -s \"24 hours ago\" -e \"now\" -u (unset to indicate local machine time) -f (unset to indicate ALL slots)"
  echo
}

while getopts “:e:f:s:uh” opt; do
  case ${opt} in
    e ) UNTIL_PERIOD="$OPTARG"
	;;
    f ) FSLOT=FS"$OPTARG"
	;;
    h ) show_help
	exit 0;
	;;
    s ) SINCE_PERIOD="$OPTARG"
	;;
    u ) UTC="--utc"
        JOURNAL_ARGS+=($UTC)
	;;
    \? ) show_help
	exit -1;
	;;
  esac
done
shift $((OPTIND -1))

if [ -z "$SINCE_PERIOD" ]
  then
    SINCE_PERIOD="24 hours ago"
fi

if [ -z "$UNTIL_PERIOD" ]
  then
    UNTIL_PERIOD=now
fi

SINCE_OPTION=--since="\"$SINCE_PERIOD\""
JOURNAL_ARGS+=($SINCE_OPTION)

UNTIL_OPTION=--until="\"$UNTIL_PERIOD\""
JOURNAL_ARGS+=($UNTIL_OPTION)

HEADER="\t\t             %10s             \t %10s \t %3s \t   %3s   \n"
FORMAT="\t\t %-16s - %16s \t %10d \t %4d \t%8d \n"
WIDTH=43

JOURNAL_CMD="journalctl -u FAHClient $(printf "%s " "${JOURNAL_ARGS[@]}")"
GREP_CMD='grep "Final credit estimate"'

if [ ! -z "$FSLOT" ]
  then
    GREP_CMD="$GREP_CMD | grep $FSLOT" 
    FS_REPORT=$FSLOT
fi

SCORE=`eval $JOURNAL_CMD | eval $GREP_CMD | awk '{score+=$9} END {printf "%.0f\n", score}'`
WUS=`eval "$JOURNAL_CMD" | eval $GREP_CMD | wc -l`
SDATE=`date --date="$SINCE_PERIOD" '+%s'`
EDATE=`date --date="$UNTIL_PERIOD"   '+%s'`
PPD=`echo $SCORE $EDATE $SDATE | awk '{print int(($1)/(($2-$3)/86400)) }'`

echo
date ${UTC}
echo "Reporting on folding slot: $FS_REPORT"
echo
printf "$HEADER" "Date Range" "Score Credit" "WUS" "PPD"
printf "\t\t=====================================\t==============\t=====\t=========\n"
printf "$FORMAT" "$SINCE_PERIOD" "$UNTIL_PERIOD" $SCORE $WUS $PPD
echo
