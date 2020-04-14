# foldingathome_tools
Collection of reporting tools/scripts for your Folding@home systems.


## fahclient_reporting.sh
Basic reporting script that leverages your existing journalctl FAHClient logging history to report on PPD and WU counts for a specified time period. Can report counts for entire machine or per folding slot.

Since it leverages the journalctl log history, FAHClient must be setup to run via systemd. All start and end date strings must confirm to the since/until syntax of the journalctl command. Excerpt from journalctl man page with examples below:
>-S, --since=, -U, --until=
>
>Start showing entries on or newer than the specified date, or on or older than the specified date, respectively. Date >specifications should be of the format "2012-10-30 18:17:16". If the time part is omitted, "00:00:00" is assumed. If only the >seconds component is omitted, ":00" is assumed. If the date component is omitted, the current day is assumed. Alternatively >the strings "yesterday", "today", "tomorrow" are understood, which refer to 00:00:00 of the day before the current day, the >current day, or the day after the current day, respectively. "now" refers to the current time. Finally, relative times may be >specified, prefixed with "-" or "+", referring to times before or after the current time, respectively. For complete time and >date specification, see systemd.time(7). Note that --output=short-full prints timestamps that follow precisely this format.

### Usage:
fahclient_reporting.sh [-s journalctl start date string] [-e journalctl end date string] [-u (UTC time)] [-f (two digit folding slot number)]

Defaults: -s "24 hours ago" -e "now" -u (unset to indicate local machine time) -f (unset to indicate ALL slots)

###
