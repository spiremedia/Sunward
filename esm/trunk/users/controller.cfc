<cfcomponent name="Users" extends="resources.abstractController">
	
	<cffunction name="getUsersModel">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset  mdl = createObject('component','users.models.users').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','users.models.logs').init(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
	
	<cffunction name="getLogObj">
		<cfargument name="requestObject">
		<cfargument name="userObj">

		<cfreturn createObject('component','users.models.logs').init(arguments.requestObject, arguments.userObj)>
	</cffunction>
	
	<cffunction name="StartPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var usermodel = getUsersModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = createObject('component','users.models.logs').init(arguments.requestObject, arguments.userObj)>
		
		<cfset displayObject.setData('userlist', usermodel.getUsers())>
		<cfset displayObject.setData('recentActivity', logs.getRecentHistory(userobj))>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="adduser">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var usermodel = getUsersModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getlogObj(argumentcollection = arguments)>
		<cfset var worldinfo = createObject('component','utilities.worldinfo').init(arguments.requestObject)>
						
		<cfset displayObject.setData('userlist', usermodel.getUsers())>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		<cfset displayObject.setData('states', worldinfo.getStates())>
		
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('itemhistory', logs.getItemHistory(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('userinfo', 
				usermodel.getUser(
					requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('userid', 
					requestObject.getformurlvar('id'))>
		<cfelse>
			<cfset displayObject.setData('userinfo', 
				usermodel.getUser(0))>
			<cfset displayObject.setData('userid', 0)>
		</cfif>
		
		<cfset displayObject.setWidgetOpen('mainContent','1,2')>
			
		<cfif requestObject.isformurlvarset('search')>
			<cfset displayObject.setData('usersearch', 
				usermodel.searchUser(
					requestObject.getformurlvar('search')))>
		</cfif>

		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('maincontent')>
		
		<cfreturn displayObject>
		
	</cffunction>
	

	<cffunction name="Search">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var usermodel = getUsersModel(arguments.requestObject, arguments.userObj)>
							
		<cfset displayObject.setData('userlist', usermodel.getUsers())>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>

		<cfset displayObject.setData('searchinfo', 
			usermodel.search(
				requestObject.getformurlvar('searchkeyword')))>
	
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('maincontent')>
		
		<cfreturn displayObject>
		
	</cffunction>

	<cffunction name="edituser">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addUser(displayObject,requestObject,userobj,dispatcher)>
	</cffunction>
	
	<cffunction name="SaveUser">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var usermodel = getUsersModel(arguments.requestObject, arguments.userObj)>
				
		<cfset var requestvars = requestobject.getallformurlvars()>
		
		<cfset usermodel.setValues(requestVars)>
			
		<cfset vdtr = usermodel.validate()>
		
		<cfif vdtr.passvalidation()>
			<cfset lcl.id = usermodel.save()>
			<cfset lcl.msg = structnew()>
			<cfif requestObject.isformurlvarset('id') AND requestObject.getformurlvar('id') NEQ 0 AND requestObject.getformurlvar('id') NEQ ''>
				<cfset lcl.msg.message = "User Saved">
			<cfelse>
				<cfset lcl.msg.message = "User Added">
				<cfset lcl.msg.switchtoedit = lcl.id>
			</cfif>
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/Users/Browse/?id=#lcl.id#">
			<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
			<cfset lcl.msg.clearvalidation = 1>
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
	</cffunction>

	<cffunction name="DeleteUser">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var usermodel = getUsersModel(arguments.requestObject, arguments.userObj)>
		
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to delete User">
		</cfif>
		
		<cfset vdtr = usermodel.validateDelete(requestObject.getformurlvar('id'))>
		
		<cfif vdtr.passvalidation()>
			<cfset usermodel.deleteUser(requestObject.getformurlvar('id'))> 
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The User has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/Users/Browse/">
			<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>The User has been Deleted </div>">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
	</cffunction>
	
	<cffunction name="Browse">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var usermodel = getUsersModel(arguments.requestObject, arguments.userObj)>
						
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('userid', requestObject.getformurlvar('id'))>	
		</cfif>
		
		<cfset displayObject.setData('userlist', usermodel.getUsers())>
		<cfset displayObject.renderTemplate('html')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="getAvailableUsers">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
	
		<cfset var usermodel = getUsersModel(arguments.requestObject, arguments.userObj)>
								
		<cfreturn userModel.getUsers()>
	</cffunction>
	
	<cffunction name="checkLoginCredentials">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var usermodel = getUsersModel(arguments.requestObject, arguments.userObj)>
								
		<cfreturn userModel.checkLoginCredentials(
			requestObject.getFormUrlVar('username'),
				requestObject.getFormUrlVar('password'))>
	</cffunction>
</cfcomponent>