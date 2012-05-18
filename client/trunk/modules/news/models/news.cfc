<cfcomponent name="news">

	<cffunction name="init">
		<cfargument name="requestObject">
		<cfset variables.requestObject = arguments.requestObject>
		<cfreturn this>
	</cffunction>

	<cffunction name="getAvailableNewsItems">
    	<cfargument name="newstype" required="yes">
		<cfset var q = "">
		<cfquery name="q" datasource="#requestObject.getVar('dsn')#">
			SELECT distinct n.id, n.title, n.itemdate, n.description
			FROM news_view n
			WHERE ((n.startdate IS NULL OR n.startdate < getDate())
				OR (n.enddate IS NULL OR n.enddate > getDate()))
				AND n.typeid IN ( <cfqueryparam value="#arguments.newstype#" cfsqltype="CF_SQL_VARCHAR" list="yes">)
			ORDER BY itemdate DESC
		</cfquery>

		<cfreturn q>
	</cffunction>

	<cffunction name="getAllAvailableNewsItems">
		<cfset var q = "">
		<cfquery name="q" datasource="#requestObject.getVar('dsn')#">
			SELECT distinct n.id, n.title, n.itemdate, n.description
			FROM news_view n
			WHERE ((n.startdate IS NULL OR n.startdate < getDate())
				OR (n.enddate IS NULL OR n.enddate > getDate()))
			ORDER BY itemdate DESC
		</cfquery>

		<cfreturn q>
	</cffunction>
	
	<cffunction name="getNews">
		<cfargument name="id" required="true">
		<cfset var me = "">
		<cfquery name="me" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT *
			FROM news_view e
			WHERE e.id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn me>
	</cffunction>

</cfcomponent>
