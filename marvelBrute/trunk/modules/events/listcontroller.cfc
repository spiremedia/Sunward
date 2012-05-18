<cfcomponent name="eventslistcontroller" output="false">
	
	<cffunction name="init" output="false">
		<cfargument name="data" required="true">
		<cfargument name="model" required="true">
		<cfargument name="requestObj" required="true">
			
		<cfset variables.eventsqry = arguments.model.getEventsList()>
		<cfparam name="arguments.data.label" default="">
		<cfset variables.label = arguments.data.label>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="showHTML" output="false">
		<cfset var html = "">
		<cfset var df1 = "mmmm d, yyyy">
		<cfset var df2 = "">
		<cfsavecontent variable="html">
			<cfif variables.label NEQ "">
				<cfoutput><h3>#variables.label#</h3></cfoutput>
			</cfif>
			<ul class="events">
			<cfif variables.eventsqry.recordcount>
			<cfoutput query="variables.eventsqry">
			<li>
				<a  href="/NewsAndEvents/Event/#id#">#title#</a><br>
				<cfif startdate EQ enddate>
					#dateformat(startdate,df1)#
				<cfelseif dateformat(startdate,"myyyy") EQ dateformat(enddate,"myyyy")>
					#dateformat(startdate,'mmmm')# #dateformat(startdate,'d')#-#dateformat(enddate,'d')#, #dateformat(startdate,'yyyy')#
				<cfelse>
					#dateformat(startdate,df1)# - #dateformat(enddate,df1)#
				</cfif>
				<br>
				#replace(location, "#chr(10)#", "<br>","all")#
			</li>
			</cfoutput>
			<cfelse>
				<li>There are currently no events to display.</li>
			</cfif>
			</ul>

		</cfsavecontent>
		<cfreturn html>
	</cffunction>
	
	<cffunction name="dump">
		<cfdump var=#variables.eventsqry#>
		<cfabort>
	</cffunction>
</cfcomponent>