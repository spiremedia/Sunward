<cfcomponent name="Member Types" output="false" extends="resources.abstractModel">

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
		
		<cfset sg = getMemberType(id = arguments.id)>	
	
		<cfparam name="variables.itemdata" default="#structnew()#">
		
		<cfloop list="#sg.columnlist#" index="itm">
			<cfset variables.itemdata[itm] = sg[itm][1]>
		</cfloop> 
		
		<cfset variables.itemdata.id = arguments.id>
   
		<cfreturn this>
	</cffunction>
    
 	<cffunction name="getMemberTypes" output="false">
		<cfset var g = "">
		
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			SELECT id, name, description, modified
			FROM memberTypes
			ORDER BY name
		</cfquery>
		
		<cfreturn g/>
	</cffunction>
	
	<cffunction name="search" output="false">
		<cfargument name="criteria" required="true">
		<cfset var sg = "">
	
		<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
			SELECT id, name, description, modified 
			FROM memberTypes
			WHERE name LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		
		<cfreturn sg>
	</cffunction>
	
	<cffunction name="getMemberType" output="false">
		<cfargument name="id">
		<cfset var sg = "">
	
		<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
			SELECT id, name, description, modified
			FROM memberTypes
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfreturn sg />
	</cffunction>
	
	<cffunction name="setvalues">
		<cfargument name="itemdata">
	
		<cfset variables.itemdata = arguments.itemdata>
		
	</cffunction>
	
	<cffunction name="validate">		
		<cfset var lcl = structnew()>
		<cfset var requestvars = variables.itemData>
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var mylocal = structnew()>
		
		<cfset vdtr.notblank('name', requestvars.name, 'The Member Types Name is required.')>
		<cfset vdtr.maxlength('name', 50, requestvars.name, 'The Member Types Name should not exceed 50 characters in length.')>
		<cfset vdtr.maxlength('description', 500, requestvars.description, 'The Description should not exceed 500 characters in length.')>
		
		<!--- check this name not already used --->
		<cfquery name="mylocal.namecheck" datasource="#variables.request.getvar('dsn')#" result="m">
			SELECT id
			FROM memberTypes 
			WHERE name = <cfqueryparam value="#requestvars.name#" cfsqltype="cf_sql_varchar">
			AND id != <cfqueryparam value="#requestvars.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif mylocal.nameCheck.recordcount>
			<cfset vdtr.addError('name',"This Member Type Name is already in use. Names must be unique." )>
		</cfif>
        	
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="saveMemberType">
		<cfset var id = "">
		<cfif variables.itemData.id EQ ''>
			<cfset id = insertMemberType()>
			<cfset variables.observeEvent('insert member type', variables.itemData)>
		<cfelse>
			<cfset id = updateMemberType()>
			<cfset variables.observeEvent('update member type', variables.itemData)>
		</cfif>
		<cfreturn id>
	</cffunction>   
	
	<cffunction name="insertMemberType" output="false">
		<cfset var grp = "">
		<cfset var id = createuuid()>
		<cfset variables.itemdata.id = id>
		
		<!--- update the item record --->
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			INSERT INTO memberTypes ( 
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
	
	<cffunction name="updateMemberType" output="false">
		<cfset var grp = "">
	
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			UPDATE memberTypes SET 
				name = <cfqueryparam value="#variables.itemdata.name#" cfsqltype="cf_sql_varchar">,
				description = <cfqueryparam value="#variables.itemdata.description#" cfsqltype="cf_sql_varchar">, 
				modified = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
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
		
		<!--- verify the member type is not used in pages --->	
		<cfquery name="me" datasource="#variables.request.getvar('dsn')#">
			SELECT DISTINCT 'Page : ' + sp.pagename loc 
			FROM sitepages sp 
			WHERE sp.memberTypes LIKE <cfqueryparam value="%#arguments.id#%" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		
		<cfif me.recordcount>
        	<cfset vdtr.addError('name', "This Member Type is used as a Page Restriction in ""#valuelist(me.loc,", ")#"".  Please delete these associations before deleting this Member Type.")>
        </cfif>		
		
		<!--- verify the member type is not used by members --->	
		<cfquery name="me" datasource="#variables.request.getvar('dsn')#">
			SELECT DISTINCT 'Member : ' + name loc 
			FROM members_view
			WHERE memberTypes LIKE <cfqueryparam value="%#arguments.id#%" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		
		<cfif me.recordcount>
        	<cfset vdtr.addError('name', "This Member Type is used by ""#valuelist(me.loc,", ")#"".  Please delete these associations before deleting this Member Type.")>
        </cfif>
	
		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="deleteMemberType" output="false">
		<cfargument name="id" required="true">
		<cfset var users = "">
		
		<cfset load(arguments.id)>
		<cfset variables.observeEvent('delete member type', variables.itemData)>
		
		<cfquery name="users" datasource="#variables.request.getvar('dsn')#">
			DELETE FROM memberTypes
			WHERE id= <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		
	</cffunction>
    
</cfcomponent>