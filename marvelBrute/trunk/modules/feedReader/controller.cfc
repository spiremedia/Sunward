<cfcomponent name="events controller" output="false" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="data">
		<cfargument name="requestObject">
		<cfargument name="pageRef">
		
		<cfset var feedObj = getModel(requestObject)>
		<cfset variables.data = arguments.data>
        
		<cfparam name="variables.data.feedurl" default="">
        <cfparam name="variables.data.descriptionoptions" default="Show Title,Show Description">
        <cfparam name="variables.data.rowcount" default="all">
        <cfparam name="variables.data.rowmaxlen" default="all">

		<!--- check cache if new enough? --->
		
		<!--- otherwise load feed and save back to site --->
		
		<cfset feedObj.setUrl(data.feedUrl)>
		<cfset variables.feed = feedObj.getFeed()>

		<!--- cache? --->
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getModel">
		<cfargument name="requestObject" required="true">
		<cfreturn createObject('component', 'modules.feedreader.feeds').init(requestObject = arguments.requestObject)>
	</cffunction>
	
	<cffunction name="showHTML" output="false">
		<cfset var h = "">
        <cfset var lcl = structnew()>
       
        <cfset lcl.maxstringlen = IIF(variables.data.rowmaxlen EQ "all", DE(10000), variables.data.rowmaxlen)>
        
		<cfsavecontent variable="h">
        	<div class="feedreader">
			<cfif isquery(variables.feed.query)>
				<cfif  listfind(variables.data.descriptionoptions, "Show Title")>
				
				<cfoutput>
                    <h2><a href="#variables.feed.properties.link#" target="_blank">#variables.feed.properties.title#</a></h2>
                    <cfif  variables.data.descriptionoptions EQ "Show Description">
                        <p>#rereplace(variables.feed.properties.description,"<[^>]+>","","all")#</p>
                    </cfif>
				</cfoutput>
                
			</cfif>
			<cfoutput query="variables.feed.query" maxrows="#IIF(variables.data.rowcount EQ "all", DE(10000), variables.data.rowcount)#">
            	<cfset lcl.descriptionstring = rereplace(variables.feed.query.content,"<[^>]+>","","all")>
                <p>
                    <a target="_blank" href="#rsslink#">#variables.feed.query.title#</a>
                   	<cfif listfind(variables.data.descriptionoptions, "Show Description") AND variables.data.rowmaxlen NEQ "none">
                    	<br>
                        <cfif len(lcl.descriptionstring) GT lcl.maxstringlen + 3>
                            #left(
                                rereplace(
                                	lcl.descriptionstring,
                                    "<[^>]>", "","all"), 
                                	IIF(variables.data.rowmaxlen EQ "all", DE(10000), variables.data.rowmaxlen
                                )
                            )#...
                        <cfelse>
                        	#lcl.descriptionstring#
                        </cfif>
                    </cfif>
                </p>
            </cfoutput>
			<cfelse>
				<p>Feed not available.</p>
			</cfif>
            </div>
		</cfsavecontent>
		<cfreturn h>
	</cffunction>
			
</cfcomponent>