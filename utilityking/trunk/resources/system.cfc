<cfcomponent
	displayname="System"
	hint='I setup the system for use'>

	<cffunction 
		name="onApplicationStart"
		returntype="boolean"
		output=false
		hint=''>
		<cfset load()>
		<cfreturn true>
	</cffunction>

	<cffunction 
		name="onRequestStart"
		returntype="void"
		output="false">
	
		<cfif StructKeyExists(url, "refresh")>
			<cflock scope="application" timeout="30" type="exclusive">
				<cfset onApplicationStart()>
			</cflock>
		</cfif>

		<cfif StructKeyExists(url, "logout") OR structKeyExists(url,"refreshSession")>
			<cfif structKeyExists(session,"user") and session.user.isloggedin()>
				<cfset session.user.logout()> 
			</cfif>
		</cfif>

		<cfif StructKeyExists(url, "logout") OR  structKeyExists(url,"refreshSession") OR NOT structKeyExists(session,"user")>
			<cfset onSessionStart() />
		</cfif>

		<cfset request.start = gettickcount()>
	</cffunction>
	
	<cffunction name="onrequestend"><!---<cfoutput>#gettickcount() - request.start#</cfoutput>---></cffunction>

	<cffunction name="onSessionStart">
		<!--- check not a bot? --->
		<cfset session.user = createObject('component', 'resources.localuser').init()>
	</cffunction>

	<cffunction
		name="load"
		access="private"
		output=false
		returntype="void">
		
		<cfset var stateObject = createObject('component','resources.state').init()>
        <cfset var settings = createObject('component','resources.settings').init(stateObject)>
        <cfset var views = createObject('component','resources.views').init(settings.getVar('machineRoot'))>
        <cfset var modules = createObject('component','resources.modules').init(settings.getVar('machineRoot'))>
        <cfset var myappevents = createObject('component','resources.applications').init(settings.getVar('machineRoot'))>
		<cfset var site = createObject('component','resources.site').init(settings, myappevents)>
        
		<cfset application.settings = settings>
		<cfset application.views = views>
		<cfset application.modules = modules>
		<cfset application.site = site>

	</cffunction>

	<cffunction
		name="setupSecurity"
		access="private"
		output=false
		returntype="void"
		hint=''>
	
	</cffunction>
	<cffunction name="onError">
		<!--- The onError method gets two arguments:
		An exception structure, which is identical to a cfcatch variable.
		The name of the Application.cfc method, if any, in which the error
		happened.--->
		<cfargument name="Except" required=true/>
		<cfargument type="String" name = "EventName" required=true/>
		<cfset var fromemail = application.settings.getVar('systememailfrom')>
		<cfset var server = application.settings.getVar('mailsmtp')>
		<cfset var systememailto = application.settings.getVar('systememailto')>
		<cfset var systememailalertflag = application.settings.getVar('systememailalertflag')>
		<cfset var siteName = application.settings.getVar('siteName')>
		<cfset var siteurl = application.settings.getVar('siteurl')>

		<cfif isdefined("arguments.exception.rootCause") AND arguments.exception.rootCause eq "coldfusion.runtime.AbortException">
			<cfreturn/>
		</cfif>

		<cfif isdefined("arguments.exception.type") AND arguments.exception.type eq "coldfusion.runtime.AbortException">
			<cfreturn/>
		</cfif>
		
		<cfsavecontent variable="errorContent"><cfoutput>
			<p>Error Event: #EventName#</p>
			<p>Error details:<br>
			<cfdump var=#except#></p>
			<p>cgi:<br>
			<cfdump var=#cgi#></p>
		</cfoutput></cfsavecontent>
 
		<!--- You can replace this cfoutput tag with application-specific error-handling code. --->
		<cfif left(cgi.remote_addr, 6) EQ "10.1.1" OR cgi.remote_addr EQ "216.87.69.98" or cgi.remote_addr EQ '127.0.0.1'>
			<cfoutput>#errorContent#</cfoutput>
		<cfelse>
			<cfcontent reset="yes">
			
			<p><a href="/"><img src="/ui/images/Logo.gif"></a></p>
			<p>Despite our best efforts, an unexpected error occurred. We have been notified of the issue and will be working to fix the problem.  Please try again soon.</p>

			<cfif systememailalertflag eq 1>
				<cfmail to="#systememailto#" from="#fromemail#" subject="#siteName# Site Error (#siteurl#)" server="#server#" type="html">
					<cfoutput>#errorContent#</cfoutput>
				</cfmail>
			</cfif>

			<cflog file="#replace(siteName," ", "", "ALL")#_Site" text="#except#" type="error">
			<cfabort>
		</cfif>
	</cffunction>
</cfcomponent>
