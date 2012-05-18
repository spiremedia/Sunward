<cfcomponent displayname="MyCFCTest" extends="mxunit.framework.TestCase">
		
	<cffunction name="setUp" returntype="void" access="public">		
		<cfset var lcl = structNew()>
		
		<cfset variables.unittestname = "Unit Test Event">
		<cfset this.unittestsearchterm = "Unit Test Event">
		<cfset variables.eventid = createuuid()>
		<cfset variables.requestObject = request.requestObject>
    	<cfset loadController()>
		
		<cfquery name="lcl.qry" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT id FROM users
			WHERE username = 'sa@spiremedia.com'
		</cfquery>
		
		<cfset lcl.userid = lcl.qry.id>
		
		<!--- insert event  --->
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			INSERT INTO events ( id,name,title,location,description,startdate,enddate,modifieduser,siteid,onhomepage)
			VALUES (
				<cfqueryparam value="#variables.eventid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.unittestname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.unittestname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.unittestname# location" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.unittestname# description" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#CreateODBCdate(DateAdd('d', -1, Now()))#" cfsqltype="cf_sql_date">,
				<cfqueryparam value="#CreateODBCdate(DateAdd('m', 1, Now()))#" cfsqltype="cf_sql_date">,
				<cfqueryparam value="#lcl.userid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.requestObject.getVar('siteid')#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="1" cfsqltype="cf_sql_integer">
			)			
		</cfquery>
	</cffunction>
    
    <cffunction name="teardown" returntype="void" access="public">
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			DELETE FROM events WHERE id = <cfqueryparam value="#variables.eventid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			DELETE FROM eventAttendees WHERE eventid = <cfqueryparam value="#variables.eventid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
    
    <cffunction name="loadController" access="private">
    	<cfargument name="data" default="#structnew()#">
    	<cfargument name="requestObject" default="#variables.requestObject#">
    	<cfargument name="pageref" default="#structnew()#">
    	<cfset variables.controller = createObject("component","modules.events.controller").init(
			data=arguments.data,
			requestObject=arguments.requestObject,
			pageref=arguments.pageref
		)>
    </cffunction>
	
    <!--- model tests --->
    <cffunction name="testGettingEvents">
		<cfset var lcl = structNew()>
    	<cfset var itm = variables.controller.getModel(requestObject=variables.requestObject)>
        <cfset var count = "">
		
		<cfset count = itm.getEvent( id = variables.eventid ).recordcount>
        <cfset assertequals(expected=1,actual=count,message="did not find correct event")>
		
		<cfset lcl.flag = 0>
		<cfset lcl.qry = itm.getEventsList()>
		<cfif lcl.qry.recordcount>
			<cfloop query="lcl.qry">
				<cfif variables.eventid eq lcl.qry.id>
					<cfset lcl.flag = 1>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
        <cfset assertequals(expected=1,actual=lcl.flag,message="did not find my event in events listing")>
		
		<cfset lcl.flag = 0>
		<cfset lcl.qry = itm.getHomePageItems()>
		<cfif lcl.qry.recordcount>
			<cfloop query="lcl.qry">
				<cfif variables.eventid eq lcl.qry.id>
					<cfset lcl.flag = 1>
					<cfbreak>
				</cfif>
			</cfloop>
		</cfif>
        <cfset assertequals(expected=1,actual=lcl.flag,message="did not find my event in homepage listing")>
		
    </cffunction>
    
    <!--- ctrlr tests --->
    <cffunction name="testShowHTML">
        <cfset var data = structnew()>
		<cfset var furl = structnew()>
        <cfset var html = "">
		
		<!--- event listing --->
		<cfset data.view = "list"> 
    	<cfset loadController(data = data)>
		<cfset html = variables.controller.showHTML()>
        <cfset asserttrue(condition = refind('<ul class="events">.*</ul>',html),message="did not find matching ul elements")>
        <cfset asserttrue(condition = refind('<li>.*</li>',html),message="did not find matching li elements")>
        <cfset asserttrue(condition = refind('<a .*#variables.unittestname#.*</a>',html),message="did not find event link")>
		
		<!--- event item --->
		<cfset data.view = "item"> 
		<cfset data.eventid = variables.eventid> 
		<cfset furl.path = "/register/#variables.eventid#/">
		<cfset lcl.decRequestObject = createobject('component', 'resources.altformurlRequestDecorator').init(requestObject)>
		<cfset lcl.decRequestObject.setRequestFields(furl)> 
    	<cfset loadController(data = data, requestObject=lcl.decRequestObject)>
		<cfset html = variables.controller.showHTML()>
        <cfset asserttrue(condition = refind('<div class="eventView">.*</div>',html),message="did not find matching div elements")>
        <cfset asserttrue(condition = refind(variables.unittestname,html),message="did not find test event html")>
    </cffunction>
	
    <cffunction name="testRegistrationForm">
		<cfset var lcl = structNew()>
        <cfset var vdtr = createObject('component', 'utilities.datavalidator').init()>
        <cfset var data = structnew()>
		<cfset var furl = structnew()>
        <cfset var html = "">
		
		<!--- test validate registration form --->
		<cfset furl.email = ''>
		<cfset furl.fname = ''>
		<cfset furl.lname = ''>
		<cfset furl.title = ''>
		<cfset furl.companyName = ''>
		<cfset furl.add1 = ''>
		<cfset furl.add2 = ''>
		<cfset furl.city = ''>
		<cfset furl.comment = ''>
		<cfset furl.zip = ''>
		<cfset furl.phone = ''>
		<cfset lcl.decRequestObject = createobject('component', 'resources.altformurlRequestDecorator').init(requestObject)>
		<cfset lcl.decRequestObject.setRequestFields(furl)> 
		<cfset lcl.itm = variables.controller.getModel(requestObject=lcl.decRequestObject)>
		<cfset lcl.itm.registrationValidate(vdtr=vdtr)>		
        <cfset assertequals(expected=1,actual=vdtr.fieldHasError('email'),message="registration did not validate correctly")>
		
		<!--- test register user --->
		<cfset furl.email = 'test@spiremedia.com'>
		<cfset furl.fname = 'Test'>
		<cfset furl.lname = 'Test'>
		<cfset furl.title = 'Test'>
		<cfset furl.companyName = 'Test'>
		<cfset furl.add1 = 'Test'>
		<cfset furl.add2 = 'Test'>
		<cfset furl.city = 'Test'>
		<cfset furl.state = 'Test'>
		<cfset furl.comment = 'Test'>
		<cfset furl.zip = 'Test'>
		<cfset furl.phone = 'Test'>
		<cfset furl.eventid = variables.eventid>
		<cfset lcl.decRequestObject = createobject('component', 'resources.altformurlRequestDecorator').init(requestObject)>
		<cfset lcl.decRequestObject.setRequestFields(furl)> 
		<cfset lcl.itm = variables.controller.getModel(requestObject=lcl.decRequestObject)>
		<cfset lcl.itm.registeruser(variables.eventid)>		
		<cfquery name="lcl.me" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT * FROM eventAttendees WHERE eventid = <cfqueryparam value="#variables.eventid#" cfsqltype="cf_sql_varchar">
		</cfquery>		
        <cfset assertequals(expected=1,actual=lcl.me.recordcount,message="did not register user properly")>
    </cffunction>
    
    <cffunction name="testGetPagesforSiteSearch">
        <cfset var data = structnew()>
        <cfset var html = "">
        <cfset var aggregator = createobject('component','modules.search.searchableaggregator').init(requestObject=variables.requestObject)>
		
		<cftry>
        	<cfset variables.controller.getPagesforSiteSearch( aggregator = aggregator)>
            <cfcatch>
            	<cfset fail("event search indexing fails : #cfcatch.message#")>
            </cfcatch>
        </cftry>
    </cffunction> 

</cfcomponent>