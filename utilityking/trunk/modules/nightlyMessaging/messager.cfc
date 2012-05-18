<cfcomponent name="messager">
	
    <cffunction name="init">
    	<cfargument name="requestObject">
        <cfset variables.requestObject = arguments.requestObject>
    	<cfset variables.msgs = arraynew(1)>
        <cfreturn this>
	</cffunction>
    
    <cffunction name="createMessage">
    	<cfset var msg = createObject('component','modules.nightlyMessaging.message').init()>
    	<cfset arrayappend(variables.msgs, msg)>
        <cfreturn msg>
    </cffunction>
    
    <cffunction name="processMessages">
    	<cfset var msgcntr = "">
        <cfset var emailObj = "">
        
        <cfloop from="1" to="#arraylen(variables.msgs)#" index="msgcntr">
        	<cfset emailObj = createObject('component', 'resources.email').init(requestObject)>
            <cfset msgObj = variables.msgs[msgcntr]>
            
 			<cfset emailObj.setRecipient(msgObj.getRecipient())>
            <cfset emailObj.setSubject(msgObj.getSubject())>
            <cfset emailObj.setBody(msgObj.getBody())>
            <cfset emailObj.sendMessage()>
        </cfloop>
    </cffunction>
    
</cfcomponent>