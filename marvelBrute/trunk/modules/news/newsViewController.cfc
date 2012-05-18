<cfcomponent name="newsViewController" output="false" extends="resources.abstractController">

	<cffunction name="init" output="false">
		<cfargument name="data" required="true">
		<cfargument name="model" required="true">
		<cfargument name="requestObject" required="true">
		<cfset var path = requestObject.getFormUrlVar('path')>
		
		<cfset variables.id = listlast(path,'/')>
		<cfset variables.view = listgetat(path, listlen(path,'/') -1,'/')>
		<cfset variables.newsqry = arguments.model.getnews(variables.id)>
		<cfset variables.data = arguments.data>

		<cfreturn this>
	</cffunction>

	<cffunction name="showHTML">
		<cfset var html = "">
		<cfsavecontent variable="html">
	        <div class="newsDetail">
				<cfinclude template="templates/newsdetail.cfm">
			</div>
		</cfsavecontent>
		<cfreturn html>
	</cffunction>

	<cffunction name="dump">
		<cfdump var=#variables.newsqry#>
		<cfabort>
	</cffunction>

	<!--- <cffunction name="shownews" output="false">
		<cfargument name="showdescription" default="true">
		<cfset var html = "">
		<cfset var df1 = "mmmm d, yyyy">
		<cfset var df2 = "">
		<cfsavecontent variable="html">
			<style>
				form p label {width:200px;}
			</style>
			<div class="newsView">
			<cfoutput query="variables.newsqry">
				<!---<h3>#variables.newsqry.title#</h3>--->
				<h3>
				<cfif startdate EQ enddate>
					#dateformat(startdate,df1)#
				<cfelseif dateformat(startdate,"myyyy") EQ dateformat(enddate,"myyyy")>
					#dateformat(startdate,'mmmm')# #dateformat(startdate,'d')#-#dateformat(enddate,'d')#, #dateformat(startdate,'yyyy')#
				<cfelse>
					#dateformat(startdate,df1)# - #dateformat(enddate,df1)#
				</cfif>
				</h3>
				<cfif arguments.showDescription>
				<p>
					#description#
				</p>
				</cfif>
			</cfoutput>
			</div>
		</cfsavecontent>
		<cfreturn html>
	</cffunction> --->
</cfcomponent>