<cfcomponent name="image gallery model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		
		<cfset variables.gallerydirectoryname = "imagegalleries">
		<cfset variables.gallerydirectorypath = variables.request.getVar("machineroot") &  'docs/' & gallerydirectoryname & '/'>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getImages" output="false">
		<cfset var sg = "">

			<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
				SELECT 
					id, 
					title,
					galleryname,
					name,
					filename, 
					description, 
					changeddate, 
					changedby, 
					active,
					sortdate
				FROM galleryImages_view
				ORDER BY galleryname, sortdate
			</cfquery>
		
		<cfreturn sg/>
	</cffunction>
	
	<cffunction name="getClientModuleImages" output="false">
		<cfset var sg = "">
	
		
			<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
				SELECT 
					imageid AS id, imagename + ' (in ' + gallerygroupname + ')' AS name
				FROM imagesInGalleryGroup_join
				ORDER BY gallerygroupname, name
			</cfquery>
	
		
		<cfreturn sg/>
	</cffunction>
	
	<cffunction name="load" output="false">
		<cfargument name="id" required="true">
		<cfset var sg = "">
		<cfset var itm = "">
	
		<cfquery name="sg" datasource="#variables.request.getvar('dsn')#" result="myre">
			SELECT 
				id, title, sortdate, name, filename, description, changeddate, changedby, active
			FROM galleryimages_view
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
	
		<cfparam name="variables.itemdata" default="#structnew()#">
		
		<cfloop list="#sg.columnlist#" index="itm">
			<cfset variables.itemdata[itm] = sg[itm][1]>
		</cfloop> 
		
		<cfquery name="sg" datasource="#variables.request.getvar('dsn')#" result="myre">
			SELECT 
				id, galleryGroupId
			FROM galleryImagesToGroup
			WHERE galleryimageid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset variables.itemdata.gallerygroupids = valuelist(sg.galleryGroupId)>
		<cfset variables.itemdata.id = arguments.id>
   
		<cfreturn sg.recordcount>
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
			
		<cfset vdtr.notblank('name', requestvars.name, 'The Image Name is required.')>
		<cfset vdtr.isvaliddate('sortdate', requestvars.sortdate, 'The Sort Date is required.')>
		<cfset vdtr.notblank('gallerygroupids', requestvars.gallerygroupids, 'The Group is required.')>
		<cfset vdtr.notblank('title', requestvars.title, 'A Title is required.')>
		<cfset vdtr.maxlength('title', 255, requestvars.title, 'The Title is too long - currently #len(requestvars.description)#.  Max is 255chars.')>

		<cfset vdtr.notblank('description', requestvars.description, 'A Description for the search results is required.')>
		<cfset vdtr.maxlength('description', 3000, requestvars.description, 'The Description is too long - currently #len(requestvars.description)#.  Max is 3000chars.')>

	
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var id = "">
		
		<cfif variables.itemData.id EQ "0">
			<cfset id = insertImage()>
		<cfelse>
			<cfset id = updateImage()>
		</cfif>
		<cfreturn id>
	</cffunction>
	
	<cffunction name="insertImage" output="false">
		<cfset var grp = "">
		<cfset var mainfile = ''>
		<cfset var previewfile = ''>
		<!---
		<cfset mainfile = createObject('component','utilities.fileuploadandsave').init(target = 'galleries', sitepath = variables.request.getVar('machineroot'), file = 'filename')>
		
		<cfif NOT mainfile.success()>
			<cfthrow message="File not uploaded.">
		</cfif>
		--->
		
		<cfset id = createuuid()>
		<cfset variables.itemdata.id = id>
		
		<cfset variables.observeEvent('add', this)>
		
		<!--- update the item record --->
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			INSERT INTO galleryImages ( 
				id, 
				name, 
				title,
				changeddate, 
				changedby, 
				active, 
				description,
				sortdate
			)VALUES (
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.name#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.title#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.active#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#variables.itemdata.description#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.itemdata.sortdate#" cfsqltype="cf_sql_timestamp">
			)			
		</cfquery>
		
		<cfset updateImagetoGrouplinks(id, variables.itemdata.galleryGroupIds)>
		
		<cfreturn id/>
	</cffunction>
	
	<cffunction name="updateImagetoGrouplinks" output="false">
		<cfargument name="galleryimageid">
		<cfargument name="gallerygroupids">
		
		<cfset var lcl = structnew()>
				
		<cfquery name="lcl.del" datasource="#variables.request.getvar('dsn')#">
			DELETE FROM galleryImagesToGroup 
			WHERE 
				galleryImageId = <cfqueryparam value="#arguments.galleryimageid#" cfsqltype="cf_sql_varchar">
				AND siteid = <cfqueryparam value="#variables.userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfloop list="#arguments.galleryGroupids#" index="lcl.idx">
			<cfquery name="lcl.add" datasource="#variables.request.getvar('dsn')#">
				INSERT INTO galleryImagesToGroup (
					id,
					galleryGroupId,
					galleryImageId,
					siteid
				)VALUES (
					<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#lcl.idx#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.galleryimageid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#variables.userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
		</cfloop>
	</cffunction>
	
	
	<cffunction name="updateImage" output="false">
		<cfset var grp = "">
		<cfset var mainfilesize = "">
		<cfset var mainfile = ''>
		<cfset var previewfile = ''>
		<cfset var qryFile = "">
		<cfset var filetodelete = "">	
		<!---
		<cfif variables.itemdata.filename NEQ ''>
	
			<!--- retrieve the filename to delete, before uploading new file --->
			<cfquery name="qryFile" datasource="#variables.request.getvar('dsn')#">
				SELECT filename
				FROM galleryImages_view 
				WHERE id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfif qryFile.recordcount>
				<cfset filetodelete = qryFile.filename>
			</cfif>
		
			<cfset mainfile = createObject('component','utilities.fileuploadandsave').init(target = 'imagegalleries', sitepath = variables.request.getVar('machineroot'), file = 'filename', filetodelete = filetodelete)>
			
			<cfif NOT mainfile.success()>
				<cfthrow message="File not uploaded.">
			</cfif>
			
			<cfset mainfilesize = mainfile.filesize()>
			<cfset mainfile = mainfile.savedName()>
		</cfif>
		--->
		<cfset variables.observeEvent('edit', this)>
		
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			UPDATE galleryImages SET 
				name = <cfqueryparam value="#variables.itemdata.name#" cfsqltype="cf_sql_varchar">,
				title = <cfqueryparam value="#variables.itemdata.title#" cfsqltype="cf_sql_varchar">,
				sortdate = <cfqueryparam value="#variables.itemdata.sortdate#" cfsqltype="cf_sql_varchar">,
				changeddate = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">, 
				description = <cfqueryparam value="#variables.itemdata.description#" cfsqltype="cf_sql_varchar">,
				changedby = <cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar">
			WHERE 
				id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset updateImagetoGrouplinks(variables.itemdata.id, variables.itemdata.galleryGroupIds)>
		
		<cfreturn variables.itemdata.id>
	</cffunction>
	
	<cffunction name="uploadImageFileInfo" output="false">
		<cfargument name="info" required="true">
		<cfargument name="imgparams" required="true">
		<cfset var grp = "">
		<cfset var mainfilesize = "">
		<cfset var mainfile = ''>
		<cfset var previewfile = ''>
		<cfset var qryFile = "">
		<cfset var filetodelete = "">
		
		<cfset var uploaddirectory = variables.gallerydirectorypath & info.id>
		<cfif info.filename NEQ ''>

			<cfif variables.itemdata.filename NEQ "">
				<!--- clear out the old images --->
				<cfloop query="imgparams">
					<cfset filetodelete = "#uploaddirectory#/#rereplace(variables.itemdata.filename,"\.(png|jpg)$","#extensionmod#.\1")#">
					<cfif fileexists(filetodelete)>
						<cffile action="delete" file="#filetodelete#">
					</cfif>
				</cfloop>
				<cfset filetodelete = "#uploaddirectory#/#rereplace(variables.itemdata.filename,"\.(png|jpg)$","_orig.\1")#">
				<cfif fileexists(filetodelete)>
					<cffile action="delete" file="#filetodelete#">
				</cfif>
				<cfset filetodelete = "#uploaddirectory#/#variables.itemdata.filename#">
				<cfif fileexists(filetodelete)>
					<cffile action="delete" file="#filetodelete#">
				</cfif>
			</cfif>
			
			<cfif NOT directoryexists(uploaddirectory)>
				<cfdirectory action="create" directory="#uploaddirectory#" mode="664">
			</cfif>
			
			<cfset mainfile = createObject('component','utilities.fileuploadandsave').init(target = '#variables.gallerydirectoryname#/#info.id#', sitepath = variables.request.getVar('machineroot'), file = info.filename)>
			
			<cfif NOT mainfile.success()>
				<cfthrow message="File not uploaded.">
			</cfif>
			
			<cfset variables.itemdata.filename = mainfile.savedName()>
			
			<!--- duplicate it for reeuse in case main gets tweeked --->
			<cffile action="copy" source="#uploaddirectory#/#variables.itemdata.filename#"
							destination="#uploaddirectory#/#rereplace(variables.itemdata.filename,"\.(png|jpg)$","_orig.\1")#"
							mode="664">

		</cfif>
			
		<cfset variables.observeEvent('uploaded image', this)>
		
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			UPDATE galleryImages SET 
				filename = <cfqueryparam value="#variables.itemdata.filename#" cfsqltype="cf_sql_varchar">
			WHERE 
				id = <cfqueryparam value="#info.id#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfreturn variables.itemdata.filename>
	</cffunction>
	
	<cffunction name="resizeImage" output="false">
		<cfargument name="imgparams" required="true">
		<cfargument name="imgmanipulation" required="true">

		<cfset var filename = variables.gallerydirectorypath & "/" & variables.itemdata.id & "/" & variables.itemdata.filename>
		
		<cfif NOT fileexists(filename)>
			<cfthrow message="Image not found to resize ""#filename#""">
		</cfif>

		<cfloop query="imgparams">
			<cfset imgmanipulation.resizetomax(filename, maxwidth, maxheight, rereplace(filename, "\.(jpg|png)$", "#extensionmod#.\1", "all"))>
		</cfloop>
		
	</cffunction>

	<cffunction name="validateDelete" output="false">
		<cfargument name="id" required="true">
		
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var me = "">		
		<cfset var page = "">		
		
		<!--- verify the galleryImage is not included on a page --->		
		<cfquery name="me" datasource="#variables.request.getvar('dsn')#">
			SELECT DISTINCT spv.pagename 
			FROM pageObjects_view pov, sitepages_view spv
			WHERE (pov.module = 'Galleries' OR pov.module = 'HTMLContent')
			AND spv.id = pov.pageid
			AND pov.data like <cfqueryparam value="%#arguments.id#%" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif me.recordcount>
			<cfset vdtr.addError('gallerygroupid', 'This image is included on page "#me.pagename#". Please remove it from there before deleting the image.')>
		</cfif>

		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="deleteimage" output="false">
		<cfargument name="id" required="true">
		<cfset var fs = createObject('component','utilities.filesystem').init()>
		
		<cfset load(arguments.id)>

		<cfset variables.observeEvent('delete', this)>
		
        <cftry>
			<cfset fs.delete(variables.request.getVar('machineroot') & 'docs/galleryImages/' & variables.itemData.filename)>
        	<cfcatch>
            
            </cfcatch>
		</cftry>
        
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			DELETE FROM galleryImages 
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			DELETE FROM galleryImagesToGroup 
			WHERE galleryimageid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
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

		<cfreturn sg>

	</cffunction>


	<cffunction name="getGalleryGroupTypes" output="false">

		<cfset var sg = "">
		
		<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				gallerygroupid AS id, gallerygroupname AS name
			FROM galleryGroupsInContentGroupUsers_join
			WHERE userid = <cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar"> 
			ORDER BY sortdate
		</cfquery>
				
		<cfreturn sg>
	</cffunction>

</cfcomponent>
	