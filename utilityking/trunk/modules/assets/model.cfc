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
				AND assetgroupid = <cfqueryparam value="#arguments.assetgroupid#" cfsqltype="cf_sql_varchar">
				AND (startdate IS NULL OR startdate < getDate() )
				AND (enddate IS NULL OR enddate > getDate() )
			ORDER BY name
		</cfquery>
		<cfreturn me>
	</cffunction>
	
	<cffunction name="getAllAssets">
		<cfset var me = "">

		<cfquery name="me" datasource="#variables.requestObject.getVar('dsn')#" >
			SELECT id, name, filename, assetgroupid, filesize, description
			FROM assets_view
			WHERE  deleted = 0
				AND (startdate IS NULL OR startdate < getDate() )
				AND (enddate IS NULL OR enddate > getDate() )
				AND (filename like '%.doc%' OR filename like '%.pdf' OR filename like '%.xls%')
		</cfquery>

		<cfreturn me>
	</cffunction>

</cfcomponent> 