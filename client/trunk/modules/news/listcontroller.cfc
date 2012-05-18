<cfcomponent name="newslistcontroller" output="false">
	
	<cffunction name="init" output="false">
		<cfargument name="data" required="true">
		<cfargument name="model" required="true">
		<cfargument name="requestObject" required="true">
			
		<cfset variables.data = arguments.data>
		<cfset variables.model = arguments.model>
		<cfset variables.requestObject = arguments.requestObject>
		<cfset loadSummary()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="loadSummary" output="false">
		<cfset var lcl = structnew()>

		<cfparam name="variables.data.newstype" default="">
		<cfparam name="variables.data.pageing" default="10">
		<cfset variables.newslist = variables.model.getAvailableNewsItems(variables.data.newstype)>
        <cfset variables.rowcount = variables.data.pageing>
		<cfset variables.totalSearchRecords = variables.newslist.recordcount>

		<cfif variables.requestObject.isFormUrlVarSet('page')>
			<cfset variables.page = variables.requestObject.getFormUrlVar('page')>
            <cfparam name="variables.page" type="integer">
            <cfset variables.startrow = variables.page * variables.rowCount - variables.rowCount + 1>
        <cfelse>
            <cfset variables.page = 1>
            <cfset variables.startrow = 1>
        </cfif>

		<cfset lcl.a = arraynew(1)>
        <cfloop from="1" to="#variables.newslist.recordcount#" index="lcl.i">
        	<cfset arrayappend(lcl.a, lcl.i)>
        </cfloop>

        <cfset queryaddcolumn(variables.newslist,'counter', lcl.a)>

        <cfquery name="variables.newslist" dbtype="query" maxrows="#variables.rowcount#">
			SELECT *
			FROM  variables.newslist
			WHERE counter >= <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.startrow#">
		</cfquery>

		<cfreturn this>
	</cffunction>

	
	<cffunction name="showHTML" output="false">
		<cfset var html = "">
	
		<cfsavecontent variable="html">
			<div class="newsListing">
	        	<cfinclude template="templates/newsPagingHeader.cfm">
				<cfinclude template="templates/newslisting.cfm">
	            <cfinclude template="templates/newsPagingFooter.cfm">
			</div>
		</cfsavecontent>
		<cfreturn html>
	</cffunction>
	
	<cffunction name="dump">
		<cfdump var=#variables.data#>
		<cfabort>
	</cffunction>
</cfcomponent>