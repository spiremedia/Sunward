all - 2 new files have been committed to the resoruces/conf directory for base spireesm.  heartbeat.asp (this file checks to ensure that cfmx is serving files correctly and will make the url call to reset the services if not) and heartbeat.cfm (this is just the diagnostic)

on a win machine heartbeat.asp can be called as a scheduled task within windows every 10 mins or so to check on the health of cfmx.

this way the machines can monitor themselves and reset when necessary.