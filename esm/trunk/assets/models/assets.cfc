<cfcomponent name="asset model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getAssets" output="false">
		<cfset var sg = "">
	
		<!--- disabled for aorn --->
		<cfif 1 EQ 1 OR  variables.userobj.issuper()>
			<!--- superuser can see all assets in all asset groups --->
			<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
				SELECT 
					assetid AS id, assetname AS name, filename, description, previewfilename, changeddate, changedby, active, startdate, enddate, assetgroupname
				FROM assetsInAssetGroup_join
				ORDER BY assetgroupname, name
			</cfquery>
		<cfelse>
			<!--- user can see only assets in asset groups in their content groups --->
			<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
				SELECT 
					assetid AS id, assetname AS name, filename, description, previewfilename, changeddate, changedby, active, startdate, enddate, assetgroupname
				FROM assetsInContentGroupUsers_join
				WHERE userid = <cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar"> 
				ORDER BY assetgroupname, name
			</cfquery>
		</cfif>
		
		<cfreturn sg/>
	</cffunction>
	
	<cffunction name="getClientModuleAssets" output="false">
		<cfset var sg = "">
	
		<cfif variables.userobj.issuper()>
			<!--- superuser can see all assets in all asset groups --->
			<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
				SELECT 
					assetid AS id, assetname + ' (in ' + assetgroupname + ')' AS name
				FROM assetsInAssetGroup_join
				ORDER BY assetgroupname, name
			</cfquery>
		<cfelse>
			<!--- user can see only assets in asset groups in their content groups --->
			<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
				SELECT 
					assetid AS id, assetname + ' (in ' + assetgroupname + ')' AS name
				FROM assetsInContentGroupUsers_join
				WHERE userid = <cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar"> 
				ORDER BY assetgroupname, name
			</cfquery>
		</cfif>
		
		<cfreturn sg/>
	</cffunction>
	
	<cffunction name="load" output="false">
		<cfargument name="id" required="true">
		<cfset var sg = "">
		<cfset var itm = "">
	
		<cfquery name="sg" datasource="#variables.request.getvar('dsn')#" result="myre">
			SELECT 
				id, name, filename, description,  previewfilename, changeddate, changedby, assetgroupid, active, startdate, enddate
			FROM assets_view
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
	
		<cfparam name="variables.itemdata" default="#structnew()#">
		
		<cfloop list="#sg.columnlist#" index="itm">
			<cfset variables.itemdata[itm] = sg[itm][1]>
		</cfloop> 
		
		<cfset variables.itemdata.id = arguments.id>
   
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getField">
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
			
		<cfset vdtr.notblank('name', requestvars.name, 'The Asset Name is required.')>
		<cfset vdtr.notblank('assetgroupid', requestvars.assetgroupid, 'The Group Name is required.')>
		<!---><cfset vdtr.notblank('description', requestvars.description, 'A Description for the search results is required.')>--->
		<cfset vdtr.maxlength('description', 255, requestvars.description, 'The Description is too long - currently #len(requestvars.description)#.  Max is 255chars.')>
		<cfif requestvars.startdate NEQ "">
			<cfset vdtr.isvaliddate('startdate', requestvars.startdate, 'The Show Date must be valid.')>
		</cfif>
		<cfif requestvars.enddate NEQ "">
			<cfset vdtr.isvaliddate('enddate', requestvars.enddate, 'The Hide Date must be valid.')>
		</cfif>
		<cfif requestvars.id EQ 0 AND requestvars.filename EQ ''>
			<cfset vdtr.notblank('filename', requestvars.filename, 'A File is required.')>
		</cfif>
	
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var id = "">
		<cfif variables.itemData.id EQ 0>
			<cfset id = insertAsset()>
		<cfelse>
			<cfset id = updateAsset()>
		</cfif>
		<cfreturn id>
	</cffunction>
	
	<cffunction name="insertAsset" output="false">
		<cfset var grp = "">
		<cfset var mainfile = ''>
		<cfset var previewfile = ''>
		
		
		<!--->
		<cfif variables.itemdata.previewfilename NEQ ''>
			<cfset previewfile = createObject('component','utilities.fileuploadandsave').init(target = 'assets', sitepath = variables.request.getVar('machineroot'), file = 'previewfilename')>
			<cfif NOT previewfile.success()>
				<cfthrow message="File not uplaoded.">
			</cfif>
			<cfset previewfile = previewfile.savedName()>
		</cfif>
		--->
		
		<cfset id = createuuid()>
		<cfset variables.itemdata.id = id>
		
		<cfif NOT directoryexists(variables.request.getVar('machineroot') & "docs/assets/#id#")>
			<cfdirectory action="create" directory="#variables.request.getVar('machineroot') & "docs/assets/" & id#">
		</cfif>
		
		<cfset mainfile = createObject('component','utilities.fileuploadandsave').init(target = 'assets/#id#', sitepath = variables.request.getVar('machineroot'), file = 'filename')>
		
		<cfif NOT mainfile.success()>
			<cfthrow message="File not uploaded.">
		</cfif>
		
		
		<cfset variables.observeEvent('add', this)>
		
		<!--- update the item record --->
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			INSERT INTO assets ( 
				id, name, filename, filesize,  changeddate, changedby, assetgroupid, active, startdate, description, enddate
			)VALUES (
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.name#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#mainfile.savedname()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#mainfile.filesize()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.assetgroupid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.active#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#variables.itemdata.startdate#" null="#(not isDate(variables.itemdata.startdate))#" cfsqltype="cf_sql_date">,
				<cfqueryparam value="#variables.itemdata.description#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.enddate#" null="#(not isDate(variables.itemdata.enddate))#" cfsqltype="cf_sql_date">
			)			
		</cfquery>
		
		<cfreturn id/>
	</cffunction>
	
	<cffunction name="updateAsset" output="false">
		<cfset var grp = "">
		<cfset var mainfilesize = "">
		<cfset var mainfile = ''>
		<cfset var previewfile = ''>
		<cfset var qryFile = "">
		<cfset var filetodelete = "">	

		
		<cfif variables.itemdata.filename NEQ ''>
	
			<!--- retrieve the filename to delete, before uploading new file --->
			<cfquery name="qryFile" datasource="#variables.request.getvar('dsn')#">
				SELECT filename
				FROM assets_view 
				WHERE id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfif qryFile.recordcount>
				<cfset filetodelete = qryFile.filename>
			</cfif>
			
			<cfif NOT directoryExists(variables.request.getVar('machineroot') & "docs/assets/#variables.itemdata.id#")>
				<cfdirectory action="create" directory="#variables.request.getVar('machineroot') & "docs/assets/" & variables.itemdata.id#" mode="664" >
			</cfif>
			
			<cfset mainfile = createObject('component','utilities.fileuploadandsave').init(target = 'assets/#variables.itemdata.id#', sitepath = variables.request.getVar('machineroot'), file = 'filename', filetodelete = filetodelete)>
			
			<cfif NOT mainfile.success()>
				<cfthrow message="File not uploaded.">
			</cfif>
			
			<cfset mainfilesize = mainfile.filesize()>
			<cfset mainfile = mainfile.savedName()>
		</cfif>
		<!--->
		<cfif variables.itemdata.previewfilename NEQ ''>
			<cfset previewfile = createObject('component','utilities.fileuploadandsave').init(target = 'assets', sitepath = variables.request.getVar('machineroot'), file = 'previewfilename')>
			<cfif NOT previewfile.success()>
				<cfthrow message="File not uplaoded.">
			</cfif>
			<cfset previewfile = previewfile.savedName()>
		</cfif>--->
			
		<cfset variables.observeEvent('edit', this)>
		
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			UPDATE assets SET 
				name = <cfqueryparam value="#variables.itemdata.name#" cfsqltype="cf_sql_varchar">,
				<cfif mainfile NEQ ''>
					filename = <cfqueryparam value="#mainfile#" cfsqltype="cf_sql_varchar">, 
					filesize = <cfqueryparam value="#mainfilesize#" cfsqltype="cf_sql_varchar">, 
				</cfif>
				startdate = <cfqueryparam value="#variables.itemdata.startdate#" null="#(not isDate(variables.itemdata.startdate))#" cfsqltype="cf_sql_date">, 
				enddate = <cfqueryparam value="#variables.itemdata.enddate#" null="#(not isDate(variables.itemdata.enddate))#" cfsqltype="cf_sql_date">, 
				changeddate = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">, 
				description = <cfqueryparam value="#variables.itemdata.description#" cfsqltype="cf_sql_varchar">,
				changedby = <cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar">, 
				assetgroupid = <cfqueryparam value="#variables.itemdata.assetgroupid#" cfsqltype="cf_sql_varchar">
			WHERE 
				id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfreturn variables.itemdata.id>
	</cffunction>

	<cffunction name="validateDelete" output="false">
		<cfargument name="id" required="true">
		
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var me = "">		
		<cfset var page = "">		
		
		<!--- verify the asset is not included on a page --->		
		<cfquery name="me" datasource="#variables.request.getvar('dsn')#">
			SELECT DISTINCT spv.pagename 
			FROM pageObjects_view pov, sitepages_view spv
			WHERE (pov.module = 'Assets' OR pov.module = 'HTMLContent')
			AND spv.id = pov.pageid
			AND pov.data like <cfqueryparam value="%#arguments.id#%" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif me.recordcount>
			<cfset vdtr.addError('assetgroupid', 'This asset is included on page "#me.pagename#". Please remove it from there before deleting the asset.')>
		</cfif>

		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="deleteAsset" output="false">
		<cfargument name="id" required="true">
		<cfset var fs = createObject('component','utilities.filesystem').init()>
		
		<cfset load(arguments.id)>

		<cfset variables.observeEvent('delete', this)>
		
		<cfset fs.delete(variables.request.getVar('machineroot') & 'docs/assets/#arguments.id#/' & variables.itemData.filename)>
		
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			DELETE assets 
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>

	</cffunction>
	
	<cffunction name="search" output="false">
		<cfargument name="criteria" required="true">
		<cfset var sg = "">
		
		<cfset variables.observeEvent('search', this)>
		
		<!--- <cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			SELECT a.id, a.name, a.fullname, a.changeddate, ag.name AS assetgroupname 
			FROM assets_view a, assetgroups_view ag
			WHERE a.assetgroupid = ag.id
			AND
			(a.name LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> 
				OR ag.name LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">)
		</cfquery>
		 --->
		
		<cfif variables.userobj.issuper()>
			<!--- superuser can see all assets in all asset groups --->
			<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
				SELECT 
					assetid AS id, assetname AS name, fullname, changeddate, assetgroupname
				FROM assetsInAssetGroup_join
				WHERE 
					(assetname LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> 
                    	OR description LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> 
						OR assetgroupname LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">)
				ORDER BY assetgroupname, name
			</cfquery>
		<cfelse>
			<!--- user can see only assets in asset groups in their content groups --->
			<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
				SELECT 
					assetid AS id, assetname AS name, fullname, changeddate, assetgroupname
				FROM assetsInContentGroupUsers_join
				WHERE userid = <cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar"> 
				AND
					(assetname LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> 
                    	OR description LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> 
						OR assetgroupname LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar">)
				ORDER BY assetgroupname, name
			</cfquery>
		</cfif>
		
		<cfreturn sg>

	</cffunction>


	<cffunction name="getGroupTypes" output="false">

		<cfset var sg = "">
		
		<!---<cfif variables.userobj.issuper()>--->
			<!--- superuser can see all assets in all asset groups --->
			<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
				SELECT id, name
				FROM assetGroups_view
				ORDER BY name
			</cfquery>
		<!---<cfelse>
			<!--- user can see only assets in asset groups in their content groups --->
			<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
				SELECT 
					assetgroupid AS id, assetgroupname AS name
				FROM assetGroupsInContentGroupUsers_join
				WHERE userid = <cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar"> 
				ORDER BY name
			</cfquery>
		</cfif>--->
		
		<cfreturn sg>
	</cffunction>

</cfcomponent>
	