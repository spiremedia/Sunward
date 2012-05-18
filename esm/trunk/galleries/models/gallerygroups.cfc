<cfcomponent name="Gallery Groups" output="false" extends="resources.abstractmodel">

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
	
		<cfset sg = getGalleryGroup(id = arguments.id)>		
	
		<cfparam name="variables.itemdata" default="#structnew()#">
		
		<cfloop list="#sg.columnlist#" index="itm">
			<cfset variables.itemdata[itm] = sg[itm][1]>
		</cfloop> 
		
		<cfset variables.itemdata.id = arguments.id>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getGalleryGroups" output="false">
		<cfset var sg = "">

		<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				id, name
			FROM galleryGroups_view
			ORDER BY name
		</cfquery>

		<cfreturn sg/>
	</cffunction>
	
	<cffunction name="search" output="false">
		<cfargument name="criteria" required="true">
		<cfset var sg = "">
	

			<!--- superuser can see all Images in all Image groups --->
			<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
				SELECT id, name, description, modified 
				FROM galleryGroups_view
				WHERE 
				name LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> 
			</cfquery>


		
		<cfreturn sg>

	</cffunction>
	
	<cffunction name="getGalleryGroup" output="false">
		<cfargument name="id">
		<cfset var sg = structnew()>
	
		<cfquery name="sg.Item" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				id, name, description
			FROM galleryGroups_view
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
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
		
		<cfset vdtr.notblank('name', requestvars.name, 'The Image Group Name is required.')>
				
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var id = "">
		<cfif variables.itemData.id EQ "">
			<cfset id = insertGroup()>
			<cfset variables.observeEvent('insert gallerygroup', variables.itemData)>
		<cfelse>
			<cfset id = updateGroup()>
			<cfset variables.observeEvent('update gallerygroup', variables.itemData)>
		</cfif>
		<cfreturn id>
	</cffunction>
	
	<cffunction name="insertGroup" output="false" access="private">
		<cfset var grp = "">
		<cfset var fixedname= "">
		<cfset var itminsrt = "">
		<cfset var id = createuuid()>
		<cfset var formdata = variables.itemdata>
		<cfset variables.itemdata.id = id>
		
		<!--- update the item record --->
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			INSERT INTO galleryGroups ( 
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
	
	<cffunction name="updateGroup" output="false" access="private">
		<cfset var grp = "">
		<cfset var fixedname= "">
		<cfset var itminsrt = "">
		<cfset var formdata = variables.itemdata>
	
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			UPDATE galleryGroups SET 
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
		
		<!--- verify the Image group does not have children Images --->	
		<cfquery name="me" datasource="#variables.request.getvar('dsn')#">
			SELECT count(*) cnt 
			FROM galleryImagesToGroup
			WHERE galleryGroupId = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			AND siteid = <cfqueryparam value="#variables.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif me.cnt>
			<cfset vdtr.addError('id', 'There are Images that belong to this Image group. Please delete the Images first.')>
		</cfif>
	
		<cfreturn vdtr>
		
	</cffunction>
	
	<cffunction name="deletegroup" output="false">
		<cfargument name="id" required="true">
		
		<cfset var g = "">		
		<cfset load(arguments.id)>
		<cfset variables.observeEvent('delete gallerygroup', variables.itemData)>
		
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			UPDATE galleryGroups SET deleted=1
			WHERE id= <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		
	</cffunction>

</cfcomponent>
	