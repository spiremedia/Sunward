<cfcomponent name="contentLink" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfset variables.request = arguments.request>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="add">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var info = "">
				
		<cfif not arguments.requestObject.isformurlvarset('name')>
			<cfthrow message="error in edit page - name url var not set">
		</cfif>
		
		<cfif not arguments.requestObject.isformurlvarset('pageid')>
			<cfthrow message="error in edit page - name pageid var not set">
		</cfif>
		
		<cfif not arguments.requestObject.isformurlvarset('info')>
			<cfthrow message="error in edit page - info url var not set">
		</cfif>
		
		<cfif not arguments.requestObject.isformurlvarset('siteid')>
			<cfthrow message="error in edit page - info siteid var not set">
		</cfif>
		        
		<cfif arguments.userObj.getCurrentSiteId() NEQ arguments.requestObject.getFormUrlVar('siteid')>
			WRONG SITE IS BEING EDITED. PLEASE RELOGIN<cfabort>
		</cfif>

		<cfset info = variables.getUtility('json', arguments).decode( arguments.requestObject.getFormUrlVar('info') )>
		<cfset info.pageid = arguments.requestObject.getFormUrlVar('pageid')>
		<cfset info.objname = arguments.requestObject.getFormUrlVar('name')>
	
		<cfset displayObject.setData('info', info )>

		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="edit">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
        <cfargument name="dispatcher" required="true">

		<cfset var itm = "">
        <cfset var info = "">
				
		<cfif not arguments.requestObject.isformurlvarset('id')>
			<cfthrow message="error in edit page - id url var not set">
		</cfif>
        
        <cfif arguments.userObj.getCurrentSiteId() NEQ arguments.requestObject.getFormUrlVar('siteid')>
			WRONG SITE IS BEING EDITED. PLEASE RELOGIN<cfabort>
		</cfif>
        
		<!--- TODO determine if this is useful. say if something has changed and id not relevant. 
		<cfif not arguments.requestObject.isformurlvarset('pageid')>
			<cfthrow message="error in edit page - name pageid var not set">
		</cfif>
		
		<cfif not arguments.requestObject.isformurlvarset('info')>
			<cfthrow message="error in edit page - info url var not set">
		</cfif>
		
		<cfif not arguments.requestObject.isformurlvarset('siteid')>
			<cfthrow message="error in edit page - info siteid var not set">
		</cfif>--->
		
		<cfif arguments.userObj.getCurrentSiteId() NEQ arguments.requestObject.getFormUrlVar('siteid')>
			WRONG SITE IS BEING EDITED. PLEASE RELOGIN<cfabort>
		</cfif>
 		
		<cfset info = variables.getUtility('json', arguments).decode( arguments.requestObject.getFormUrlVar('info') )>
		<cfset info.pageid = arguments.requestObject.getFormUrlVar('pageid')>
		
        <cfquery name="info.items" datasource="#arguments.requestObject.getvar('dsn')#" result="m">
			SELECT id, [module], memberType FROM pageObjects 
			WHERE pageid = <cfqueryparam value="#info.pageid#" cfsqltype="cf_sql_varchar">
            	AND name = <cfqueryparam value="#info.name#" cfsqltype="cf_sql_varchar">
                AND siteid = <cfqueryparam value="#arguments.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
                AND status = 'staged'
		</cfquery>
		
		<!--- 1/20/09 - Remove the cflocation below, if you need functionality for targeting content to specific member types --->
		<cflocation url="/#info.items.module#/editClientModule/?id=#info.items.id#&parameterlist=#urlencodedformat(info.parameterlist)#" addtoken="no">	
		
		<cfset sitemembertypes = dispatcher.callExternalModuleMethod('siteMembers','getAvailableMemberTypes', requestObject, userobj)>
		
		<!--- if only one membertype, then go directly to module editor --->
		<cfif sitemembertypes.recordcount EQ 0>
			<cflocation url="/#info.items.module#/editClientModule/?id=#info.items.id#&parameterlist=#urlencodedformat(info.parameterlist)#" addtoken="no">
		</cfif>
		
		<cfset displayObject.setData('memberTypes', sitemembertypes )>
   
		<cfset displayObject.setData('info', info )>

		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="SaveModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var itm = "">
		<cfset var id = createuuid()>
		<cfset var lcl = structnew()>

		<cfquery name="itm" datasource="#arguments.requestObject.getvar('dsn')#">
			INSERT INTO pageObjects (
				id,
				pageid,
				siteid,
				[module],
				name,
				data,
				status,
                memberType
			) VALUES (
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.requestObject.getformurlvar('pageid')#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.requestObject.getformurlvar('mdl')#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.requestObject.getformurlvar('objname')#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#createObject('component','utilities.json').encode(lcl)#" cfsqltype="cf_sql_varchar">,
                'staged',
				<cfqueryparam value="#arguments.requestObject.getformurlvar('memberType')#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	
		<cfset lcl.relocate = "/#arguments.requestObject.getformurlvar('mdl')#/editClientModule/?id=#id#&parameterlist=#urlencodedformat(arguments.requestObject.getFormUrlVar('parameterlist'))#">
		<cfset displayObject.sendJson( lcl )>
	</cffunction>
    
</cfcomponent>