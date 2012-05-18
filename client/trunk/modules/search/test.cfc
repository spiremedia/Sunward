<cfcomponent displayname="MyCFCTest" extends="mxunit.framework.TestCase">
		
	<cffunction name="setUp" returntype="void" access="public">		
		<cfset var lcl = structNew()>
				
		<cfset variables.unittestname = "Unit Test Page">
		<cfset this.unittestsearchterm = "Unit Test Page">
		<cfset variables.criteria = "Unit Test">
		<cfset variables.pageid = createuuid()>
		<cfset variables.requestObject = request.requestObject>
    	<cfset loadController()>
		
		<!--- setup assets for indexing --->
    	<cfset variables.assetsObj = createObject("component","modules.assets.test").init()>
    	<cfset variables.assetsObj.setUp()>
		<!--- setup events for indexing --->
    	<cfset variables.eventsObj = createObject("component","modules.events.test").init()>
    	<cfset variables.eventsObj.setUp()>
		<!--- setup news for indexing --->
    	<cfset variables.newsObj = createObject("component","modules.news.test").init()>
    	<cfset variables.newsObj.setUp()>
		
		<!--- setup page for indexing --->
		<cfquery name="lcl.qry" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT id FROM sitepages WHERE pageurl = 'Home'
		</cfquery>
		<cfset lcl.parentid = lcl.qry.id>
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			INSERT INTO sitepages (id,pagename,pageurl,title,status,sort,siteid,parentid,template,innavigation,subsite,searchindexable)
			VALUES (
				<cfqueryparam value="#variables.pageid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.unittestname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="UnitTesting" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.unittestname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="published" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="1" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="#variables.requestObject.getVar('siteid')#:published" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#lcl.parentid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="Internal" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="1" cfsqltype="cf_sql_bit">
			)
		</cfquery>
          
	</cffunction>
    
    <cffunction name="teardown" returntype="void" access="public">
		<cfset var lcl = structnew()>
		
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			DELETE FROM sitepages WHERE id = <cfqueryparam value="#variables.pageid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			DELETE FROM siteSearches WHERE criteria = <cfqueryparam value="#variables.criteria#" cfsqltype="cf_sql_varchar">
		</cfquery>
    	<cfset variables.assetsObj.teardown()>
    	<cfset variables.eventsObj.teardown()>
    	<cfset variables.newsObj.teardown()>
		
		<!---  reindex search - remove test results --->
		<cfsetting requesttimeout="50000">
		<cfset lcl.httpObj = createObject('component','utilities.http').init()>
		<cfset lcl.httpObj.setHost("http://#cgi.HTTP_HOST#")>
		<cfset lcl.httpObj.setPath("/system/refreshSearch/")>		
		<cfset lcl.httpObj.load()>
	</cffunction>
    
    <cffunction name="loadController" access="private">
    	<cfargument name="requestObject" default="#variables.requestObject#">
    	<cfargument name="parameterlist" default="#structnew()#">
    	<cfset variables.controller = createObject("component","modules.search.controller").init(
			requestObject=arguments.requestObject,
			parameterlist=arguments.parameterlist
		)>
    </cffunction>	
    
	<cffunction name="testSearchControllers">
        <cfset var parameterlist = structnew()>
		<cfset var furl = structnew()>
		<cfset var lcl = structnew()>
        <cfset var html = "">

    	<!--- test index controller --->
		<cfsetting requesttimeout="50000">
		<cfset lcl.httpObj = createObject('component','utilities.http').init()>
		<cfset lcl.httpObj.setHost("http://#cgi.HTTP_HOST#")>
		<cfset lcl.httpObj.setPath("/system/refreshSearch/")>		
		<cfset lcl.response = lcl.httpObj.load()>
		<cfset html = lcl.response.getHTML()>
		<!--- 
<cfdump var="#html#"><cfabort>
 --->

        <cfset assertEquals(expected=0,actual=refindnocase("Access Denied",html),message="Access denied for search indexing. Add Server IP to the securityIPs db table.")>
		<cfset asserttrue(condition = refindnocase("Pages indexed",html),message="did not index pages")>
		<cfset asserttrue(condition = refindnocase("Files indexed",html),message="did not index files")>
		<cfset asserttrue(condition = refindnocase(variables.assetsObj.unittestsearchterm,html),message="did not find #variables.assetsObj.unittestsearchterm# in search index")>
		<cfset asserttrue(condition = refindnocase(variables.eventsObj.unittestsearchterm,html),message="did not find #variables.eventsObj.unittestsearchterm# in search index")>
		<cfset asserttrue(condition = refindnocase(variables.newsObj.unittestsearchterm,html),message="did not find #variables.newsObj.unittestsearchterm# in search index")>
		<cfset asserttrue(condition = refindnocase(this.unittestsearchterm,html),message="did not find #this.unittestsearchterm# in search index")>
		
    	<!--- test search controller --->
		<cfset parameterlist.editable = 1> 
    	<cfset loadController(parameterlist = parameterlist)>
		<cfset html = variables.controller.showHTML()>
		<cfset asserttrue(condition = refind('search box',html),message="did not find text for esm content area search widget")>
		<cfset parameterlist.editable = 1> 
		<cfset furl.search = variables.criteria>
		<cfset furl.page = 1>
		<cfset lcl.decRequestObject = createobject('component', 'resources.altformurlRequestDecorator').init(requestObject)>
		<cfset lcl.decRequestObject.setRequestFields(furl)> 
    	<cfset loadController(requestObject=lcl.decRequestObject, parameterlist = parameterlist)>
		<cfset html = variables.controller.showHTML()>
        <cfset asserttrue(condition = refind('<div>.*</div>',html),message="did not find matching div elements")>
		<cfset asserttrue(condition = refindnocase(variables.criteria,html),message="did not find text for search results")>
		<cfset asserttrue(condition = refindnocase(variables.assetsObj.unittestsearchterm,html),message="did not find #variables.assetsObj.unittestsearchterm# in search results")>
		<cfset asserttrue(condition = refindnocase(variables.eventsObj.unittestsearchterm,html),message="did not find #variables.eventsObj.unittestsearchterm# in search results")>
		<cfset asserttrue(condition = refindnocase(variables.newsObj.unittestsearchterm,html),message="did not find #variables.newsObj.unittestsearchterm# in search results")>
		<cfset asserttrue(condition = refindnocase(this.unittestsearchterm,html),message="did not find #this.unittestsearchterm# in search results")>
    </cffunction> 
</cfcomponent>