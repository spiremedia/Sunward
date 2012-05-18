<cfcomponent name="Forms" extends="resources.abstractController">
	
	<cffunction name="AddForm">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var model = getFormsModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getlogObj(argumentcollection = arguments)>
		<cfset var temp = structnew()>	
				
		<cfset displayObject.setData('list', model.getForms())>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		<cfset displayObject.setData('userobj', arguments.userobj)>
		<cfset displayObject.setData('availableUsers', dispatcher.callExternalModuleMethod('users','getAvailableUsers', requestObject, userobj) )>
		
		<cfif requestObject.isformurlvarset('id')>
			<!--- <cfset model.load(requestObject.getformurlvar('id'))> --->
			<cfset displayObject.setData('itemhistory', logs.getItemHistory(requestObject.getformurlvar('id')))>
			<cfset temp.siteinfo = application.sites.getSite(arguments.userobj.getCurrentSiteId())>
			<cfset displayObject.setData('info', model.getForm(requestObject.getformurlvar('id')))>
			<cfset displayObject.setWidgetOpen('mainContent','1,2')>			
		<cfelse>
			<cfset displayObject.setData('info', model.getForm(0))>
		</cfif>
		
		<cfif requestObject.isformurlvarset('sortdir')>
			<cfset displayObject.setWidgetOpen('mainContent','1,3')>
		</cfif>
			
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
	
	<cffunction name="Browse">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var model = getFormsModel(arguments.requestObject, arguments.userObj)>
						
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>	
		</cfif>
		
		<cfset displayObject.setData('list', model.getForms())>
		<cfset displayObject.renderTemplate('html')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="deleteClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = createObject('component', 'forms.models.widget').init(requestObject, userobj)>
				
		<cfset model.deleteItem(requestObject.getFormUrlVar('id'))>
		
		<cfset lcl.reloadBase = 1>
		<cfset displayObject.sendJson( lcl )>
	</cffunction>
	
	<cffunction name="DeleteForm">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getFormsModel(arguments.requestObject, arguments.userObj)>
		
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to delete Form">
		</cfif>
		
		<cfset vdtr = model.validateDelete(requestObject.getformurlvar('id'))>
		
		<cfif vdtr.passvalidation()>
			<cfset model.deleteForm(requestObject.getformurlvar('id'))>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Form has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/Forms/Browse/">
			<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>Form Deleted</div>">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>

	</cffunction>
	
	<cffunction name="DownloadFormData">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfscript>
			var model = getFormsModel(arguments.requestObject, arguments.userObj);
			var requestvars = requestobject.getallformurlvars();
			//var qryForm = queryNew("");
			var qryFormSubmission = queryNew("");
			var lcl = structNew();
			
			//qryForm = model.getForm(id = requestvars.id);
			qryFormSubmission = model.getFormSubmission(id = requestvars.id);
			
			switch (requestvars.format)
			{
				case 'xml':
					displayObject.sendXML(
						model.setFormDataXML(qryFormSubmission = qryFormSubmission)
					);
					break;
				case 'xls':
				default:
					lcl.xlsStruct = model.setFormDataXLS(qryFormSubmission = qryFormSubmission);
					displayObject.sendXLS(
						data = lcl.xlsStruct.qry,
						altColumnList = lcl.xlsStruct.headers
					);
					break;
			}
		</cfscript>
		
	</cffunction>
	
	<cffunction name="editClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var formsmodel = getFormsModel(arguments.requestObject, arguments.userObj)>
		
		<cfset widgetsmodel = createObject('component','forms.models.widget').init(arguments.requestObject, arguments.userObj)>
		<cfset displayObject.setData('widgetsmodel', widgetsmodel)>
		<cfset displayObject.setData('formsmodel', formsmodel)>
		
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="EditForm">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn AddForm(displayObject,requestObject,userObj,dispatcher)>
	</cffunction>
	
	<cffunction name="EditFormWizard">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfset var model = getFormsModel(arguments.requestObject, arguments.userObj)>
		<cfset var temp = structnew()>	
				
		<cfset displayObject.setData('list', model.getForms())>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		<cfset displayObject.setData('userobj', arguments.userobj)>
		
		<cfif requestObject.isformurlvarset('id')>
			<!--- <cfset model.load(requestObject.getformurlvar('id'))> --->
			<cfset temp.siteinfo = application.sites.getSite(arguments.userobj.getCurrentSiteId())>
			<cfset displayObject.setData('info', model.getForm(requestObject.getformurlvar('id')))> 
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>
		<cfelse>
			<cfset displayObject.setData('info', model.getForm(0))>
		</cfif>

		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('maincontent')> 
		
		<cfreturn displayObject>
		
	</cffunction>
	
	<cffunction name="FormData">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getFormsModel(arguments.requestObject, arguments.userObj)>
		
		<cfset displayObject.setData('list', model.getForms())>
		<cfset displayObject.setData('searchResults', model.getFormData())>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="getAvailableForms">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
	
		<cfset var model = getFormsModel(arguments.requestObject, arguments.userObj)>
								
		<cfreturn model.getForms()>
	</cffunction>
	
	<cffunction name="getFormsModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','forms.models.forms').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','forms.models.logs').init(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
	
	<cffunction name="getLogObj">
		<cfargument name="requestObject">
		<cfargument name="userObj">

		<cfreturn createObject('component','forms.models.logs').init(arguments.requestObject, arguments.userObj)>
	</cffunction>
	
	<cffunction name="SaveForm">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = getFormsModel(arguments.requestObject, arguments.userObj)>
				
		<cfset var requestvars = requestobject.getallformurlvars()>
		
		<cfset model.setValues(requestVars)>
				
		<cfset vdtr = model.validate()>
		
		<cfif vdtr.passValidation()>
			<cfset lcl.id = model.save()> 
			<cfset lcl.msg = structnew()>
			
			<cfif requestObject.isformurlvarset('id') AND requestObject.getformurlvar('id') NEQ 0 AND requestObject.getformurlvar('id') NEQ ''>
				<cfset lcl.msg.message = "The Form has been Saved.">
				<cfset lcl.msg.ajaxupdater = structnew()>
				<cfset lcl.msg.ajaxupdater.url = "/Forms/Browse/?id=#lcl.id#">
				<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
				<cfset lcl.msg.clearvalidation = 1>
			<cfelse>
				<cfset lcl.msg.message = "The Form has been Added.">
				<cfset lcl.msg.relocate = "/Forms/EditForm/?id=#lcl.id#&msg=#lcl.msg.message#">
			</cfif>
			
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
	</cffunction>
	
	<cffunction name="SaveFormWizard">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getFormsModel(arguments.requestObject, arguments.userObj)>
		<cfset var requestvars = requestobject.getallformurlvars()>

		<cfset objString = CreateObject('component', 'utilities.string').init()>
		<cfset requestvars.definition = objString.htmlentities
				(
					objString.parseHtml
					(
						strHtml = requestvars.definition,
						asXhtml = true
					)
				)>
	
		<cfset model.setValues(requestVars)>
		<cfset vdtr = model.validateFormWizard()>
		<cfset lcl.msg = structnew()>
		<cfif vdtr.passValidation()>
			<cfset lcl.id = model.saveFormWizard()>
			<cfset lcl.msg.reloadBase = 1>
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
	</cffunction>
	
	<cffunction name="Search">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getFormsModel(arguments.requestObject, arguments.userObj)>
		
		<cfset displayObject.setData('list', model.getForms())>
		<cfset displayObject.setData('searchResults', model.search(arguments.requestObject.getFormUrlVar('searchkeyword')))>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="StartPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var model = getFormsModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = createObject('component','forms.models.logs').init(requestObject, userobj)>

		<cfset displayObject.setData('list', model.getForms())>
		<cfset displayObject.setData('recentActivity', logs.getRecentHistory(userobj))>
		
		<cfset displayObject.renderTemplate('browsecontent')>		
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="saveClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var model = createObject('component', 'forms.models.widget').init(requestObject, userobj)>
		<cfset var lcl = structnew()>
		
		<cfset var requestvars = requestobject.getallformurlvars()>

		<cfset model.setValues(requestVars)>
		<!---><cfset model.setSecurityItemsFromXml(dispatcher.getSecurityItems())>--->
			
		<cfset vdtr = model.validate()>
		
		<cfif vdtr.passvalidation()>
			<cfset model.save()> 
			<cfset lcl.reloadBase = 1>
			<cfset displayObject.sendJson( lcl )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
	</cffunction>
	
	<cffunction name="inplaceeditorcallback">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfset displayObject.showHTML(requestObject.getFormUrlVar('value'))>
	</cffunction>
</cfcomponent>