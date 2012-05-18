<cfcomponent name="Content Groups" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="load" output="false">
		<cfargument name="id" required="true">
		<cfset var sg = "">
		<cfset var itm = "">
	
		<cfset sg = getContentGroup(id = arguments.id)>		
	
		<cfparam name="variables.itemdata" default="#structnew()#">
		
		<cfloop list="#sg.Item.columnlist#" index="itm">
			<cfset variables.itemdata[itm] = sg.Item[itm][1]>
		</cfloop> 
		
		<cfset variables.itemdata.id = arguments.id>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getContentGroups" output="false">
		<cfset var sg = "">
	
		<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				id, name
			FROM contentGroups_view
			WHERE siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
			ORDER BY name
		</cfquery>
		
		<cfreturn sg/>
	</cffunction>
	
	<cffunction name="search" output="false">
		<cfargument name="criteria" required="true">
		<cfset var g = "">
		
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			SELECT id, name, description, modified 
			FROM contentGroups_view
			WHERE 
			(name LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> OR
            description LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">) 
			AND siteid = <cfqueryparam value="#variables.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
            
            UNION 
            
            SELECT cg1.id, cg1.name, cg1.description, cg1.modified 
			FROM contentGroups_view cg1
            INNER JOIN contentGroupUsers cgu ON cgu.contentGroupId = cg1.id
            INNER JOIN users u ON u.id = cgu.userid
			WHERE 
			(u.fname LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> OR 
            u.lname LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">)
			AND cg1.siteid = <cfqueryparam value="#variables.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
            
            UNION 
            
            SELECT cg2.id, cg2.name, cg2.description, cg2.modified 
			FROM contentGroups_view cg2
            INNER JOIN contentGroupAssetGroups cgag ON cgag.contentGroupId = cg2.id
            INNER JOIN assetGroups ag ON ag.id = cgag.assetGroupId
			WHERE 
			(ag.name LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> OR 
            ag.description LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">)
			AND cg2.siteid = <cfqueryparam value="#variables.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfreturn g>

	</cffunction>
	
	<cffunction name="getContentGroup" output="false">
		<cfargument name="id">
		<cfset var sg = structnew()>
	
	
		<cfquery name="sg.Item" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				id, name, description
			FROM contentGroups_view
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
				AND  siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfquery name="sg.Pages" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				id, pageid
			FROM contentGroupLocations_view
			WHERE contentgroupid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			AND  siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>
			
		<cfquery name="sg.Users" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				userid, fname, lname
			FROM usersInContentGroup_join
			WHERE contentgroupid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			AND  cgsiteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>
			
		<cfquery name="sg.AssetGroups" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				assetgroupid as id, assetgroupname as name
			FROM assetGroupsInContentGroup_join
			WHERE contentgroupid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			AND  cgsiteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
			ORDER BY assetgroupname
		</cfquery>
		
		<cfset sg.id = arguments.id>

		<cfreturn sg/>
	</cffunction>
	
	<cffunction name="getUserLocations" output="false">
		<cfargument name="id">
		
		<cfset var sg = structnew()>
	
		<cfquery name="sg.Item" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				cgl.pageid, cgl.urlpath
			FROM contentGroupUsers_view cgu
			INNER JOIN contentGroupLocations_view cgl ON cgl.contentGroupId = cgu.contentGroupId
			WHERE cgu.userid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			AND cgu.siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfreturn sg.item/>
	</cffunction>
	
	<cffunction name="setvalues">
		<cfargument name="itemdata">
	
		<cfset variables.itemdata = arguments.itemdata>
		
		<cfif not StructKeyExists(variables.itemdata,'active')>
			<cfset variables.itemdata.active = 0>
		</cfif>
		
	</cffunction>
	
	<cffunction name="validate">		
		<cfset var lcl = structnew()>
		<cfset var requestvars = variables.itemData>
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var mylocal = structnew()>
		
		<!--- valiation for new users --->
		
		<cfset vdtr.notblank('name', requestvars.name, 'The Content Group Name is required.')>
				
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var id = "">
		<cfif variables.itemData.id EQ 0>
			<cfset id = insertGroup()>
			<cfset variables.observeEvent('insert contentgroup', variables.itemData)>
		<cfelse>
			<cfset id = updateGroup()>
			<cfset variables.observeEvent('update contentgroup', variables.itemData)>
		</cfif>
		<cfreturn id>
	</cffunction>
	
	<cffunction name="insertGroup" output="false">
		<cfset var grp = "">
		<cfset var fixedname= "">
		<cfset var itminsrt = "">
		<cfset var id = createuuid()>
		<cfset var formdata = variables.itemdata>
		<cfset variables.itemdata.id = id>
		
		<!--- update the item record --->
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			INSERT INTO contentGroups ( 
				id,
				name,
				description,
				siteid
			)VALUES (
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.name#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.description#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
			)			
		</cfquery>
		
		<!--- insert some users --->
		<cfparam name="variables.itemdata.usersingroup" default="">
		<cfloop list="#variables.itemdata.usersingroup#" index="usrid">
			<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
				INSERT INTO contentGroupUsers ( 
					id,
					contentGroupId,
					userid,
					siteid
				)VALUES (
					<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#usrid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
				)			
			</cfquery>
		</cfloop>
		
		<!--- insert some siteLocations --->
		<cfparam name="variables.itemdata.SitePages" default="">
		<cfloop list="#variables.itemdata.SitePages#" index="pageid">
			<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
				INSERT INTO contentGroupLocations ( 
					id,
					contentGroupId,
					pageid,
					siteid
				)VALUES (
					<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#pageid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
				)			
			</cfquery>
		</cfloop>
		
		<!--- insert some asset groups --->
		<cfparam name="variables.itemdata.assetgroupsingroup" default="">
		<cfloop list="#variables.itemdata.assetgroupsingroup#" index="assetgroupid">
			<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
				INSERT INTO contentGroupAssetGroups ( 
					id,
					contentGroupId,
					assetGroupid
				)VALUES (
					<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#assetgroupid#" cfsqltype="cf_sql_varchar">
				)			
			</cfquery>
		</cfloop>
		
		<cfreturn id/>
	</cffunction>
	
	<cffunction name="updateGroup" output="false">
		<cfset var grp = "">
		<cfset var fixedname= "">
		<cfset var itminsrt = "">
		<cfset var formdata = variables.itemdata>
	
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			UPDATE contentGroups SET 
				name = <cfqueryparam value="#variables.itemdata.name#" cfsqltype="cf_sql_varchar">,
				description = <cfqueryparam value="#variables.itemdata.description#" cfsqltype="cf_sql_varchar">
			WHERE 
				id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
				AND siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<!--- clear and recreate the users --->
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			DELETE FROM contentGroupUsers 
			WHERE contentgroupid = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">		
			AND  siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfparam  name="variables.itemdata.usersingroup" default="">
		<cfloop list="#variables.itemdata.usersingroup#" index="usrid">
			<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
				INSERT INTO contentGroupUsers ( 
					id,
					contentGroupId,
					userid,
					siteid
				)VALUES (
					<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#usrid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">			
				)			
			</cfquery>
		</cfloop>
		
		<!--- clear and recreate the pages --->
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			DELETE FROM contentGroupLocations 
			WHERE contentgroupid = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">		
			AND  siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfparam name="variables.itemdata.SitePages" default="">
		<cfloop list="#variables.itemdata.SitePages#" index="pageid">
			<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
				INSERT INTO contentGroupLocations ( 
					id,
					contentGroupId,
					pageid,
					siteid
				)VALUES (
					<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#pageid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
				)			
			</cfquery>
		</cfloop>		
		
		<!--- clear and recreate the asset groups --->
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			DELETE FROM contentGroupAssetGroups 
			WHERE contentgroupid = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">		
		</cfquery>
		
		<cfparam  name="variables.itemdata.assetgroupsingroup" default="">
		<cfloop list="#variables.itemdata.assetgroupsingroup#" index="assetgroupid">
			<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
				INSERT INTO contentGroupAssetGroups ( 
					id,
					contentGroupId,
					assetGroupid
				)VALUES (
					<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#assetgroupid#" cfsqltype="cf_sql_varchar">		
				)			
			</cfquery>
		</cfloop>
		
		<cfreturn variables.itemdata.id>
	</cffunction>
	
	<cffunction name="setSecurityItemsFromXml">
		<cfargument name="d" required="true">
		<cfset variables.securityItems = arguments.d>
	</cffunction>
	
	<cffunction name="getXmlSecurityItems">
		<cfreturn securityItems>
	</cffunction>
	
	<cffunction name="clearSecurityItems" output="false">
		<cfargument name="id" required="true">
		
		<cfset var q = "">
		
		<cfquery name="itmclr" datasource="#variables.request.getvar('dsn')#">
			DELETE FROM contentGroupLocations 
			WHERE contentgroupid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			AND siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfquery name="itmclr" datasource="#variables.request.getvar('dsn')#">
			DELETE FROM contentGroupAssetGroups 
			WHERE contentgroupid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
	</cffunction>
	
	<cffunction name="validateDelete" output="false">
		<cfargument name="id" required="true">
		
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var itmcheck = "">
		
		<cfquery name="itmcheck" datasource="#variables.request.getvar('dsn')#">
			SELECT COUNT(*) cnt FROM usersincontentgroup_join 
			WHERE contentgroupid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			AND cgsiteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif itmcheck.cnt NEQ 0>
			<cfset vdtr.addError('delete','There are users in this group. Please delete them before deleting this group')>
		</cfif>
	
		<cfreturn vdtr>
		
	</cffunction>
	
	<cffunction name="getUsers" output="false">
		<cfargument name="id" required="true">
		
		<cfset var g = "">
		
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			SELECT u.uid, u.fname, u.lname
			FROM usersInContentGroup_join sgu
			INNER JOIN users_view u ON sgu.userid = u.id
			WHERE sgu.sguid= <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
			AND sgu.siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfreturn g>
	</cffunction>
	
	<cffunction name="deletegroup" output="false">
		<cfargument name="id" required="true">
		
		<cfset var g = "">		
		<cfset load(arguments.id)>
		<cfset variables.observeEvent('delete contentgroup', variables.itemData)>
		
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			UPDATE contentGroups SET deleted=1
			WHERE id= <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
			AND  siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset clearsecurityitems(arguments.id)>
	</cffunction>

</cfcomponent>
	