<cfcomponent name="sitemap" extends="resources.abstractmodel">
	
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfargument name="pageref" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.pageref = arguments.pageref>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getMainMenu">
		<cfset var mainmenu = ""/>
		<cfquery name="mainmenu" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT 
				c.id, 
				c.pagename, 
				c.displayurlpath 
			FROM publishedpages c
			INNER JOIN publishedpages t ON (t.parentid = '' AND t.id = c.parentid AND t.siteid = c.siteid)
			WHERE c.siteid = <cfqueryparam value="#variables.requestObject.getVar('siteid')#:published">
				AND c.innavigation = 1
				AND c.expired = 0
			ORDER BY c.sort
		</cfquery>
		<cfreturn mainmenu/>
	</cffunction>
	
	<cffunction name="getDHTMLnav">
		<cfargument name="id" required="no" default="">
		<cfset var dhtmlnav = ""/>
		
		<cfquery name="dhtmlnav" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT 
				b.id secondLevelid, 
				b.pagename secondPageName, 
				b.displayurlpath secondurlpath, 
				c.pagename thirdpagename, 
				c.displayurlpath thirdurlpath 
			FROM publishedpages t
			INNER JOIN publishedpages b ON (t.id = b.parentid AND b.siteid = t.siteid AND b.innavigation = 1)
			LEFT OUTER JOIN publishedpages c ON (b.id = c.parentid AND t.siteid = c.siteid AND c.innavigation = 1 AND c.expired = 0)
			WHERE t.siteid = <cfqueryparam value="#variables.requestObject.getVar('siteid')#:published">
				<cfif arguments.id EQ 'null' OR arguments.id EQ "">
					AND t.parentid = ''
				<cfelse>
					AND t.id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR">
				</cfif>
				AND b.expired = 0
           
			ORDER BY b.sort, c.sort
		</cfquery>
  
		<cfreturn dhtmlnav/>
	</cffunction>

	<cffunction name="getSiblingPages">	
		<cfset var siblingpages = ""/>

		<cfquery name="siblingpages" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT 
				pagename, 
				displayurlpath FROM publishedpages
			WHERE 
				 parentid = <cfqueryparam value="#variables.pageref.getField('parentid')#" cfsqltype="cf_sql_varchar">
				AND siteid = <cfqueryparam value="#variables.requestObject.getVar('siteid')#:published"  cfsqltype="cf_sql_varchar">
				AND (innavigation = 1 OR id = <cfqueryparam value="#variables.pageref.getPageId()#" cfsqltype="cf_sql_varchar">)
				AND expired = 0
			ORDER BY sort
		</cfquery>
		
		<cfreturn siblingpages/>
	</cffunction>
	
	<cffunction name="getChildPages">
		<cfargument name="id">
		<cfset var childpages = ""/>
		<cfquery name="childpages" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT 
				pagename, 
				displayurlpath 
			FROM publishedpages 
			WHERE 
				parentid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
				AND siteid = <cfqueryparam value="#variables.requestObject.getVar('siteid')#:published"  cfsqltype="cf_sql_varchar">
				AND innavigation = 1
				AND expired = 0
			ORDER BY sort
		</cfquery>
		<cfreturn childpages/>
	</cffunction>
	
	<cffunction name="getPageInfo">
		<cfargument name="id">
		<cfset var p = ""/>
		<cfquery name="p" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT 
				pagename, 
				displayurlpath,
				urlpath
			FROM publishedpages
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn p/>
	</cffunction>
	
	<cffunction name="getPageObjects">
		<cfargument name="pageid" required="true">
		<cfargument name="ispreview" required="true">
		<cfargument name="memberType" required="true">
		<cfset var smpageobjects = "">
		
        <cfquery name="smpageobjects" datasource="#requestObject.getvar('dsn')#" result="m">
			SELECT id, [module], data, name, memberType,
            CASE 
            	WHEN memberType = 'default' THEN 1
                ELSE 0
            END as sort
			FROM pageObjects_view
			WHERE pageid = <cfqueryparam value="#arguments.pageid#" cfsqltype="CF_SQL_VARCHAR">
				AND siteid = <cfqueryparam value="#variables.requestObject.getVar('siteid')#" cfsqltype="CF_SQL_VARCHAR">
				AND status = '<cfif ispreview>staged<cfelse>published</cfif>'
                AND (
                	memberType = <cfqueryparam value="#memberType#" cfsqltype="CF_SQL_VARCHAR">
                    OR memberType = 'default'
                    )
            ORDER BY sort
		</cfquery>

		
		<cfreturn smpageobjects>
	</cffunction>
    
 	<cffunction name="getTwoLevelsDeep">
		<cfargument name="pageid" required="true">
		
		<cfset var twolevelsdeep = "">
		<cfset var toplevelpage = listfirst(requestObject.getformurlvar('path'),"/")>
		
		<cfquery name="twolevelsdeep" datasource="#requestObject.getvar('dsn')#" result="m">
			SELECT  
				a.id aid,
				CASE
					WHEN b.id IS NULL THEN 
					  	a.id
					ELSE 
						b.id
				END as id, 
				a.pagename apagename, 
				a.displayurlpath aurlpath, 
				a.sort asort, 
				b.pagename bpagename, 
				b.displayurlpath burlpath, 
				b.sort bsort,
				CASE
					WHEN b.pagename IS NULL THEN 
					  	a.pagename
					ELSE 
						a.pagename + ' : ' + b.pagename
				END as concatname
			FROM publishedpages a
			INNER JOIN publishedpages p ON (a.parentid = p.id AND p.id = <cfqueryparam value="#arguments.pageid#"  cfsqltype="cf_sql_varchar">)
			LEFT OUTER JOIN publishedpages b ON (b.parentid = a.id 
												AND b.siteid = <cfqueryparam value="#variables.requestObject.getVar('siteid')#:published"  cfsqltype="cf_sql_varchar">
												AND b.innavigation = 1)
			WHERE 
				a.siteid = <cfqueryparam value="#variables.requestObject.getVar('siteid')#:published"  cfsqltype="cf_sql_varchar">
				AND a.innavigation = 1
				AND a.expired = 0
			ORDER BY a.sort, b.sort
		</cfquery>

		<cfreturn twolevelsdeep>
	</cffunction>
    
    <cffunction name="getSectionPages">
		<cfargument name="pageid" required="true">
		<cfset var childpages = ""/>

		<cfquery name="childpages" datasource="#variables.requestObject.getVar('dsn')#" result="m">
			SELECT 
				c.pagename, 
				c.displayurlpath 
            FROM publishedpages c
			INNER JOIN publishedpages p ON (p.id = <cfqueryparam value="#arguments.pageid#" cfsqltype="cf_sql_varchar"> AND p.id = c.parentid )
			WHERE
				c.siteid = <cfqueryparam value="#variables.requestObject.getVar('siteid')#:published"  cfsqltype="cf_sql_varchar">
				AND c.innavigation = 1
				AND c.expired = 0
			ORDER BY c.sort
		</cfquery>
		
       <cfreturn childpages/>
	</cffunction>
	
	<cffunction name="getSitePages">
		<cfset var sitepages = "">
		<cfquery name="sitepages" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT 
				displayurlpath, 
				modifieddate,
                searchindexable
			FROM publishedPages 
			WHERE siteid = <cfqueryparam value="#variables.requestObject.getVar('siteid')#:published">
				AND expired = 0
			ORDER BY len(urlpath)
		</cfquery>
		<cfreturn sitepages>
	</cffunction>

</cfcomponent>