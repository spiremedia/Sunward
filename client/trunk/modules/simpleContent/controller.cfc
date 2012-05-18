<cfcomponent name="simplecontent" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="data" required="true">
        <cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfif isstruct(data)>
			<cfset variables.data = arguments.data>
		<cfelse>
			<cfset variables.data = structnew()>
			<cfset variables.data.content = arguments.data>
		</cfif>
        
		<cfparam name="variables.data.content" default="">
        
		<cfreturn this>
	</cffunction>
	
	<cffunction name="showHTML">
        <cfreturn parseForLanguage( variables.data.content )>
	</cffunction>
	
	<cffunction name="showReversionHTML">
        <cfreturn parseforlanguage( showHTML() )>
	</cffunction>
    
    <cffunction name="parseForLanguage">
		<cfargument name="content" required="true">
    	<cfset var item = structnew()>
        <cfset var state = requestObject.getStateObject()>
        <cfset var linkre = '\{\{link\[([A-Z0-9\-]{35})\]\[([A-Z0-9\-]{35})\]\}\}'>
        <cfset var assetre = '\{\{asset\[([A-Z0-9\-]{35})\]\}\}'>
    	<cfset var reobj = "">
        <cfset var timestamp = now() + 0>
        
        <!--- replace all the links --->
        <cfset reobj = refind(linkre, arguments.content, 0, true)>

       	<cfloop condition="reobj.len[1] NEQ 0">
        	<cfset item.siteid = mid(arguments.content, reobj.pos[2], reobj.len[2])>
        	<cfset item.pageid = mid(arguments.content, reobj.pos[3], reobj.len[3])>
	
			<!--- <cfset item.path = state.pathTranslator(item.siteid, item.pageid)> --->
			<cfset item.path = state.linkPathTranslator(item.siteid, item.pageid, requestObject)>
			
            <cfset arguments.content = left(arguments.content, reobj.pos[1] -1)
					& item.path 
                    & right(arguments.content, len(arguments.content) - reobj.pos[1] - reobj.len[1] +1)>
			<cfset reobj = refind(linkre, arguments.content,0, true)>
        </cfloop>
     
        <!--- replace all the assets --->
        <cfset reobj = refind(assetre, arguments.content, 0, true)>

       	<cfloop condition="reobj.len[1] NEQ 0">
        	<cfset item.assetid = mid(arguments.content, reobj.pos[2], reobj.len[2])>
	
			<cfset item.path = state.assetPathTranslator(item.assetid, requestObject)>
			
            <cfset arguments.content = left(arguments.content, reobj.pos[1] -1)
					& item.path 
                    & right(arguments.content, len(arguments.content) - reobj.pos[1] - reobj.len[1] +1)>
			<cfset reobj = refind(assetre, arguments.content,0, true)>
        </cfloop>

		<cfreturn arguments.content>
	</cffunction>

</cfcomponent>