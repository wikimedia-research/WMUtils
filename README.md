###WMUtils
####An internal utilities library for the Wikimedia Foundation's Research and Data team

####Description
Every organisation has its own idiosyncratic data storage methods and engineering solutions, and the
Wikimedia Foundation is no exception. To help solve for this when doing research, we have created <code>WMUtils</code>,
a library of utility functions for handling the WMF's various data formats, stores and needs.

####Domains
#####Log reading and database connections
Request logs are stored in both HDFS, unsanitised, for 30 days, and in a sanitised and sampled form on
<code>stat1002</code>. [hive_query](https://github.com/Ironholds/WMUtils/blob/master/R/hive_query.R) and
[sampled_logs](https://github.com/Ironholds/WMUtils/blob/master/R/sampled_logs.R), respectively, allow you to
get access to this data and read it into R. Once you have it, you can use [log_strptime](https://github.com/Ironholds/WMUtils/blob/master/R/log_strptime.R) to parse the timestamp format, [parse_uuids](https://github.com/Ironholds/WMUtils/blob/master/R/parse_uuids.R) to extract the UUIDs used by the Wikipedia mobile applications, or even
[log_sieve](https://github.com/Ironholds/WMUtils/blob/master/R/log_sieve.R) to filter the requests down to
those that are considered "pageviews". For general hive manipulation, [hive_range](https://github.com/Ironholds/WMUtils/blob/master/R/hive_range.R) makes a best-guess attempt at the smallest number of date-based partitions to run
a query over to cover a expected range of timestamps.

The rest of our data lives in big MariaDB databases, which can be read from using [mysql_query](https://github.com/Ironholds/WMUtils/blob/master/R/mysql_query.R) (or [global_query](https://github.com/Ironholds/WMUtils/blob/master/R/global_query.R) to do it en-masse), written to with [mysql_write](https://github.com/Ironholds/WMUtils/blob/master/R/mysql_write.R), and checked or amended with [mysql_exists](https://github.com/Ironholds/WMUtils/blob/master/R/mysql_exists.R) or [mysql_delete](https://github.com/Ironholds/WMUtils/blob/master/R/mysql_delete.R) respectively.

#####MediaWiki idiosyncracies
[mw_strptime](https://github.com/Ironholds/WMUtils/blob/master/R/mw_strptime.R) replicates <code>log_strptime</code>,
but for MediaWiki-specific timestamps, while [to_mw](https://github.com/Ironholds/WMUtils/blob/master/R/to_mw.R)
allows you to shift POSIX timestamps back into acceptable MediaWiki ones. For namespace matching,
[namespace_match](https://github.com/Ironholds/WMUtils/blob/master/R/namespace_match.R) localises numeric namespace
values and turns them into the appropriate strings, or takes localised strings and turns them into universally-accepted
numeric values.

#####Geolocation
Through the [pygeoip](https://github.com/appliedsec/pygeoip) library, and WMUtil's [rpy](https://github.com/Ironholds/WMUtils/blob/master/R/rpy.R)
functionality, we can take IP addresses and geolocate them. [geo_country](https://github.com/Ironholds/WMUtils/blob/master/R/geo_country.R) localises to country level, and [geo_city](https://github.com/Ironholds/WMUtils/blob/master/R/geo_city.R) to city-level, while [geo_tz](https://github.com/Ironholds/WMUtils/blob/master/R/geo_tz.R) and [geo_netspeed](https://github.com/Ironholds/WMUtils/blob/master/R/geo_netspeed.R) retrieve a tzdata-compatible timezone and
a connection type, respectively.

#####User-agent parsing
With the assistance of tobie's [ua-parser](https://github.com/tobie/ua-parser) library (specifically the Python port),
we can take user agents and use [ua_parse](https://github.com/Ironholds/WMUtils/blob/master/R/ua_parse.R) to localise
them, retrieving the device, operating system, browser, and browser major/minor versions. This includes spider
identification.

Once the agent is retrieved, [device_classifier](https://github.com/Ironholds/WMUtils/blob/master/R/device_classifier.R)
takes ua-parser's outputted device and makes a best guess at classifying them as phones, tablets or other.

#####Session analysis
A variety of functions implemented in C++ allow for session identification and analysis. <code>intertimes</code> takes
a set of timestamps and turns them into a series of intertime values, which can then be passed to <code>session\_length</code> to retrieve the length of the session(s), <code>session\_pages</code> to retrieve the number of pages within
those sessions, and <code>session\_count</code> to get the number of sessions.

####Dependencies
1. R (doy)
2. The Python libraries mentioned above
3. [data.table](https://github.com/Rdatatable/data.table)
4. [lubridate](https://github.com/hadley/lubridate)
5. [Rcpp](https://github.com/RcppCore/Rcpp)
6. [jsonlite](https://github.com/jeroenooms/jsonlite)
7. parallel
