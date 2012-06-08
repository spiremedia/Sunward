<cfcomponent
	displayname="System"
	hint='I setup the system for use'>

	<cffunction 
		name="onApplicationStart"
		returntype="boolean"
		output="false"
		hint=''>
             
		<cfset loadSettings()>
        
        <cfif StructKeyExists(url, "install")>
			<cfset installSomething()>
        </cfif>
        
		<cfset loadModules()>
		<cfset loadSites()>
		
		<!--- <cfset setupSecurity()> --->
		
		<cfreturn true>
	</cffunction>

	<cffunction 
		name="onRequestStart"
		returntype="void"
		output="false">
		
		<cfif StructKeyExists(url, "refresh") OR StructKeyExists(url, "install")>
			<cflock scope="application" timeout="30" type="exclusive">
				<cfset onApplicationStart()>
			</cflock>
		</cfif>

		<cfif NOT structKeyExists(session,"user") OR structKeyExists(url,"refreshSession") OR structKeyExists(url,"logout")>
			<cflock scope="session" timeout="30" type="exclusive">
				<cfset onSessionStart() />
			</cflock>
		</cfif>
		
		<cfif structKeyExists(url,"switchsiteid") AND session.user.isloggedin()>
			<cfset session.user.setCurrentSiteId(url.switchsiteid, application.sites)>
		</cfif>
		
		<cfset request.start = gettickcount()>

	</cffunction>
	
	<cffunction name="onrequestend">
		<cfoutput><!---page took : #gettickcount() - request.start#---></cfoutput>
	
	</cffunction>

	<cffunction 
		name="onSessionStart">
		<cfset session.user = createObject('component', 'resources.localuser').init()>
	</cffunction>

	<cffunction
		name="loadModules"
		access="private"
		output="false"
		returntype="void"
		hint=''>
		
		<cfset var state = createObject('component','resources.registry').init()>
		<cfset var modules = createObject('component','resources.modules').init()>
		<cfset modules.setState(state)>
		<cfset application.modules = modules>
	</cffunction>

	<!--- <cffunction
		name="setupSecurity"
		access="private"
		output="false"
		returntype="void"
		hint=''>
	
	</cffunction> --->
	
	<cffunction
		name="loadSites"
		access="private"
		output="false"
		returntype="void"
		hint=''>
	
		<cfset application.sites = createObject('component','resources.sites').init(application.settings)>
	</cffunction>
	
	<cffunction
		name="loadSettings"
		access="private"
		output="false"
		returntype="void"
		hint=''>
	
		<cfset application.settings = createObject('component','resources.settings').init()>
	</cffunction>
    
    <cffunction
		name="installSomething"
		access="private"
		output="false"
		returntype="void"
		hint=''>
	
		<cfset createObject('component','resources.installer').init()>
	</cffunction>
	
	<cffunction name="onError">
			<!--- The onError method gets two arguments:
			An exception structure, which is identical to a cfcatch variable.
			The name of the Application.cfc method, if any, in which the error
			happened. --->
			<cfargument name="Except" required=true/>
			<cfargument type="String" name = "EventName" required=true/>
			<cfset var fromemail = application.settings.getVar('systememailfrom')>
			<cfset var server = application.settings.getVar('mailsmtp')>
			<cfset var systememailto = application.settings.getVar('systememailto')>
			<cfset var systememailalertflag = application.settings.getVar('systememailalertflag')>
			<cfset var siteName = application.settings.getVar('siteName')>
			<cfset var siteurl = cgi.HTTP_HOST>
			
			<cfsavecontent variable="errorContent"><cfoutput>
				<p>Error Event: #EventName#</p>
				<p>Error details:<br>
				<cfdump var=#except#></p>
				<p>Session User:<br>
				<cfdump var=#session.user.dumpUserInfo()#></p>
				<p>Request Info:<br>
				Form<cfdump var="#form#">
				URL<cfdump var="#url#"></p>
				<p>cgi:<br>
				<cfdump var=#cgi#></p>
			</cfoutput></cfsavecontent>
	
			<!--- You can replace this cfoutput tag with application-specific error-handling code. --->
			<cfif left(cgi.remote_addr, 6) EQ "10.1.1" OR cgi.remote_addr EQ "216.87.69.98" or cgi.remote_addr EQ '127.0.0.1'>
				<cfoutput>#errorContent#</cfoutput>
			<cfelse>
				<cfcontent reset="yes">
	      
				<p><img src="/ui/images/Logo.jpg"></p>
				<p>Despite our best efforts, an unexpected error occurred. We have been notified of the issue and will be working to fix the problem.  Please try again soon.</p>
	
				<cfif systememailalertflag eq 1>
					<cfmail to="#systememailto#" from="#fromemail#" subject="#siteName# Site Error (#siteurl#)" server="#server#" type="html">
						<cfoutput>#errorContent#</cfoutput>
					</cfmail>
				</cfif>
	
				<cflog file="#replace(siteName," ", "", "ALL")#_Site" text="#except#" type="error" >
				<cfabort>
			</cfif>
	</cffunction>
</cfcomponent>
