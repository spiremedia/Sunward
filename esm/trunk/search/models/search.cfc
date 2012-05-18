<cfcomponent name="search" output="false">
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.userObject = arguments.userObject>
		<cfreturn this>
	</cffunction>
	<cffunction name="getSearchMonths">
		<cfset var r = "">
	
		<cfquery name="r" datasource="#variables.requestObject.getvar('dsn')#">
			SELECT 
				DATEPART(yy,datetime) year,
				DATEPART(mm,datetime) month
			FROM siteSearches
			WHERE siteid = <cfqueryparam value="#variables.userObject.getCurrentSiteId()#">
			GROUP BY 	DATEPART(yy,datetime), DATEPART(mm,datetime)
			ORDER BY 	DATEPART(yy,datetime) desc, DATEPART(mm,datetime) desc
		</cfquery>
		
		<cfreturn r/>
	</cffunction>
	
	<cffunction name="getSearchItemsByMonth">
		<cfargument name="month">
		<cfargument name="year">
		<cfset var r = "">
	
		<cfquery name="r" datasource="#variables.requestObject.getvar('dsn')#">
			SELECT 
				criteria, recordsfound, datetime
			FROM siteSearches
			WHERE siteid = <cfqueryparam value="#variables.userObject.getCurrentSiteId()#">
				AND DATEPART(mm,datetime) = <cfqueryparam value="#month#" cfsqltype="cf_sql_varchar">
				AND DATEPART(yy,datetime) = <cfqueryparam value="#year#" cfsqltype="cf_sql_varchar">
			ORDER BY datetime
		</cfquery>
		
		<cfreturn r/>
	</cffunction>
	
	<cffunction name="keywordSearch">
		<cfargument name="word">
		
		<cfset var r = "">
	
		<cfquery name="r" datasource="#variables.requestObject.getvar('dsn')#">
			SELECT criteria, recordsfound, datetime
			FROM siteSearches
			WHERE siteid = <cfqueryparam value="#variables.userObject.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
				AND criteria = <cfqueryparam value="#arguments.word#" cfsqltype="cf_sql_varchar">
			ORDER BY datetime desc
		</cfquery>
		
		<cfreturn r>
	</cffunction>
</cfcomponent>