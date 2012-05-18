<!---
:: file rem0bytefiles.bat
:: SpireMedia, Inc. Thaddeus Batt thad@spiremedia.com
:: windows batch file for removing 0 byte files to be called on a scheduled
:: basis when 0-byte files get written to the cfmx mail undeliv folder
:: causing cfmx to go into a death spiral
--->

<cfparam name="url.do" default = "nothing">
<cfdirectory action="list" directory="#ExpandPath("./")#" name="dir">
<cfif url.do eq "delete">
	<cfif "#dir.size#" eq 0 and "#dir.type#" eq "File">
			<cffile action = "delete" file = "#dir.Directory#\#dir.name#">
	</cfif>
<cfdirectory action="list" directory="#ExpandPath("./")#" name="dir1">
<cfdump var="#dir1#">
</cfif>

<cfdirectory action="list" directory="#ExpandPath("./")#" name="dir1">
<cfdump var="#dir1#">
