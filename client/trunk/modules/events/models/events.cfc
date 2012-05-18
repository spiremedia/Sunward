<cfcomponent name="Events" extends="resources.abstractModel">
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfreturn this>	
	</cffunction>
	<cffunction name="getEventsList">
		<cfset var me = "">
		<cfquery name="me" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT name, id, title, location, startdate, enddate, description
			FROM events_view
			WHERE enddate IS NULL OR enddate > getDate() 
			AND active = 1
			ORDER BY startdate ASC
		</cfquery>
		<cfreturn me>
	</cffunction>
	
	<cffunction name="getEvent">
		<cfargument name="id" required="true">
		<cfset var me = "">
		<cfquery name="me" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT e.id, e.title, e.location, e.startdate, e.enddate, 
			e.description, e.maplink, e.showmaterialsform, e.showaddtlattendees,
			 a.name, a.filesize, a.filename
			FROM events_view e
			LEFT OUTER JOIN assets_view a ON a.id = e.agendaassetid
			WHERE e.id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		<cfreturn me>
	</cffunction>
	
	<cffunction name="getHomePageItems">
		<cfset var me = "">
		<cfquery name="me" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT e.id, e.title, e.startdate, e.enddate, e.location
			FROM events_view e
			LEFT OUTER JOIN assets_view a ON a.id = e.agendaassetid
			WHERE e.onhomepage = 1 
			AND e.active = 1
		</cfquery>
		<cfreturn me>
	</cffunction>
	
	<cffunction name="registrationValidate">
		<cfargument name="vdtr" required="true">
		<cfset var info = variables.requestObject.getAllFormUrlVars()>
		<cfset var me = "1">
		
		<cfset vdtr.validEmail('email', info.email, 'A valid Email is required')>
		<cfset vdtr.lengthbetween('email',1,250, 'The email may not be longer than 250 chars')>
		<cfset vdtr.lengthbetween('fname',1, 50, info.fname, 'First Name is required and may not be longer than 50 chars')>
		<cfset vdtr.lengthbetween('lname', 1, 50, info.lname, 'Last Name is required and may not be longer than 50 chars')>
		<cfset vdtr.maxlength('title', 40, info.title, 'Title may not be longer than 40 chars')>
		<cfset vdtr.lengthbetween('companyName', 1, 100, info.companyName, 'Company Name is required may not be longer than 100 chars')>
				
		<cfset vdtr.maxlength('add1', 255, info.add1, 'The Address may not be longer than 255 chars')>
		<cfset vdtr.maxlength('add2', 255, info.add2, 'The second address may not be longer than 255 chars')>
		
		<cfset vdtr.maxlength('city', 50, info.city, 'A City is required and may not be longer than 50 chars')>
        <cfset vdtr.maxlength('comment', 500, info.comment, 'The Comment may not be longer than 500 chars')>
		<!--- <cfset vdtr.notBlank('state', info.state, 'A State is required')> --->
		<cfset vdtr.maxlength('zip', 15, info.zip, 'A Zip is required and may not be longer than 15 chars')>
		<cfset vdtr.lengthbetween('phone',  1, 50, info.phone, 'A Phone Number is required and may not be longer than 50 chars')>
		<cfif structkeyexists(info, 'attlattendees')>
			<cfset vdtr.maxlength('addtlattendeesinfo', 499, info.addtlattendeesinfo, 'The additional attendees field may not be longer than 255 chars')>
        </cfif>
<!---
			email is real
			required : firstname, lastname, title, companyname, add1,add2, city, state, zip
			phone is 9 digit
		--->
	</cffunction>
	
	<cffunction name="sendConfirmationMessage">
		<cfargument name="evtinfo" required="true">
		<cfset var emailObj = createObject('component', 'resources.email').init(variables.requestObject)>
		<cfset var body = "">		
<cfset emailObj.setRecipient(requestObject.getFormUrlVar('email'))>
		<cfset emailObj.setSender(requestObject.getVar('systememailfrom'))>
		<cfset emailObj.setSubject('Event Registration Confirmation')>
		
		<cfoutput>
		<cfsavecontent variable="body">Thank you for using our online registration form.<br><br>

You are now registered to attend #evtinfo.title# on #dateformat(evtinfo.startdate,"mm/dd/yyyy")#.<br><br>

Please refer back to <a href="#requestObject.getVar('siteurl')#NewsAndEvents/Event/#evtinfo.id#/">#evtinfo.title#</a> for details about the event.<br><br>
This email will serve as a confirmation of your reservation to attend this event. You will not receive any other confirmation in the mail. 
		</cfsavecontent>
		</cfoutput>
		<cfset emailObj.setBody(body)>
		<cfset emailObj.sendMessage()>
	</cffunction>
	
	<cffunction name="registeruser">
		<cfargument name="eventId" required="true">
		<cfset var me = "">
		<cfset var id = createuuid()>
		<cfset var info = variables.requestObject.getAllFormUrlVars()>
		<cfparam name="info.materials" default="0">
        <cfparam name="info.addtlattendeescount" default="0">
        <cfparam name="info.addtlattendeesinfo" default="">
		
		<cfquery name="me" datasource="#variables.requestObject.getVar('dsn')#">
			INSERT INTO eventAttendees (
				id,
				email,
				fname,
				lname,
				title,
				phone,
				companyname,
				add1,
				add2,
				city,
				state,
				zip,
				addtlattendeescount,
                addtlattendeesinfo,
				eventid,
				siteid,
				wantsmaterials,
                comment
			) VALUES (
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar" maxlength="35">,
				<cfqueryparam value="#info.email#" cfsqltype="cf_sql_varchar" maxlength="250">,
				<cfqueryparam value="#info.fname#" cfsqltype="cf_sql_varchar" maxlength="50">,
				<cfqueryparam value="#info.lname#" cfsqltype="cf_sql_varchar" maxlength="50">,
				<cfqueryparam value="#info.title#" cfsqltype="cf_sql_varchar" maxlength="40">,
				<cfqueryparam value="#info.phone#" cfsqltype="cf_sql_varchar" maxlength="50">,
				<cfqueryparam value="#info.companyname#" cfsqltype="cf_sql_varchar" maxlength="100">,
				<cfqueryparam value="#info.add1#" cfsqltype="cf_sql_varchar" maxlength="255">,
				<cfqueryparam value="#info.add2#" cfsqltype="cf_sql_varchar"  maxlength="255">,
				<cfqueryparam value="#info.city#" cfsqltype="cf_sql_varchar"  maxlength="50">,
				<cfqueryparam value="#info.state#" cfsqltype="cf_sql_varchar"  maxlength="50">,
				<cfqueryparam value="#info.zip#" cfsqltype="cf_sql_varchar" maxlength="12">,
				<cfqueryparam value="#info.addtlattendeescount#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#info.addtlattendeesinfo#" cfsqltype="cf_sql_varchar" maxlength="500">,
                <cfqueryparam value="#arguments.eventid#" cfsqltype="cf_sql_varchar"  maxlength="35">,
				<cfqueryparam value="#variables.requestObject.getVar('siteid')#" cfsqltype="cf_sql_varchar" maxlength="40">,
				<cfqueryparam value="#info.materials#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#info.comment#" cfsqltype="cf_sql_varchar" maxlength="500">
			)
		</cfquery>

		<cfreturn 1>
	</cffunction>
	
</cfcomponent>