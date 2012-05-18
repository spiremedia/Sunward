<cfcomponent name="msgloader" extends="resources.page">
	<cffunction name="preObjectLoad">
		
		<cfset var msgControl = createObject('component', 'modules.nightlyMessaging.controller').init(requestObject, this)>
       	<cfabort>
        
	</cffunction>
</cfcomponent>