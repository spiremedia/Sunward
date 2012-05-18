<cfcomponent name="nightlymessager" extends="resources.abstractController">
	
    <cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="pageRef">
        
        <cfset var modulename = "">        
    	<cfset var msgs = createObject('component', 'modules.nightlymessaging.messager').init(requestObject)>
	  
      	<cfset structappend(variables, arguments)>
      
        <cfloop list="#getMessageableModules()#" index="modulename">
        	<cfset createObject('component', 'modules.#modulename#.controller').init(requestObject).loadMessaging(msgs)>
        </cfloop>
        
        <cfset msgs.processMessages()>
    </cffunction>
    
    <cffunction name="getMessageableModules">
    	<cfset var modulexml = "">
		<cfset var sitepath = requestObject.getVar('machineroot')>
    	<cfset var modules = application.modules.getModules()>
        <cfset var moduleFolder = "">
        <cfset var modulelist = "">
        
        <cfloop list="#modules#" index="moduleFolder">
			<cfif fileexists(sitepath & '/modules/' & moduleFolder & '/configxml.cfm')>
				<cfinclude template="../#moduleFolder#/configxml.cfm">
				<cfif structkeyexists(modulexml.moduleInfo.xmlattributes,'nightlymessaging') AND modulexml.moduleInfo.xmlattributes.nightlymessaging>
					<cfset modulelist = listappend(modulelist, modulefolder)>
				</cfif>
			</cfif>
		</cfloop>
        <cfreturn modulelist>
    </cffunction>
</cfcomponent>