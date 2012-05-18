<cfcomponent name="model" output="false" extends="resources.forms">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		<cfset super.init(request = arguments.request,userobj=arguments.userobj)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="deleteForm" output="false">
		<cfargument name="id" required="true">
		
		<cfset load(arguments.id)>
		<cfset variables.observeEvent('delete form', variables.itemData)>
		
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			DELETE forms 
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>

	</cffunction>
	
	<cffunction name="getField">
		<cfargument name="fieldname">
		
		<cfif not structkeyexists(variables.itemdata, fieldname)>
			<cfthrow message="field '#arguments.fieldname#' was not found">	
		</cfif>
		<cfreturn variables.itemdata[fieldname]>
		
	</cffunction>
	
	<cffunction name="getForm" output="false">
		<cfargument name="id" required="true">
		<cfset var sg = "">
	
		<cfquery name="sg" datasource="#variables.request.getvar('dsn')#" result="myre">
			SELECT id, name, created, modified, changedby, active, recipient, definition, reply
			FROM forms_view
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif sg.recordcount and trim(sg.definition) eq "">
			<cfset sg.definition = "<ul id=""palette""></ul>">
		</cfif>
		
		<cfreturn sg/>
	</cffunction>
	
	<cffunction name="getForms" output="false">
		<cfset var sg = "">
	
		<cfquery name="sg" datasource="#variables.request.getvar('dsn')#"><!--- --, definition --->
			SELECT id, name, created, modified, changedby, active 
			FROM forms_view
			WHERE siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
			ORDER BY name
		</cfquery>
		
		<cfreturn sg/>
	</cffunction>
	
	<cffunction name="insertForm" output="false">
		<cfset var grp = "">
		<cfset var siteinfo = application.sites.getSite(session.user.getCurrentSiteId())>
		
		<cfset id = createuuid()>
		<cfset variables.itemdata.id = id>
		
		<!--- update the item record --->
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			INSERT INTO forms ( 
				id, name, created, modified, changedby, active, siteid, recipient, reply
			)VALUES (
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar" maxlength="35">,
				<cfqueryparam value="#variables.itemdata.name#" cfsqltype="cf_sql_varchar" maxlength="50">,
				<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar" maxlength="35">,
				<cfqueryparam value="#variables.itemdata.active#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#variables.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar" maxlength="35">,
				<cfqueryparam value="#variables.itemdata.recipient#" cfsqltype="cf_sql_varchar" maxlength="255">,
				<cfqueryparam value="#variables.itemdata.reply#" cfsqltype="cf_sql_varchar" maxlength="3000">
			)			
		</cfquery> 
		
		<cfreturn id/>
	</cffunction>
	
	<cffunction name="load" output="false">
		<cfargument name="id" required="true">
		<cfset var sg = "">
		<cfset var itm = "">
	
		<cfset sg = getForm(id = arguments.id)>		
	
		<cfparam name="variables.itemdata" default="#structnew()#">
		
		<cfloop list="#sg.columnlist#" index="itm">
			<cfset variables.itemdata[itm] = sg[itm][1]>
		</cfloop> 
		
		<!--- <cfif trim(variables.itemdata.definition) eq "">
			<cfset variables.itemdata.definition = "<ul id=""palette""></ul>">
		</cfif> --->
		<cfset variables.itemdata.id = arguments.id>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="save">
		<cfset var id = "">

		<cfif variables.itemData.id EQ 0 or variables.itemData.id EQ ''>
			<cfset id = insertForm()>
			<cfset variables.observeEvent('insert form', variables.itemData)>
		<cfelse>
			<cfset id = updateForm()>
			<cfset variables.observeEvent('update form', variables.itemData)>
		</cfif>
		<cfreturn id>
	</cffunction>
	
	<cffunction name="saveFormWizard">
		
		<cfset variables.observeEvent('modify form content', variables.itemData)>
		
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			UPDATE forms SET 
				modified = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">, 
				definition = <cfqueryparam value="#variables.itemdata.definition#" cfsqltype="cf_sql_longvarchar">
			WHERE 
				id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfreturn variables.itemdata.id>
	</cffunction>
	
	<cffunction name="search" output="false">
		<cfargument name="criteria" required="true">
		<cfset var g = "">
		
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			SELECT id, name, fullname, modified 
			FROM forms_view
			WHERE 
			name LIKE <cfqueryparam value="%#arguments.criteria#%" cfsqltype="cf_sql_varchar"> 
			AND siteid = <cfqueryparam value="#variables.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfreturn g>

	</cffunction>
	
	<cffunction name="setvalues">
		<cfargument name="itemdata">
	
		<cfset variables.itemdata = arguments.itemdata>
		
		<cfif not StructKeyExists(variables.itemdata,'active')>
			<cfset variables.itemdata.active = 0>
		</cfif>
		
	</cffunction>
	
	<cffunction name="updateForm" output="false">
		
		<cfquery name="grp" datasource="#variables.request.getvar('dsn')#">
			UPDATE forms SET 
				name = <cfqueryparam value="#variables.itemdata.name#" cfsqltype="cf_sql_varchar" maxlength="50">,
				modified = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">, 
				changedby = <cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar" maxlength="35">,
				recipient = <cfqueryparam value="#variables.itemdata.recipient#" cfsqltype="cf_sql_varchar" maxlength="255">,
				reply = <cfqueryparam value="#variables.itemdata.reply#" cfsqltype="cf_sql_varchar" maxlength="3000"> 
			WHERE 
				id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfreturn variables.itemdata.id>
	</cffunction>
	
	<cffunction name="validate">		
		<cfset var lcl = structnew()>
		<cfset var requestvars = variables.itemData>
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var mylocal = structnew()>
			
		<cfset vdtr.notblank('name', requestvars.name, 'The Form Name is required.')>
		<cfset vdtr.notblank('recipient', requestvars.recipient, 'The Form Recipient is required.')>
		<cfset vdtr.validemail('recipient', requestvars.recipient, 'The Form Recipient must be a valid email.')>
		<cfset vdtr.notblank('reply', requestvars.reply, 'A Form Reply is required.')>
		
		<!-- check form name is not duplicated -->
		<cfset mylocal.allForms = getForms()>
		<cfloop query="mylocal.allForms">
			<cfif mylocal.allForms.name EQ requestvars.name AND mylocal.allForms.id NEQ requestvars.id>
				<cfset vdtr.addError('name','This Form Name is already in use. Please choose another.')>
				<cfbreak>
			</cfif> 
		</cfloop>
		
		
		<cfset vdtr.maxlength('name', 50, requestvars.name, 'Form Name should not exceed 50 characters ')>
		<cfset vdtr.maxlength('recipient', 255, requestvars.recipient, 'Form Recipient should not exceed 255 characters ')>
		<cfset vdtr.maxlength('reply', 3000, requestvars.reply, 'Form Submission Reply should not exceed 3000 characters ')>
	
		<cfreturn vdtr/>
	</cffunction>


	<cffunction name="validateDelete" output="false">
		<cfargument name="id" required="true">
		
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var me = "">		
		<cfset var page = "">		
		
		<!--- verify the form is not included on a page --->		
		<cfquery name="me" datasource="#variables.request.getvar('dsn')#">
			SELECT DISTINCT spv.pagename 
			FROM pageObjects_view pov, sitepages_view spv
			WHERE pov.module = 'Forms'
			AND spv.id = pov.pageid
			AND pov.data like <cfqueryparam value="%#arguments.id#%" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif me.recordcount>
			<cfset vdtr.addError('id', 'This form is included on page "#me.pagename#". Please remove it from there before deleting the form.')>
		</cfif>

		<cfreturn vdtr>
	</cffunction>
	
	<cffunction name="validateFormWizard">		
		<cfset var lcl = structnew()>
		<cfset var requestvars = variables.itemData>
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var mylocal = structnew()>
	
		<cfreturn vdtr/>
	</cffunction>
	
</cfcomponent>
	