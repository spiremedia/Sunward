<cfcomponent name="model" output="false">
Not being used<CFABORT>
	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfset variables.request = arguments.request>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getSecurityGroups" output="false">
		<cfset var sg = "">
	
		<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				id, name
			FROM securityGroups_view
			ORDER BY name
		</cfquery>
		
		<cfreturn sg/>
	</cffunction>
	
	<cffunction name="getSecurityGroup" output="false">
		<cfargument name="id">
		<cfset var sg = structnew()>
	
	
		<cfquery name="sg.Item" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				id, name, description
			FROM securityGroups_view
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfquery name="sg.Itemquery" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				sgid, name, description, itemname, modulename
			FROM securityGroupItems_join
			WHERE sgid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		

		
		<!--- reformat into object of objects for better usefulenss --->
		<cfset sg.itemstruct = structnew()>
		
		<cfoutput query="sg.itemquery" group="modulename">
			<cfset sg.itemstruct[modulename] = structnew()>
			<cfset sg.itemstruct[modulename]['items'] = ''>
			<cfoutput>
				<cfset sg.itemstruct[modulename]['items'] = 
					listappend(sg.itemstruct[modulename]['items'],itemname)>
			</cfoutput>
		</cfoutput>
				
		<cfquery name="sg.Users" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				userid, fname, lname
			FROM usersinsecuritygroup_join
			WHERE securitygroupid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
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
		<cfset var vdtr = createObject('component','utilites.datavalidator').init()>
		<cfset var mylocal = structnew()>
		
		<!--- valiation for new users --->
		
		<cfset vdtr.notblank('name', requestvars.name, 'The Security Group Name is required.')>
		
		<cfparam name="requestvars.usersingroup" default="">
		<cfloop list="#requestvars.usersingroup#" index="usrid">
			<cfquery name="mylocal.usercheck" datasource="#variables.request.getvar('dsn')#">
				SELECT fname, lname, name
				FROM securityGroupUsers 
				INNER JOIN securityGroups ON securitygroupusers.securitygroupid = securitygroups.id
				INNER JOIN users ON securityGroupUsers.userid = users.id
				WHERE userid = <cfqueryparam value="#usrid#" cfsqltype="cf_sql_varchar">
					AND securitygroupusers.securitygroupid <> <cfqueryparam value="#requestvars.id#" cfsqltype="cf_sql_varchar">		
			</cfquery>
			
			<cfif mylocal.usercheck.recordcount>
				<cfset vdtr.addError('usersingroup',"User '#mylocal.usercheck.fname# #mylocal.usercheck.lname#' is already in '#mylocal.usercheck.name#'. Users may only be in one group." )>
			</cfif>
		</cfloop>
		
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var id = "">
		<cfif variables.itemData.id EQ 0>
			<cfset id = insertGroup()>
		<cfelse>
			<cfset id = updateGroup()>
		</cfif>
		<cfreturn id>
	</cffunction>
	
	<cffunction name="insertGroup" output="false">
		<cfset var grp = "">
		<cfset var fixedname= "">
		<cfset var itminsrt = "">
		<cfset var id = createuuid()>
		<cfset var si = getXmlSecurityItems()>
		<cfset var formdata = variables.itemdata>
		
		<!--- update the item record --->
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			INSERT INTO securityGroups ( 
				id,
				name,
				description
			)VALUES (
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.name#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.description#" cfsqltype="cf_sql_varchar">
			)			
		</cfquery>
		
		<!--- add records for each security item --->
		<cfloop from="1" to="#arraylen(si)#" index="sgitm">
			<cfset lcl.mysecuritylist = listappend(si[sgitm].securityitems, "View")>
			<cfloop list="#lcl.mysecuritylist#" index="itm">
				<cfset fixedname = rereplace(itm,"[^a-zA-Z0-9]","_","all")>

				<cfif structkeyexists(variables.itemdata, "#si[sgitm].name#_items") 
				  AND listfind(variables.itemdata["#si[sgitm].name#_items"],fixedname)>
					  
					<cfquery name="itminsrt" datasource="#variables.request.getvar('dsn')#">
						INSERT INTO securityGroupItems ( 
							id,
							securitygroupid,
							modulename,
							itemname
						)VALUES (
							<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#si[sgitm].name#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#itm#" cfsqltype="cf_sql_varchar">
						)			
					</cfquery>
				</cfif>
			</cfloop>
		</cfloop>
		
		<!--- insert some users --->
		<cfloop list="#variables.itemdata.usersingroup#" index="usrid">
			<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
				INSERT INTO securityGroupUsers ( 
					id,
					securityGroupId,
					userid
				)VALUES (
					<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#usrid#" cfsqltype="cf_sql_varchar">			)			
			</cfquery>
		</cfloop>
		
		<cfreturn id/>
	</cffunction>
	
	<cffunction name="updateGroup" output="false">
		<cfset var grp = "">
		<cfset var fixedname= "">
		<cfset var itminsrt = "">
		<cfset var si = getXmlSecurityItems()>
		<cfset var formdata = variables.itemdata>
	
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			UPDATE securityGroups SET 
				name = <cfqueryparam value="#variables.itemdata.name#" cfsqltype="cf_sql_varchar">,
				description = <cfqueryparam value="#variables.itemdata.description#" cfsqltype="cf_sql_varchar">
			WHERE 
				id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<!--- clear security items for this item --->
		<cfset clearsecurityItems(variables.itemdata.id)>
		
		
		<!--- add records for each security item --->
		<cfloop from="1" to="#arraylen(si)#" index="sgitm">
			<cfset lcl.mysecuritylist = listappend(si[sgitm].securityitems, "View")>
			<cfloop list="#lcl.mysecuritylist#" index="itm">
				<cfset fixedname = rereplace(itm,"[^a-zA-Z0-9]","_","all")>
				
				<cfif structkeyexists(variables.itemdata, "#si[sgitm].name#_items") 
				  AND listfind(variables.itemdata["#si[sgitm].name#_items"],fixedname)>
				
					<cfquery name="itminsrt" datasource="#variables.request.getvar('dsn')#">
						INSERT INTO securityGroupItems ( 
							id,
							securitygroupid,
							modulename,
							itemname
						)VALUES (
							<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#si[sgitm].name#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#itm#" cfsqltype="cf_sql_varchar">
						)			
					</cfquery>
				</cfif>
			</cfloop>
		</cfloop>
		
		<!--- clear and recreate the users --->
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			DELETE FROM securityGroupUsers 
			WHERE securitygroupid = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">		
		</cfquery>
		
		<cfloop list="#variables.itemdata.usersingroup#" index="usrid">
			<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
				INSERT INTO securityGroupUsers ( 
					id,
					securityGroupId,
					userid
				)VALUES (
					<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#usrid#" cfsqltype="cf_sql_varchar">			)			
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
			DELETE FROM securityGroupItems 
			WHERE securitygroupid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
	</cffunction>
	
	<cffunction name="validateDelete" output="false">
		<cfargument name="id" required="true">
		
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var itmcheck = "">
		
		<cfquery name="itmcheck" datasource="#variables.request.getvar('dsn')#">
			SELECT COUNT(*) cnt FROM usersinsecuritygroup_join 
			WHERE securitygroupid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
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
			FROM usersInSecurityGroup_join sgu
			INNER JOIN users_view u ON sgu.userid = u.id
			WHERE sgu.sguid= <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		
		<cfreturn g>
	</cffunction>
	
	<cffunction name="deletegroup" output="false">
		<cfargument name="id" required="true">
		
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		
		<cfset var g = "">
		
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			UPDATE securityGroups SET deleted=1
			WHERE id= <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		
		<cfset clearsecurityitems(arguments.id)>
	</cffunction>

</cfcomponent>
	