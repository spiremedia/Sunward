<cfcomponent name="rssnewslistcontroller" output="false">
	
	<cffunction name="init" output="false">
		<cfargument name="data" required="true">
		<cfargument name="model" required="true">
		<cfargument name="requestObject" required="true">
			
		<cfset variables.data = arguments.data>
		<cfset variables.rssfeedlist = arguments.model.getRssFeeds()>
		<cfset variables.requestObject = arguments.requestObject>
		
		<cfreturn this>
	</cffunction>
		
	<cffunction name="showHTML" output="false">
		<cfset var html = "">
	
		<cfsavecontent variable="html">
			<div class="feedListing">
				<cfoutput>
                    <link rel="stylesheet" type="text/css" href="/ui/css/news.css">
                       	<p>Available Feeds</p>
                        <cfif variables.rssfeedlist.recordcount>
                            <ul>
                            <cfloop query="variables.rssfeedlist">
                                <li>
                                    <p>#title# <a href="#requestObject.getVar("siteurl")#rss/#id#/"><img src="/ui/images/rss.jpg"/></a></p>
                                    
                                    #description#
                                </li>
                            </cfloop>
                            <ul>
                        <cfelse>
                            <p>There are currently no rss feeds available.</p>
                        </cfif>
                </cfoutput>
			</div>
		</cfsavecontent>
		<cfreturn html>
	</cffunction>
	
	<cffunction name="dump">
		<cfdump var=#variables.data#>
		<cfabort>
	</cffunction>
</cfcomponent>