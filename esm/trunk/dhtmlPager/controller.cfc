<cfcomponent name="dhtmlpager" extends="resources.abstractController">
	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfset variables.request = arguments.request>
		<cfreturn this>
	</cffunction>
    
	<cffunction name="editClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var widgetsmodel = createObject('component','dhtmlpager.models.widgetModel').init(arguments.requestObject, arguments.userObj)>
		
		<cfset displayObject.setData('widgetsmodel', widgetsmodel)>
 
        <cfset displayObject.setData('itemsjson', getUtility('json').encode(widgetsmodel.getinfo().items))>
		<cfset displayObject.setWidgetOpen('mainContent','1,2')>
        
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
		
	<cffunction name="saveClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var model = createObject('component', 'dhtmlpager.models.widgetmodel').init(requestObject, userobj)>
		<cfset var lcl = structnew()>
		<cfset var reinfo = structnew()>
		<cfset var requestvars = requestobject.getallformurlvars()>

		<cfset requestvars.items = getUtility('json').decode(requestvars.items)>
		
		<cfset model.setValues(requestVars)>
			
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
	
	<cffunction name="deleteClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = createObject('component', 'dhtmlpager.models.widgetmodel').init(requestObject, userobj)>
				
		<cfset model.deleteItem(requestObject.getFormUrlVar('id'))>
		
		<cfset lcl.reloadBase = 1>
		<cfset displayObject.sendJson( lcl )>
	</cffunction>
</cfcomponent>