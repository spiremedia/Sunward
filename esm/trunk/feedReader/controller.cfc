<cfcomponent name="News" extends="resources.abstractController">
	
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

		<cfset var widgetsmodel = createObject('component','feedreader.models.widgetModel').init(arguments.requestObject, arguments.userObj)>
		<cfset displayObject.setData('widgetsmodel', widgetsmodel)>
			
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="saveClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var model = createObject('component', 'feedreader.models.widgetmodel').init(requestObject, userobj)>
		<cfset var lcl = structnew()>
		<cfset var requestvars = requestobject.getallformurlvars()>

		<cfparam name="requestvars.warchives" default="0">
		
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
	
	<cffunction name="deleteClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = createObject('component', 'feedreader.models.widgetmodel').init(requestObject, userobj)>
				
		<cfset model.deleteItem(requestObject.getFormUrlVar('id'))>
		
		<cfset lcl.reloadBase = 1>
		<cfset displayObject.sendJson( lcl )>
	</cffunction>
    
    <cffunction name="testfeed">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cftry>
            <cffeed source = "#trim(requestObject.getFormUrlVar('feedurl'))#" 
                properties = "lcl.properties" 
                    query = "lcl.query">

            <cfcatch>
                <cfset displayObject.showHTML('Feed Invalid : #cfcatch.message#')>
            </cfcatch>
        </cftry>
        
        <cfset lcl.maxstringlen = IIF(requestObject.getFormUrlVar('rowmaxlen') EQ "all", DE(10000), requestObject.getFormUrlVar('rowmaxlen'))>
				
		<cfsavecontent variable="lcl.html">
        	<cfif requestObject.isformurlvarset('descriptionoptions') AND listfind(requestObject.getFormUrlVar('descriptionoptions'), "Show Title")>
				<p>
				<cfoutput>
                    <b><a href="#lcl.properties.link#" target="_blank">#lcl.properties.title#</a><br/>
                    <cfif requestObject.isFormUrlVarSet("descriptionoptions") AND requestObject.getFormUrlVar('descriptionoptions') EQ "Show Description">
                        #rereplace(lcl.properties.description,"<[^>]+>","","all")#
                    </cfif>
                    </b>
				</cfoutput>
                </p>
			</cfif>
			<cfoutput query="lcl.query" maxrows="#IIF(requestObject.getFormUrlVar('rowcount') EQ "all", DE(10000), requestObject.getFormUrlVar('rowcount'))#">
            	<cfset lcl.descriptionstring = rereplace(lcl.query.content,"<[^>]+>","","all")>
                <p>
                    <a target="_blank" href="#rsslink#">#lcl.query.title#</a>
                   	<cfif requestObject.isFormUrlVarSet("descriptionoptions") AND listfind(requestObject.getFormUrlVar('descriptionoptions'), "Show Description") AND requestObject.getFormUrlVar('rowmaxlen') NEQ "none">
                    	<br>
                        <cfif len(lcl.descriptionstring) GT lcl.maxstringlen + 3>
                            #left(
                                rereplace(lcl.descriptionstring, "<[^>]>", "","all"), 
                                IIF(requestObject.getFormUrlVar('rowmaxlen') EQ "all", DE(10000), requestObject.getFormUrlVar('rowmaxlen'))
                            )#...
                        <cfelse>
                        	#lcl.descriptionstring#
                        </cfif>
                    </cfif>
                </p>
            </cfoutput>
		</cfsavecontent>
        
        <cfset displayObject.showHTML(lcl.html)>
	</cffunction>
</cfcomponent>