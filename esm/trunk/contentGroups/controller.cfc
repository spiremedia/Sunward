<cfcomponent name="Content Groups" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getContentGroupsModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','contentgroups.models.contentgroups').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','contentgroups.models.logs').init(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>	
	
	<cffunction name="getLogObj">
		<cfargument name="requestObject">
		<cfargument name="userObj">

		<cfreturn createObject('component','contentgroups.models.logs').init(arguments.requestObject, arguments.userObj)>
	</cffunction>
	
	<cffunction name="StartPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var model = getContentGroupsModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = createObject('component','contentgroups.models.logs').init(requestObject, userobj)>
		
		<cfset displayObject.setData('list', model.getContentGroups())>
		<cfset displayObject.setData('recentActivity', logs.getRecentHistory(userobj))>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="addContentGroup">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var model = getContentGroupsModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getlogObj(argumentcollection = arguments)>
					
		<!---><cfset displayObject.setData('securityItems', dispatcher.getSecurityItems())>--->
		<cfset displayObject.setData('list', model.getContentGroups())>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		<cfset displayObject.setData('availableUsers', dispatcher.callExternalModuleMethod('users','getAvailableUsers', requestObject, userobj) )>
		<cfset displayObject.setData('sitePages', dispatcher.callExternalModuleMethod('pages','getPages', requestObject, userobj) )>
		<cfset displayObject.setData('assetGroups', dispatcher.callExternalModuleMethod('assets','getAvailableAssetGroups', requestObject, userobj) )>

		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('info', model.getContentGroup(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('itemhistory', logs.getItemHistory(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('id',requestObject.getformurlvar('id'))>
		<cfelse>
			<cfset displayObject.setData('info', model.getContentGroup(0))>
			<cfset displayObject.setData('id', 0)>
		</cfif>
	
		<cfset displayObject.setWidgetOpen('mainContent','1,2,3')>
			
		<cfif requestObject.isformurlvarset('search')>
			<cfset displayObject.setData('search', 
				model.search(
					requestObject.getformurlvar('search')))>
		</cfif>

		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('maincontent')>
		
		<cfreturn displayObject>
		
	</cffunction>
	
	<cffunction name="editContentGroup">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addContentGroup(displayObject,requestObject,userobj, dispatcher)>
	</cffunction>
	
	<cffunction name="SaveContentGroup">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = getContentGroupsModel(arguments.requestObject, arguments.userObj)>
				
		<cfset var requestvars = requestobject.getallformurlvars()>

		<cfset model.setValues(requestVars)>
		<!---><cfset model.setSecurityItemsFromXml(dispatcher.getSecurityItems())>--->
			
		<cfset vdtr = model.validate()>
		
		<cfif vdtr.passvalidation()>
			<cfset lcl.id = model.save()>
			<cfset lcl.msg = structnew()>
			<cfif requestObject.getFormUrlVar('id') EQ 0>
				<cfset lcl.msg.message = "Content Group Added">
				<cfset lcl.msg.switchtoedit = lcl.id>
			<cfelse>
				<cfset lcl.msg.message = "Content Group Updated">
			</cfif>
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/ContentGroups/Browse/?id=#lcl.id#">
			<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
			<cfset lcl.msg.clearvalidation = 1> 
				
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
	</cffunction>
		
	<cffunction name="DeleteContentGroup">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getContentGroupsModel(arguments.requestObject, arguments.userObj)>
		
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to deletecontentgroup">
		</cfif>
		
		<cfset vdtr = model.validateDelete(requestObject.getformurlvar('id'))>
		
		<cfif vdtr.passvalidation()>
			<cfset model.deletegroup(requestObject.getformurlvar('id'))> 
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Group has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/ContentGroups/Browse/">
			<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>Content Group Deleted</div>">
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
		
		<cfset var model = getContentGroupsModel(arguments.requestObject, arguments.userObj)>
						
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>	
		</cfif>
		
		<cfset displayObject.setData('list', model.getContentGroups())>
		<cfset displayObject.renderTemplate('html')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="getUserLocations">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
				
		<cfset var model = getContentGroupsModel(arguments.requestObject, arguments.userObj)>
		
		<cfreturn model.getUserLocations(requestObject.getvar('userid'))>
	</cffunction>
	
	<cffunction name="groupSearch">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getContentGroupsModel(arguments.requestObject, arguments.userObj)>
		
		<cfset displayObject.setData('list', model.getContentGroups())>
		<cfset displayObject.setData('searchResults', model.search(arguments.requestObject.getFormUrlVar('searchkeyword')))>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>

</cfcomponent>