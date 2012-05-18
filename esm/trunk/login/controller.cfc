<cfcomponent name="Security" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfset variables.request = arguments.request>
		<cfreturn this>
	</cffunction>
			
	<cffunction name="getModel">
		<cfreturn createObject('component','login.models.announcments').init(arguments.requestObject, arguments.userObj)>
	</cffunction>		
			
	<cffunction name="getLoginModel">
		<cfreturn createObject('component','login.models.login').init(arguments.requestObject, arguments.userObj)>
	</cffunction>		
	
	<cffunction name="LoginForm">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset displayObject.setData('requestObj',requestObject)>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="chooseSite">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset displayObject.setData('siteslist', application.sites.getSites())>
		<cfset displayObject.setData('requestObject', requestObject)>
		
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
				
	<cffunction name="Welcome">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset displayObject.renderTemplate('mainContent')>
		<cfset displayObject.renderTemplate('title')>

		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="checkLogin">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var vdtr = "">
		<cfset var fields = structnew()>
		<cfset var lcl = structnew()>
		<cfset var user = "">
		<cfset var sites = application.sites.getSites()>
		<cfset var loginmodel = getLoginModel(argumentcollection = arguments)>
		
		<cfif NOT (requestObject.isformurlvarset('username') AND
			requestObject.isformurlvarset('password'))>
			<cfset lcl.msg = structnew()>	
			<cfset lcl.message = "Please fill in the username and password fields.">
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
			
		<cfset fields.username=requestObject.getformurlvar('username')>
		<cfset fields.password=requestObject.getformurlvar('password')>
			
		<cfset vdtr = createObject('component','utilities.datavalidator').init()>
		
		<cfset vdtr.validemail('username',fields.username, 'The username must be a valid email')>
		<cfset vdtr.lengthbetween('password',5,15,fields.password, 'The password must be between 5 and 15 chars long')>
		
		<cfif NOT vdtr.passValidation()>			
			<cfset lcl.msg = structnew()>	
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
		<cfset user = dispatcher.callExternalModuleMethod('users','checkLoginCredentials', requestObject, userObj) >
			
		<cfif user.recordcount EQ 0>
			<cfset vdtr.addError('password','These credentials did not match what is in the database. Please retype them and try again.')>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
		<cfset session.user.setUserName(user.username)>
		<cfset session.user.setFirstName(user.fname)>
		<cfset session.user.setLastName(user.lname)>
		<cfset session.user.setSuper(user.issuper)>
		<cfset session.user.setUserID(user.id)>
		<cfif Sites.recordcount EQ 1>
			<cfset session.user.setCurrentSiteId(sites.id, application.sites)>
		</cfif>
		<cfset requestobject.setVar('userid', user.id)>
		
		<!--- record user ip --->
		<cfset loginmodel.addSecurityIP( ip = CGI.REMOTE_ADDR, userid = user.id )>

		<cfif session.user.getCurrentSiteID() EQ 0>
			<cfset lcl.msg.relocate = '/login/chooseSite/'>
		<cfelse>
			<cfset lcl.msg.relocate = '/login/startPage/'>
		</cfif>
		
		<cfset displayObject.sendJson( lcl.msg )>
	</cffunction>
	
	<cffunction name="dumpuser">
		<cfset session.user.dump()>
		<cfabort>
	</cffunction>
	
	<cffunction name="addAnnouncement">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var temp = structnew()>	
					
		<cfif requestObject.isformurlvarset('id')>
			<cfset model.load(requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('info', model)>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>
		<cfelse>
			<cfset displayObject.setData('info', model.Load(0))>
		</cfif>

		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('maincontent')>
		
		<cfreturn displayObject>
		
	</cffunction>
	
	<cffunction name="editAnnouncement">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addAnnouncement(displayObject,requestObject,userObj,dispatcher)>
	</cffunction>
	
	<cffunction name="SaveAnnouncement">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = getmodel(argumentcollection = arguments)>
				
		<cfset var requestvars = requestobject.getallformurlvars()>
				
		<cfset model.setValues(requestVars)>
				
		<cfset vdtr = model.validate()>
		
		<!-- file upload requests can't go thru ajax. resubmit -->
		<cfif vdtr.passValidation()>
			<cfset lcl.id = model.save()>
			<cfset lcl.msg = structnew()>
			<cfif requestObject.isformurlvarset('id') AND requestObject.getformurlvar('id') NEQ 0>
				<cfset lcl.msg.message = "Announcement Updated">
			<cfelse>
				<cfset lcl.msg.message = "Announcment Inserted">
				<cfset lcl.msg.relocate = "/login/editAnnouncement/?id=#lcl.id#&msg=#lcl.msg.message#">
			</cfif>
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
			
	</cffunction>
	
	<cffunction name="startPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getmodel(argumentcollection = arguments)>
		
		<cfif userObj.isallowed('login','Edit Announcement')>
			<cfset displayObject.setData('list', model.getAnnouncments(active = false))>
		<cfelse>
			<cfset displayObject.setData('list', model.getAnnouncments())>
		</cfif>
		<cfset displayObject.setData('requestObject', requestObject)>
	
		
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('maincontent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="DeleteAnnouncment">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getmodel(argumentcollection = arguments)>

		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to delete Announcment">
		</cfif>
		
		<cfset vdtr = model.validateDelete(requestObject.getformurlvar('id'))>
		
		<cfif vdtr.passvalidation()>
			<cfset model.deleteAnnouncment(requestObject.getformurlvar('id'))>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>The Announcment has been deleted</div>">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>

	</cffunction>
</cfcomponent>


<!--- <action name="Start Page" template="onecolumnnonav">
		<template name="loginForm" title="loginForm" file="loginform.cfm"/>
	</action>

	<action name="Welcome" template="onecolumnwnavigation">
		<template name="title" title="welcome" file="welcomelabel.cfm"/>
		<template name="mainContent" title="Properties" file="welcomeContent.cfm"/>
	</action>

	<action name="checkLogin" method="checkLogin"/>
 --->