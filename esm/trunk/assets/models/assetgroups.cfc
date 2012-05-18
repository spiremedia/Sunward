<cfcomponent name="Asset Groups" output="false" extends="resources.abstractmodel">

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
	
		<cfset sg = getAssetGroup(id = arguments.id)>		
	
		<cfparam name="variables.itemdata" default="#structnew()#">
		
		<cfloop list="#sg.Item.columnlist#" index="itm">
			<cfset variables.itemdata[itm] = sg.Item[itm][1]>
		</cfloop> 
		
		<cfset variables.itemdata.id = arguments.id>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getAssetGroups" output="false">
		<cfset var sg = "">
	
		<!--- <cfif variables.userobj.issuper()> --->
			<!--- superuser can see all assets in all asset groups --->
			<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
				SELECT 
					id, name
				FROM assetGroups_view
				ORDER BY name
			</cfquery>

		<!--- <cfelse>
			<!--- user can see only assets in asset groups in their content groups --->
			<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
				SELECT 
					assetgroupid AS id, assetgroupname AS name
				FROM assetGroupsInContentGroupUsers_join
				WHERE userid = <cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar">
				ORDER BY name
			</cfquery>	

		</cfif> --->
		
		<cfreturn sg/>
	</cffunction>
	
	<cffunction name="search" output="false">
		<cfargument name="criteria" required="true">
		<cfset var sg = "">
	
		<cfif variables.userobj.issuper()>
			<!--- superuser can see all assets in all asset groups --->
			<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
				SELECT id, name, description, modified 
				FROM assetGroups_view
				WHERE 
				name LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> 
			</cfquery>

		<cfelse>
			<!--- user can see only assets in asset groups in their content groups --->
			<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
				SELECT 
					assetgroupid AS id, assetgroupname AS name, assetgroupdescription as description, assetgroupmodified as modified
				FROM assetGroupsInContentGroupUsers_join
				WHERE userid = <cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar">
				AND assetgroupname LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> 
				ORDER BY name
			</cfquery>	

		</cfif>
		
		<cfreturn sg>

	</cffunction>
	
	<cffunction name="getAssetGroup" output="false">
		<cfargument name="id">
		<cfset var sg = structnew()>
	
		<cfquery name="sg.Item" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				id, name, description
			FROM assetGroups_view
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset sg.id = arguments.id>

		<cfreturn sg/>
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
		
		<cfset vdtr.notblank('name', requestvars.name, 'The Asset Group Name is required.')>
				
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var id = "">
		<cfif variables.itemData.id EQ 0>
			<cfset id = insertGroup()>
			<cfset variables.observeEvent('insert assetgroup', variables.itemData)>
		<cfelse>
			<cfset id = updateGroup()>
			<cfset variables.observeEvent('update assetgroup', variables.itemData)>
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
			INSERT INTO assetGroups ( 
				id,
				name,
				description
			)VALUES (
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.name#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.description#" cfsqltype="cf_sql_varchar">
			)			
		</cfquery>
		
		<cfreturn id/>
	</cffunction>
	
	<cffunction name="updateGroup" output="false">
		<cfset var grp = "">
		<cfset var fixedname= "">
		<cfset var itminsrt = "">
		<cfset var formdata = variables.itemdata>
	
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			UPDATE assetGroups SET 
				name = <cfqueryparam value="#variables.itemdata.name#" cfsqltype="cf_sql_varchar">,
				description = <cfqueryparam value="#variables.itemdata.description#" cfsqltype="cf_sql_varchar">
			WHERE 
				id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfreturn variables.itemdata.id>
	</cffunction>
	
	<cffunction name="validateDelete" output="false">
		<cfargument name="id" required="true">
		
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var itmcheck = "">
		<cfset var me = "">			
		
		<!--- verify the asset group does not have children assets --->	
		<cfquery name="me" datasource="#variables.request.getvar('dsn')#">
			SELECT id 
			FROM assets
			WHERE deleted = 0
			AND assetgroupid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif me.recordcount>
			<cfset vdtr.addError('id', 'There are assets that belong to this asset group. Please delete the assets first.')>
		</cfif>
	
		<cfreturn vdtr>
		
	</cffunction>
	
	<cffunction name="deletegroup" output="false">
		<cfargument name="id" required="true">
		
		<cfset var g = "">		
		<cfset load(arguments.id)>
		<cfset variables.observeEvent('delete assetgroup', variables.itemData)>
		
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			UPDATE assetGroups SET deleted=1
			WHERE id= <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		
	</cffunction>

</cfcomponent>
	