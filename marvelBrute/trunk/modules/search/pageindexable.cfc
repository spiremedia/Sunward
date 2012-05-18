<cfcomponent displayname="pageindexable" extends="modules.search.indexable">
	
    <cffunction name="getlinktype">
		<cfreturn "internal">
	</cffunction>
    
    <cffunction name="getPageHtml" output="false">
		<cfargument name="siteurl">
		<cfhttp method="get" url="#siteurl & getPath()#" result="pageinfo" redirect="false">

        <cfif left(pageinfo.Statuscode,3) EQ "200" or left(pageinfo.Statuscode,3) EQ "302">
			<cfreturn processHTML(pageinfo.filecontent)>
        <cfelse>
        	<cfthrow message="getting page html status info #pageinfo.statuscode# for path = #getpath()#">
        </cfif>
	</cffunction>
	
	<cffunction name="processHTML" output="false">
		<cfargument name="html">
        <!--- clear out all tags --->
        <cfset html = rereplace(html, "<select[^>]*?>.*?</select>"," ","all")><!--- remove javascript code --->
		<cfset html = rereplace(html, "<head[^>]*?>.*?</head>"," ","all")><!--- remove stuff between head tags code --->
		<cfset html = rereplace(html, "<script[^>]*?>.*?</script>"," ","all")><!--- remove <select>...</select> --->
		<cfset html = rereplace(html, "<[^>]+>"," ","all")>
		<cfreturn html>
	</cffunction>
    
    <cffunction name="validate">
    
    </cffunction>
    
    <cffunction name="saveforindex">
    	<cfset validate()>
    	<cfset variables.pageRef.savePageIndexable(this)>
    </cffunction>
    
</cfcomponent>