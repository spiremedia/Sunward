<cfcomponent name="page" output="false" extends="resources.abstractmodel">

	<cffunction name="init" output="False">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="pages" required="true">
		<cfargument name="id" required="true">
		
		<cfset var smo = "">
		<cfset var itm = "">
		<cfset var info = "">

		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		<cfset variables.pages = arguments.pages>
		<cfset variables.itemdata = structnew()>
		<cfset variables.itemdata.id = arguments.id>
		
		<cfset variables.smo = pages.getSiteMapObj('staged')>
		<cfset info  = variables.smo.getItem(arguments.id)>
	
		<cfloop list="#info.columnlist#" index="itm">
			<cfset variables.itemdata[itm] = info[itm][1]>
		</cfloop>
        
        <cfif arguments.id EQ 0>
        	<cfset variables.itemdata.searchindexable = 1>
			<cfset varaibles.itemdata.innavigation = 1>
        </cfif>
        
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getPagesObj">
		<cfreturn variables.pages>
	</cffunction>
	
	<cffunction name="setvalues">
		<cfargument name="itemdata">
		<cfparam name="arguments.itemdata.parentid" default="">
		<cfset variables.itemdata = arguments.itemdata>	
	</cffunction>

	<cffunction name="getPagebyId" output="false">
		<cfargument name="id" required="true">
		<cfargument name="pagestatus" required="false" default="staged">
		<cfset var g = "">
		
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			SELECT urlpath, parentid
			FROM sitepages_view
			WHERE id =  <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			AND siteid = <cfqueryparam value="#userObj.getCurrentSiteId()#:#arguments.pagestatus#" cfsqltype="cf_sql_varchar">
		</cfquery>
				
		<cfreturn g>	
	</cffunction>
	
	<cffunction name="validate">
		<cfset var lcl = structnew()>
		<cfset var requestvars = variables.itemData>
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var mylocal = structnew()>
		<cfset var newparentpath = "">
		
		<cfset vdtr.lengthbetween('pagename', 1,100, requestvars.pagename, 'The Page Name is required and should be less than 100 chars.')>
		<cfset vdtr.regexmatchtest('pagename', '[\||~]+', requestvars.pagename, 'The Page Name cannot contain the special characters of pipes or tildes.')> 

		<cfset vdtr.lengthbetween('pageurl', 1,50, requestvars.pageurl, 'The Page URL is required and should be less than 50 chars.')>
		<cfset vdtr.regexmatchtest('pageurl', '[^a-zA-Z0-9\-\_]+', requestvars.pageurl, 'The Page URL should only contain letters, digits, or hyphens. No spaces please.')>

		<!-- check length -->
		<cfset vdtr.lengthbetween('Title',  1,700,requestvars.title, 'The Browser Title is required and should be less than 700 chars.')> 
		<cfset vdtr.maxlength('description', 700, requestvars.description, 'The Meta Data Description should be less than 700 chars ')> 
		<cfset vdtr.maxlength('keywords', 700, requestvars.keywords, 'The Meta Data Keywords should be less than 700 chars ')> 
		<cfset vdtr.maxlength('summary', 700, requestvars.summary, 'The Meta Data Search Results Description should be less than 700 chars ')> 
	
		<cfif requestvars.parentid NEQ "" AND requestvars.id EQ requestvars.parentid>
			<cfset vdtr.addError('parentid', 'The Parent Page may not be itself. Please choose a different parent parent path')>
		</cfif>		
		
		<cfif requestvars.parentid EQ "">
			<cfquery name="lcl.countme" datasource="#variables.request.getvar('dsn')#">
				SELECT COUNT(*) cnt 
				FROM sitepages 
				WHERE (parentid = '' OR parentid is null)
               		AND siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#:staged" cfsqltype="cf_sql_varchar">
				<cfif requestvars.id NEQ "">
					AND id <> <cfqueryparam value="#requestvars.id#" cfsqltype="cf_sql_varchar">
				</cfif>
			</cfquery>
			<cfif lcl.countme.cnt>
				<cfset vdtr.addError('parentid', 'There may only be one root page. Please choose a parent path.')>
			</cfif>
		</cfif>		
		
		<!--- validate page redirect field --->
		<cfif trim(requestvars.relocate) neq ''>
			<cfset vdtr.regexnomatchtest('relocate', '^(https?:\/\/|/)', requestvars.relocate, 'The Relocate should be an absolute path with domain (ie. http://fpanet.org/) <br>or without starting with a slash (ie. /item/page/).')> 
		</cfif>
		
		<!--- check if user has permission for selected parent page --->		
		<cfif requestvars.parentidold neq requestvars.parentid>
			<cfif not (userobj.isSuper() OR userobj.isPathAllowed(""))>
				<cfset qryParentNew = getPagebyId(requestvars.parentid)>
				<cfset newparentpath = iif(qryParentNew.recordcount, "qryParentNew.urlpath", DE(""))>
				<!--- <cfif not variables.userobj.isPathAllowed(newparentpath) > --->
				<cfif not variables.userobj.isDescendentPathAllowed(newparentpath)>
					<cfset vdtr.addError('parent', 'The page selected under Parent is not permitted to be a parent of this page. Please select a different Parent page.')>
				</cfif>
			</cfif>
		</cfif>
		
		<!-- check page name is not duplicated at this level -->
		<cfset mylocal.parentskids = pages.getSiteMapObj('staged').getChildren(requestvars.parentid,1)>		
		<cfloop query="mylocal.parentskids">
			<cfif mylocal.parentskids.pageurl EQ requestvars.pageurl AND mylocal.parentskids.id NEQ requestvars.id>
				<cfset vdtr.addError('pagename','This Page URL is already in use. Please choose another.')>
				<cfbreak>
			</cfif>
		</cfloop>
		
		<!--- check show and hide date --->
		<cfif requestvars.showdate NEQ "">
			<cfset vdtr.isvaliddate('showdate', requestvars.showdate, 'The Show Date must be a valid date.')>
		</cfif>	
		
		<cfif requestvars.hidedate NEQ "">
			<cfset vdtr.isvaliddate('hidedate', requestvars.hidedate, 'The Hide Date must be a valid date.')>
		</cfif>	
		
		<cfif requestvars.showdate NEQ "" AND NOT vdtr.fieldhaserror('showdate')
				AND requestvars.hidedate NEQ "" AND NOT vdtr.fieldhaserror('hidedate')
				AND createodbcdate(requestvars.showdate) GTE createodbcdate(requestvars.hidedate)>
			
			<cfset vdtr.addError('showdate', 'The Show Date must earlier than the Hide Date.')>
		</cfif>	
		
		<!-- if parentid is blank, make sure this is the only home page ?--->
		
		<!-- check meta data there ?-->
		
		<!-- check this does not cause a recursive situation -->

		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var id = "">
		<cfset var smo = "">
		
		<cfset variables.itemdata.modifiedby = variables.userobj.getUserID()>
		<cfset variables.itemdata.modifieddate = now()>
        
		<cfif variables.itemData.id EQ ''>
			<cfset smo = pages.getSiteMapObj('staged')>
			<cfset smo.setInfo(variables.itemData)>
			<cfset id = smo.add()>
			<cfset variables.itemdata.id = id>
			<cfset variables.observeEvent('insert page', variables.itemData)>
			<cfreturn id>
		<cfelse>
		
			<cfset smo = pages.getSiteMapObj('staged')>
			<cfset smo.setInfo(variables.itemData)>

			<!--- get current parentid --->
			<cfquery name="qryStagedPageParent" datasource="#variables.request.getvar('dsn')#">
				SELECT parentid FROM sitepages
				WHERE id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
				AND siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#:staged" cfsqltype="cf_sql_varchar">		
			</cfquery>
            
			<!--- check if parentid has changed --->
			<cfif qryStagedPageParent.recordcount AND (qryStagedPageParent.parentid neq variables.itemdata.parentid)>
				<!--- call event listener to update sidenav for current parent --->
				<cfset variables.observeEvent('move page', variables.itemData)>
				<!--- change parent/sort --->
				<cfset smo.moveToFolder(idtomove = variables.itemdata.id, targetparentid = variables.itemdata.parentid)>
				<!--- call event listener to update sidenav for new parent --->
				<cfset variables.observeEvent('move page', variables.itemData)>
			</cfif>
            
			<cfset smo.edit()>
			
			<cfset variables.observeEvent('update page', variables.itemData)>
            
			<cfreturn variables.itemData.id>
		</cfif>
	</cffunction>
	
	<cffunction name="moveupdown">
		<cfargument name="dir">
		<cfset var publishedsmo = pages.getSiteMapObj('published')>
		
		<cfset variables.observeEvent('page up down', variables.itemData)>
		
		<cfset smo.moveupdown(variables.itemdata.id, arguments.dir)>
		<cfset publishedsmo.moveupdown(variables.itemdata.id, arguments.dir)>
		<cfset variables.observeEvent('moved', variables.itemData)>
	</cffunction>
	
	<cffunction name="validateDelete" output="false">
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var child = variables.smo.getChildren(variables.itemdata.id)>
		<cfset var links = "">
		<cfset var errorstring = "">
		
		<cfif child.recordcount>
			<cfset vdtr.addError('delete','This item has children. Please delete them first.')>
		</cfif>
		
		<cfquery name="links" datasource="#variables.request.getvar('dsn')#" result="m">
			SELECT DISTINCT sp.urlpath, sp.pagename, s.name sitename, s.id siteid
			FROM  pageObjects_view pov
			INNER JOIN sitepages sp ON pov.pageid = sp.id
			INNER JOIN sites s ON s.id = SUBSTRING(sp.siteid, 0, 36)
			WHERE 
				pov.data LIKE <cfqueryparam value="%{{link\[#userobj.getCurrentSiteId()#]\[#variables.itemdata.id#]}}%" cfsqltype="cf_sql_varchar"> escape '\'
				AND pov.module = 'htmlcontent' 
				AND pov.pageid <> <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
			ORDER BY sp.urlpath, sp.pagename, s.name
		</cfquery>
        
		<cfif links.recordcount>
			<cfif links.recordcount GT 1>
                <cfset errorstring = "This page is linked from the following pages:<br>">
                <cfoutput query="links">
                <cfif links.siteid NEQ userObj.getCurrentSiteId()>
                    <cfset errorstring = errorstring & "&nbsp;&nbsp;-On site #sitename# on pagewith path ""/#iif(links.urlpath EQ "", DE('Home'),links.urlpath)#""<br>">
                <cfelse>
                    <cfset errorstring = errorstring & "&nbsp;&nbsp;-On page with path ""/#iif(links.urlpath EQ "", DE('Home'),links.urlpath)#.""<br>">
                </cfif>
                </cfoutput>
            <cfelseif links.recordcount EQ 1>
                <cfif links.siteid NEQ userObj.getCurrentSiteId()>
                    <cfset errorstring = "This page is linked from site #links.sitename# on pagewith path ""/#iif(links.urlpath EQ "", DE('Home'),links.urlpath)#""<br>">
                <cfelse>
                    <cfset errorstring = "This page is linked from page with path ""/#iif(links.urlpath EQ "", DE('Home'),'links.urlpath')#.""<br>">
                </cfif>
            </cfif>
			<cfset errorstring = errorstring & "Please delete these references before deleting this page.">
			<cfset vdtr.addError('delete', errorstring)>
        </cfif>
        
		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="DeletePage" output="false">
		<cfset variables.observeEvent('delete page', variables.itemData)>
		<cfset variables.smo.delete(variables.itemdata.id)>
		<cfset deleteObjects()>
	</cffunction>
	
	<cffunction name="validatePublish">
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		
		<!-- if not home page, check parent published -->
		
		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="determineCacheReload">
		<cfset var localq = structnew()>
		<!--- if only one record exists, then its never been published and should be reloaded --->
		<cfquery name="localq.nonpublishedtest" datasource="#variables.request.getvar('dsn')#" result="m">
			SELECT COUNT(*) cnt
            FROM sitepages s
            WHERE s.id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
			AND s.siteid LIKE <cfqueryparam value="#userobj.getCurrentSiteId()#%" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif localq.nonpublishedtest.cnt EQ 1>
			<cfreturn 1>
		</cfif>
		
		<!--- Basically determines if staged version has different values in key fields from published --->
        <cfquery name="qs.publishstatus" datasource="#variables.request.getvar('dsn')#" result="m">
			SELECT COUNT(*) cnt
            FROM sitepages s
            INNER JOIN sitepages p ON (s.id = p.id AND p.siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#:published" cfsqltype="cf_sql_varchar">)
			WHERE s.id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
				AND s.siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#:staged" cfsqltype="cf_sql_varchar">
                AND (s.urlpath <> p.urlpath
                	OR s.pageurl <> p.pageurl
                    OR s.pagename <> p.pagename
               		 OR s.showdate <> p.showdate OR s.showDate IS NULL AND p.showDate IS NOT NUll OR p.showDate IS NULL AND s.showDate IS NOT NUll
                	 OR s.hidedate <> p.hidedate  OR s.hideDate IS NULL AND p.hideDate IS NOT NUll OR p.hideDate IS NULL AND s.hideDate IS NOT NUll
                     OR s.innavigation <> p.innavigation)
		</cfquery>

		<cfreturn qs.publishstatus.cnt>
	</cffunction>
	
	<cffunction name="determineurlChange">
		<cfset var localq = structnew()>

		<!--- Basically determines if staged version has different values urlpath from published --->
        <cfquery name="qs.preclear" datasource="#variables.request.getvar('dsn')#" result="m">
			SELECT COUNT(*) cnt
            FROM sitepages s
            INNER JOIN sitepages p ON (s.id = p.id AND p.siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#:published" cfsqltype="cf_sql_varchar">)
			WHERE s.id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
				AND s.siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#:staged" cfsqltype="cf_sql_varchar">
                AND s.urlpath <> p.urlpath
		</cfquery>

		<cfreturn qs.preclear.cnt>
	</cffunction>
	
	<cffunction name="publish">
		<cfset var datas = arraynew(1)>
		<cfset var data = structnew()>
		<cfset var qs = structnew()>
        
		<cfif determineCacheReload()>
    		<cfset variables.itemdata.reloadsurrounding = 1>
			<cfif determineurlChange()>
				<cfset variables.observeEvent('pre publish page', variables.itemData)>
			</cfif>
		<cfelse>
			<cfset variables.itemdata.reloadsurrounding = 0>
		</cfif>
        		
		<cfquery name="stagedpage" datasource="#variables.request.getvar('dsn')#">
			SELECT * FROM sitepages 
			WHERE id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
			AND siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#:staged" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif stagedpage.recordcount GT 1>
			<cfthrow message="More than one staged record was found while publishing. Expected 1.">
		</cfif>
		
		<cfquery name="ispublished" datasource="#variables.request.getvar('dsn')#">
			SELECT count(*) cntme FROM sitepages
			WHERE id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
			AND siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#:published" cfsqltype="cf_sql_varchar">	
		</cfquery>
		
		<cfif ispublished.cntme GT 1>
			<cfthrow message="More than one record found for published pages with id = '#variables.itemdata.id#'">
		</cfif>
		
		<cfloop list="#stagedpage.columnlist#" index="fld">
			<cfif NOT listfindnocase('siteid,modifieddate,modifiedby',fld)>
				<cfset data = structnew()>
				<cfset data.field = fld>
				<cfset data.value = stagedpage[fld][1]>
				<cfset arrayappend(datas, data)>
			</cfif>
		</cfloop>
		
		<!---	
		<cfset data.field = 'siteid'>
		<cfset data.value = userObj.getCurrentSiteId() & ':published'>
		<cfset arrayappend(datas, data)>
		--->
		<cfset data = structnew()>
		<cfset data.field = 'modifiedby'>
		<cfset data.value = userObj.getUserId()>
		<cfset arrayappend(datas, data)>
		
		<cfset data = structnew()>
		<cfset data.field = 'modifieddate'>
		<cfset data.value = now()>
		<cfset arrayappend(datas, data)>
		
		<cfoutput>
		<cfif ispublished.cntme>
			<cfquery name="update" datasource="#variables.request.getvar('dsn')#">
				UPDATE sitepages SET 
					<cfloop from="1" to="#arraylen(datas)#" index="fld">
						<cfif fld NEQ 1>
							,
						</cfif>
						#datas[fld].field# = <cfqueryparam value="#datas[fld].value#" null="#datas[fld].value EQ "" AND right(datas[fld].field,4) EQ 'date'#" cfsqltype="#iif(isdate(datas[fld].value), de('cf_sql_timestamp'), de('cf_sql_varchar'))#">
					</cfloop>
				WHERE id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
				AND siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#:published" cfsqltype="cf_sql_varchar">	
			</cfquery>
		<cfelse>
			<cfquery name="insert" datasource="#variables.request.getvar('dsn')#">
				INSERT INTO sitepages (
					<cfloop from="1" to="#arraylen(datas)#" index="fld">
						#datas[fld].field#,
					</cfloop>
					siteid
				) VALUES (
					<cfloop from="1" to="#arraylen(datas)#" index="fld">
						<cfqueryparam value="#datas[fld].value#" null="#datas[fld].value EQ ''#" cfsqltype="#iif(isdate(datas[fld].value), de('cf_sql_timestamp'), de('cf_sql_varchar'))#">,
					</cfloop>
					<cfqueryparam value="#userobj.getCurrentSiteId()#:published" cfsqltype="cf_sql_varchar">
				) 
			</cfquery>		
		</cfif>
		</cfoutput>
		
		<cfquery name="updatelast" datasource="#variables.request.getvar('dsn')#">
			UPDATE sitepages 
			SET status = 'published'
			WHERE id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
			AND siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#:staged" cfsqltype="cf_sql_varchar">
		</cfquery>	
		
		<!-- do something with objects -->
		<!--- 
			1:First clear current published objects 
			2:Query all staged pageObjects
			2a:Add a publishedPagesArchiveRecord
			3:Insert them into pageObjets as published
				AND into publishedPageObjectsArchive
			
		--->
		<!--- 1 --->
		<cfquery name="qs.clear" datasource="#variables.request.getvar('dsn')#">
			UPDATE pageObjects SET deleted = 1
			WHERE pageid = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
			AND status = 'published'
			AND deleted = 0
			AND siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">	
		</cfquery>
		
		<!--- 2 --->
		<cfquery name="qs.getUnpublished" datasource="#variables.request.getvar('dsn')#">
			SELECT id, name, [module], data, pageid, siteid, status, deleted, memberType
			FROM pageObjects
			WHERE 
				pageid = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
				AND status = 'staged'
				AND deleted = 0
				AND siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">	
		</cfquery>

		<!--- 2a --->
		<cfset lcl.publishedpagesarchiverecordid = createuuid()>
		<cfquery name="qs.publishedPagesArchiveRecord" datasource="#variables.request.getvar('dsn')#">
			INSERT INTO [publishedPagesArchive](
				[id]
				,[userid]
				,[pageid]
				,[siteid]
			)VALUES(
				<cfqueryparam value="#lcl.publishedpagesarchiverecordid#" cfsqltype="cf_sql_varchar">
	            ,<cfqueryparam value="#variables.userobj.getUserId()#" cfsqltype="cf_sql_varchar">
	            ,<cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
				,<cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">	
			)
		</cfquery>

		<!--- 3 --->
		<cfloop query="qs.getUnpublished">
			<cfif listfindnocase('simplecontent,htmlcontent', qs.getUnpublished.module) 
					AND left(qs.getUnpublished.data,2) NEQ "{}">
				<cfset qs.json = createobject('component', 'utilities.json')>
				<cfset qs.jsondata = qs.json.decode(qs.getUnpublished.data)>
				<cfset qs.data =  qs.jsondata.content>
			<cfelse>
				<cfset qs.data = qs.getUnpublished.data>
			</cfif>
			
			<cfquery name="qs.rebublish" datasource="#variables.request.getvar('dsn')#">
				INSERT INTO pageObjects (
					id, name, [module], data, pageid, memberType, siteid, status
				) VALUES (
					<cfqueryparam value="#qs.getUnpublished.id#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#qs.getUnpublished.name#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#qs.getUnpublished.module#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#qs.data#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#qs.getUnpublished.memberType#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">,
					'published'
				)
			</cfquery>
			
			<cfquery name="qs.publishedPageObjectsArchive" datasource="#variables.request.getvar('dsn')#">
				INSERT INTO publishedPageObjectsArchive (
					id, name, [module], data, pageid, memberType, siteid, publishedPageArchiveId
				) VALUES (
					<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#qs.getUnpublished.name#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#qs.getUnpublished.module#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#qs.data#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#qs.getUnpublished.memberType#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#lcl.publishedpagesarchiverecordid#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
		</cfloop>
		
        <cfset variables.observeEvent('publish page', variables.itemData)>
        
	</cffunction>
		
	<cffunction name="getPageInfo">
		<cfset var tree = variables.pages.getSiteMapObj('staged')>
		<cfset var parent = tree.getParent(getPageId())>
		<cfset var md = tree.getItem(getPageId())>
		<cfset var tmp = arraynew(1)>
		<cfset var path = "">

		<cfif getPageId() NEQ "" AND md.recordcount EQ "">
			<cfthrow message="incoherent state. id is not blank but md item is empty">
		</cfif>
		
		<!--- <cfset md.path[1] = getPath() & rereplace(md.pagename,"[^a-zA-Z0-9]","","all")  & '/'> --->
		<cfset md.path[1] = getPath() & md.pageurl  & '/'>
		<cfset tmp = arraynew(1)>
	
		<cfreturn md>
	</cffunction>
	
	<cffunction name="getPath" output="false">
		<cfargument name="view" default="staged">
		
		<cfreturn variables.itemdata.urlpath>
	</cffunction>
	
	<cffunction name="getPageId" output="false">
		<cfreturn variables.itemdata.id>
	</cffunction>
	
	<cffunction name="getObjects">
		<cfset var q = "">
		
		<cfquery name="q" datasource="#variables.request.getvar('dsn')#">
			SELECT id, pageid, [module], name, data, membertype FROM pageObjects_view
			WHERE pageid = <cfqueryparam value="#variables.itemData.id#" cfsqltype="cf_sql_varchar">
			AND siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
			AND status = 'staged'
			ORDER BY [name], [module]
		</cfquery>

		<cfreturn q>
	</cffunction>
	
	<cffunction name="deleteObjects">
		<cfset var q = "">
		
		<cfquery name="q" datasource="#variables.request.getvar('dsn')#">
			DELETE FROM pageObjects
			WHERE pageid = <cfqueryparam value="#variables.itemData.id#" cfsqltype="cf_sql_varchar">
			
		</cfquery>
	</cffunction>

	<cffunction name="getHistory">
		<cfreturn querynew('hello')>
	</cffunction>

</cfcomponent>
	