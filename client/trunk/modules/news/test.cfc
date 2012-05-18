<cfcomponent displayname="MyCFCTest" extends="mxunit.framework.TestCase">
		
	<cffunction name="setUp" returntype="void" access="public">
		<cfset var lcl = structNew()>
		
		<cfset variables.unittestname = "Unit Test News">
		<cfset this.unittestsearchterm = "Unit Test News">
		<cfset variables.newstypesid = createuuid()>
		<cfset variables.newsid = createuuid()>
		<cfset variables.newsToNewstypeid = createuuid()>
		<cfset variables.requestObject = request.requestObject>
    	<cfset loadController()>
		
		<cfquery name="lcl.qry" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT id FROM users
			WHERE username = 'sa@spiremedia.com'
		</cfquery>
		
		<cfset lcl.userid = lcl.qry.id>
		
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			INSERT INTO newsTypes ( id,name)
			VALUES (
				<cfqueryparam value="#variables.newstypesid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="Unit Test News" cfsqltype="cf_sql_varchar">
			)			
		</cfquery>
		
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			INSERT INTO news ( id,name,title,description,changedby,siteid,itemdate,startdate,enddate,onhomepage)
			VALUES (
				<cfqueryparam value="#variables.newsid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.unittestname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.unittestname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.unittestname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#lcl.userid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.requestObject.getVar('siteid')#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#CreateODBCdate(Now())#" cfsqltype="cf_sql_date">,
				<cfqueryparam value="#CreateODBCdate(Now())#" cfsqltype="cf_sql_date">,
				<cfqueryparam value="#CreateODBCdate(DateAdd('m', 1, Now()))#" cfsqltype="cf_sql_date">,
				<cfqueryparam value="1" cfsqltype="cf_sql_integer">
			)			
		</cfquery>
		
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			INSERT INTO newsToNewstype ( id,typeid,newsid,siteid)
			VALUES (
				<cfqueryparam value="#variables.newsToNewstypeid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.newstypesid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.newsid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.requestObject.getVar('siteid')#" cfsqltype="cf_sql_varchar">
			)			
		</cfquery>
          
	</cffunction>
    
    <cffunction name="teardown" returntype="void" access="public">
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			DELETE FROM newsToNewstype WHERE id = <cfqueryparam value="#variables.newsToNewstypeid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			DELETE FROM news WHERE id = <cfqueryparam value="#variables.newsid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			DELETE FROM newsTypes WHERE id = <cfqueryparam value="#variables.newstypesid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
    
    <cffunction name="loadController" access="private">
    	<cfargument name="data" default="#structnew()#">
    	<cfargument name="requestObject" default="#variables.requestObject#">
    	<cfargument name="pageref" default="#structnew()#">
    	<cfset variables.controller = createObject("component","modules.news.controller").init(
			data=arguments.data,
			requestObject=arguments.requestObject,
			pageref=arguments.pageref
		)>
    </cffunction>
	
    <!--- model tests --->
    <cffunction name="testGettingNews">
		<cfset var lcl = structNew()>
    	<cfset var itm = variables.controller.getModel(requestObject=variables.requestObject)>
        <cfset var count = "">
		
		<cfset count = itm.getAvailableNewsItems( newstype = variables.newstypesid ).recordcount>
        <cfset assertequals(expected=1,actual=count,message="did not find available news type item")>
		
		<cfset count = itm.getNews(id = variables.newsid).recordcount>
        <cfset assertequals(expected=1,actual=count,message="did not find news item")>
		
		<cfset count = itm.getAllAvailableNewsItems().recordcount>
        <cfset assertNotEquals(expected=0,actual=count,message="did not find any news available")>		
    </cffunction>
    
    <!--- ctrlr tests --->
    <cffunction name="testShowHTML">
        <cfset var data = structnew()>
		<cfset var furl = structnew()>
    	<cfset var itm = variables.controller.getModel(requestObject=variables.requestObject)>
        <cfset var html = "">
		
		<!--- news listing --->
		<cfset data.view = "list">  
		<cfset data.newstype = variables.newstypesid>
		<cfset data.pageing = 10>
    	<cfset loadController(data = data)>
		<cfset html = variables.controller.showHTML()>
        <cfset asserttrue(condition = refind('<div id="newsItem">.*</div>',html),message="did not find matching div elements")>
        <cfset asserttrue(condition = refind('<div class="newsCrumbs">.*</div>',html),message="did not find news crumbs")>
        <cfset asserttrue(condition = refind('<li>.*</li>',html),message="did not find matching li elements")>
        <cfset asserttrue(condition = refind('<a .*#variables.unittestname#.*</a>',html),message="did not find #variables.unittestname# link")>
		
		<!--- news item --->
		<cfset data.view = "item"> 
		<cfset data.newsInfo = itm.getNews(id = variables.newsid)>		
    	<cfset loadController(data = data)>
		<cfset html = variables.controller.showHTML()>
        <cfset asserttrue(condition = refind('<div class="newsDetail">.*</div>',html),message="did not find matching div elements")>
        <cfset asserttrue(condition = refind(variables.unittestname,html),message="did not find #variables.unittestname# html")>
    </cffunction>
	
    
    <cffunction name="testGetPagesforSiteSearch">
        <cfset var data = structnew()>
        <cfset var html = "">
        <cfset var aggregator = createobject('component','modules.search.searchableaggregator').init(requestObject=variables.requestObject)>
		
		<cftry>
        	<cfset variables.controller.getPagesforSiteSearch( aggregator = aggregator)>
            <cfcatch>
            	<cfset fail("news search indexing fails : #cfcatch.message#")>
            </cfcatch>
        </cftry>
    </cffunction>
   
</cfcomponent>