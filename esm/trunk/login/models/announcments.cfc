<cfcomponent name="model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getAnnouncments" output="false">
		<cfargument name="active" default="true">
		<cfset var sg = "">
	
		<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				a.id, a.title, a.html, a.itemdate, u.fname + ' ' + u.lname AS fullname, a.active
			FROM announcments a
			INNER JOIN users u on a.modifiedby = u.id
			WHERE a.siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
			<cfif arguments.active>
				AND a.active = 1
			</cfif>
			ORDER BY a.itemdate DESC
		</cfquery>
		
		<cfreturn sg/>
	</cffunction>
	
	<cffunction name="load" output="false">
		<cfargument name="id" required="true">
		<cfset var sg = "">
		<cfset var itm = "">
	
		<cfquery name="sg" datasource="#variables.request.getvar('dsn')#" result="myre">
			SELECT 
				a.id, a.title, a.html, a.itemdate, u.fname + ' ' + u.lname AS fullname, a.active
			FROM announcments a
			INNER JOIN users u on a.modifiedby = u.id
			WHERE a.id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
				AND a.siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>
	
		<cfparam name="variables.itemdata" default="#structnew()#">
		
		<cfloop list="#sg.columnlist#" index="itm">
			<cfset variables.itemdata[itm] = sg[itm][1]>
		</cfloop> 
		
		<cfset variables.itemdata.id = arguments.id>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getField" output="false">
		<cfargument name="fieldname">
		
		<cfif not structkeyexists(variables.itemdata, fieldname)>
			<cfthrow message="field '#arguments.fieldname#' was not found">	
		</cfif>
		<cfreturn variables.itemdata[fieldname]>
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
			
		<cfset vdtr.notblank('title', requestvars.title, 'A Title is required.')>
		<cfset vdtr.isvaliddate('itemdate', requestvars.itemdate, 'The Item Date is required and must be valid.')>
		
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var id = "">
		
		<cfif variables.itemData.id EQ 0>
			<cfset id = insertAnnouncment()>
		<cfelse>
			<cfset id = updateAnnouncment()>
		</cfif>
		<cfreturn id>
	</cffunction>
	
	<cffunction name="insertAnnouncment" output="false">
		<cfset var grp = "">
		<cfset var id = createuuid()>
		<cfset variables.itemdata.id = id>
		
		
		
		<!--- update the item record --->
		<cfparam name="variables.itemdata.active" default="0">
		
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			INSERT INTO announcments ( 
				id, title, html, siteid, active, modifiedby, itemdate
			)VALUES (
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.title#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.html#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.active#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.itemdate#" cfsqltype="cf_sql_timestamp">
			)			
		</cfquery>
				
		<cfreturn id/>
	</cffunction>
										
	<cffunction name="updateannouncment" output="false">
		<cfset var grp = "">
		
		<cfparam name="variables.itemdata.active" default="0">
				
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			UPDATE announcments SET 
				title = <cfqueryparam value="#variables.itemdata.title#" cfsqltype="cf_sql_varchar">,
				html = <cfqueryparam value="#variables.itemdata.html#" cfsqltype="cf_sql_varchar">,
				active = <cfqueryparam value="#variables.itemdata.active#" cfsqltype="cf_sql_integer">,
				itemdate = <cfqueryparam value="#variables.itemdata.itemdate#" cfsqltype="cf_sql_timestamp">
			WHERE 
				id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
	
		<cfreturn variables.itemdata.id>
	</cffunction>
	
	

	<cffunction name="validateDelete" output="false">
		<cfargument name="id" required="true">
		
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>

		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="deleteAnnouncment" output="false">
		<cfargument name="id" required="true">
		
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			DELETE FROM announcments
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
			AND siteid =<cfqueryparam value="#variables.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>

	</cffunction>
	
	

	<cffunction name="getNewsTypes" output="false">

		<cfset var g = querynew('type')>
		<cfset var list = 'Firm News,Press Releases,Speaking Engagments,Articles,Advisories,Publications'>
		
		<cfloop list="#list#" index="itm">
			<cfset queryaddrow(g)>
			<cfset querysetcell(g,'type',itm)>
		</cfloop>
		
		<cfreturn g>
	</cffunction>

</cfcomponent>
	