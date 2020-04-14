# foldingathome_tools
Collection of reporting tools/scripts for your Folding@home systems. Please forgive code crudeness! PRs are welcome!


## fahclient_reporting.sh
Basic reporting script that leverages your existing journalctl FAHClient logging history to report on PPD and WU counts for a specified time period. Can report counts for entire machine or per folding slot.

Since it leverages the journalctl log history, FAHClient must be setup to run via systemd (see <a href="https://gist.github.com/lopezpdvn/81397197ffead57c2e98">here</a> for an example). All start and end date strings must confirm to the since/until syntax of the journalctl command. Excerpt from journalctl man page with examples below:
>-S, --since=, -U, --until=
>
>Start showing entries on or newer than the specified date, or on or older than the specified date, respectively. Date >specifications should be of the format "2012-10-30 18:17:16". If the time part is omitted, "00:00:00" is assumed. If only the >seconds component is omitted, ":00" is assumed. If the date component is omitted, the current day is assumed. Alternatively >the strings "yesterday", "today", "tomorrow" are understood, which refer to 00:00:00 of the day before the current day, the >current day, or the day after the current day, respectively. "now" refers to the current time. Finally, relative times may be >specified, prefixed with "-" or "+", referring to times before or after the current time, respectively. For complete time and >date specification, see systemd.time(7). Note that --output=short-full prints timestamps that follow precisely this format.

### Usage:
```
fahclient_reporting.sh [-s journalctl start date string] [-e journalctl end date string] [-u (UTC time)] [-f (two digit folding slot number)]

Defaults: -s "24 hours ago" -e "now" -u (unset to indicate local machine time) -f (unset to indicate ALL slots)
```
### Example use case:

#### Last 24 hour period across entire machine (defaults):
```
./fahclient_reporting.sh
```
```
Tue 14 Apr 2020 10:52:24 AM CDT
Reporting on folding slot: All

		             Date Range             	 Score Credit 	 WUS 	   PPD   
		=====================================	==============	=====	=========
		 24 hours ago     -              now 	      13923 	    6 	   13923 

```
#### Folding Slot 01 last week:
```
./fahclient_reporting.sh -s "1 week ago" -e "+1 week" -f 01
```
```
Tue 14 Apr 2020 10:55:15 AM CDT
Reporting on folding slot: FS01

		             Date Range             	 Score Credit 	 WUS 	   PPD   
		=====================================	==============	=====	=========
		 1 week ago       -          +1 week 	    5805589 	   53 	  414684 

```
#### Folding Slot 00 between Mar 15, 2020 and Apr 1, 2020:
```
./foldingathome_tools/fahclient_reporting.sh -s "2020-03-15" -e "2020-04-01" -f 00
```
```
Tue 14 Apr 2020 10:57:36 AM CDT
Reporting on folding slot: FS00

		             Date Range             	 Score Credit 	 WUS 	   PPD   
		=====================================	==============	=====	=========
		 2020-03-15       -       2020-04-01 	      53645 	   21 	    3155 

```
