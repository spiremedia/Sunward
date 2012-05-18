<cfcomponent name="getTemplates">
	
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		<cfset structappend(variables, arguments)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="get">
		<cfset var views = "">
		<cftry>
			<cfset views = createObject('component', 'utilities.http').init().getPage(variables.userobject.getCurrentSiteUrl() & 'system/getViews/')>
			<cfset views = createObject('component', 'utilities.json').decode(views)>
			
			<cfcatch>
				<cfoutput>
				Trying to get views at #variables.userobject.getCurrentSiteUrl()#system/getViews/<br>
				Found #views#
				<cfdump var="#cfcatch#">
				</cfoutput>
				<cfabort>
			</cfcatch>
		</cftry>
		<cfreturn views>
	</cffunction>
	
	<cffunction name="getTemplateItems">
		<cfargument name="templatename" required="true">
		<cfargument name="contentSpotName">
		<cfset var q = "">
		<cfquery name="q" datasource="#requestObject.getVar("dsn")#">
			SELECT id, templateName, templateSpotName, moduleOption, moduleParameters
			FROM templateinfo 
			WHERE 
				templateName = <cfqueryparam value="#arguments.templatename#" cfsqltype="cf_sql_varchar">
				<cfif structkeyexists(arguments, "templateSpotName")>
					AND templateSpotName = <cfqueryparam value="#arguments.templateSpotName#" cfsqltype="cf_sql_varchar">
				</cfif>
		</cfquery>
		<cfreturn q>
	</cffunction>
	
	<cffunction name="validateTemplateItem">
		<cfset var vd = createObject('component','utilities.datavalidator').init()>
		<cfreturn vd>
	</cffunction>
	
	<cffunction name="saveTemplateItem">
		<cfset var tmp = structnew()>
		<cfset var q = "">
		
		<cfset tmp.templatename = requestObject.getFormUrlVar("templatename")>
		<cfset tmp.moduleparameters = requestObject.getFormUrlVar("moduleparameters")>
		<cfset tmp.moduleOption = requestObject.getFormUrlVar("moduleOption")>
		<cfset tmp.templateSpotName = requestObject.getFormUrlVar("contentSpotName")>
		<cfset tmp.templateitemid = requestObject.getFormUrlVar("templateitemid")>
		
		<cfif tmp.templateitemid EQ "">
			<cfset tmp.templateitemid = createuuid()>
			<cfquery name="q" datasource="#requestObject.getVar("dsn")#">
				INSERT INTO templateinfo (
					id,
					templatename,
					moduleparameters,
					moduleOption,
				 	templateSpotName,
				 	siteid
				) VALUES (
					<cfqueryparam value="#tmp.templateitemid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#tmp.templatename#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#tmp.moduleparameters#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#tmp.moduleOption#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#tmp.templateSpotName#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#userobject.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
		<cfelse>
			<cfquery name="q" datasource="#requestObject.getVar("dsn")#">
				UPDATE templateinfo SET
					templatename = <cfqueryparam value="#tmp.templatename#" cfsqltype="varchar">,
					moduleparameters = <cfqueryparam value="#tmp.moduleparameters#" cfsqltype="varchar">,
					moduleOption = <cfqueryparam value="#tmp.moduleOption#" cfsqltype="varchar">,
					templateSpotName = <cfqueryparam value="#tmp.templateSpotName#" cfsqltype="varchar">
				WHERE 
					id = <cfqueryparam value="#tmp.templateitemid#" cfsqltype="cf_sql_varchar">
			</cfquery>
		</cfif>
		<cfreturn tmp.templateitemid>
	</cffunction>
	
</cfcomponent>