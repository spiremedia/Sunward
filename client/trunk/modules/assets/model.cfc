<cfcomponent name="asset" extends="resources.abstractModel">
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfreturn this>	
	</cffunction>
	<cffunction name="getAsset">
		<cfargument name="id" required="true">
		<cfset var me = "">
		<cfquery name="me" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT id, name, filename, assetgroupid, filesize
			FROM assets_view
			WHERE  deleted = 0
				AND id IN (<cfqueryparam value="#arguments.id#" list="yes" cfsqltype="cf_sql_varchar">)
				AND (startdate IS NULL OR startdate < getDate() )
				AND (enddate IS NULL OR enddate > getDate() )
			ORDER BY name
		</cfquery>

		<cfreturn me>
	</cffunction>
	
	<cffunction name="getAssetGroup">
		<cfargument name="assetgroupid" required="true">
		<cfset var me = "">
		<cfquery name="me" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT id, name, filename, assetgroupid, filesize
			FROM assets_view
			WHERE  deleted = 0
				AND assetgroupid = <cfqueryparam value="#arguments.assetgroupid#">
				AND (startdate IS NULL OR startdate < getDate() )
				AND (enddate IS NULL OR enddate > getDate() )
			ORDER BY name
		</cfquery>
		<cfreturn me>
	</cffunction>
	
	<cffunction name="getAvailableAssets">
		<cfargument name="assetid" required="false" type="array" default="#arrayNew(1)#">
		<cfargument name="assetgroupid" required="false" type="array" default="#arrayNew(1)#">
		
		<cfset var me = "">
		
		<cfif not arrayLen(arguments.assetid)>
			<cfset arrayAppend(arguments.assetid,'BLANK')>
		</cfif>
		<cfif not arrayLen(arguments.assetgroupid)>
			<cfset arrayAppend(arguments.assetgroupid,'BLANK')>
		</cfif>
		
		<cfquery name="me" datasource="#variables.requestObject.getVar('dsn')#" >
			SELECT id, name, filename, assetgroupid, filesize, description
			FROM assets_view
			WHERE  deleted = 0
				AND (startdate IS NULL OR startdate < getDate() )
				AND (enddate IS NULL OR enddate > getDate() )
				AND (
					id IN (<cfqueryparam value="#arrayToList(arguments.assetid)#" list="yes">)
				OR 
					assetgroupid IN (<cfqueryparam value="#arrayToList(arguments.assetgroupid)#" list="yes">)
				)
			ORDER BY name
		</cfquery>
		
		<cfreturn me>
	</cffunction>
	
	<cffunction name="getPageAssets">		
		<cfset var me = "">		
		<cfquery name="me" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT data 
			FROM pageObjects_view
			WHERE  status = 'published'
				AND module = 'Assets'
				AND siteid = <cfqueryparam value="#variables.requestObject.getVar('siteid')#">
		</cfquery>
		
		<cfreturn me>
	</cffunction>
    
    	<cffunction name="getAllAssets">
		<cfset var me = "">

		<cfquery name="me" datasource="#variables.requestObject.getVar('dsn')#" >
			SELECT id, name, filename, assetgroupid, filesize, description
			FROM assets_view
			WHERE  deleted = 0
				AND filename <> ''
				AND (startdate IS NULL OR startdate < getDate() )
				AND (enddate IS NULL OR enddate > getDate() )
				AND (filename like '%.doc%' OR filename like '%.pdf' OR filename like '%.xls%')
		</cfquery>

		<cfreturn me>
	</cffunction>
	

</cfcomponent> 