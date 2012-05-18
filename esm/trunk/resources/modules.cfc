<cfcomponent name="modules">
	<!--- COMMENT: 
			I manage all of the templates for each module and action including discovering from xml
			I dispatch events by packaging the required templates into a display Object
	--->
	<cffunction name="init">
		<cfset var dirinfo = "">
		<cfset var filepath = GetDirectoryFromPath(GetCurrentTemplatePath())>
		<cfset var dirs = "">
		<cfset var modulexml = "">
		
		<cfset filepath = rereplace(filepath, "resources.$", "")>
		<cfset dirs = createObject('component', 'utilities.fileSystem').getDirectoryListing(filepath)>

		<cfset variables.mymodules = structnew()>
		<cfset variables.securityObj = "">
		<cfset variables.menuObj = "">

		<cfloop query="dirs">
			<cfif dirs.type EQ "dir" AND fileexists(filepath & dirs.name & "/modulexml.cfm")>
					<cfset modulexml = "">
					<cfinclude template="../#dirs.name#/modulexml.cfm">
					<cfset addmodule(modulexml, dirs.name)>
			</cfif>
		</cfloop>

		<cfset variables.menuObj = createObject('component','resources.menusystem').init(variables.mymodules)>

		<cfreturn this/>
	</cffunction>
	<!--->
	<cffunction name="getModuleDirectories">
		<cfset var dirstoignore = 'Resources,..,.'>
		<cfset var dirs = createObject('component', 'utilities.fileSystem').getDirectoryListing(GetDirectoryFromPath(GetCurrentTemplatePath()))>
		<cfset var newdirs = querynew('dirname')>
		<cfloop query="dirs">
			<cfif not listfind(dirstoignore,dirs.name) AND dirs.type EQ 'DIR'>
				<cfset queryaddrow(newdirs)>
				<cfset querysetcell(newdirs,'dirname',dirs.name)>
			</cfif>
		</cfloop>
		<cfreturn newdirs/>
	</cffunction>
	--->
			
	<cffunction name="dispatchEvent">
		<cfargument name="requestObj">
		<cfargument name="userObj">
		<cfset var module = requestObj.getModuleFromPath()>
		<cfset var action = requestObj.getActionFromPath()>
		
		<cfset var displayObj = "">
		<cfset var templateitem = "">
		<cfset var controller = "">
		<cfset var i = 0>
		<cfset var j = 0>

		<!--- check to make sure that this request is valid in light of the items already in the modules system --->
		<cfif not structkeyexists(variables.mymodules, module)>
			<cflocation url="/login/loginForm/?1" addtoken="no">
		</cfif>
		
		<cfif not structkeyexists(variables.mymodules[module].actions, action)>
			<cflocation url="/login/loginForm/?msg=action '#action#' not set in module '#module#'" addtoken="no">
		</cfif>
		
		<cfif NOT userObj.isloggedin() AND 
				NOT (module EQ 'login' AND (action EQ 'loginform' OR action EQ 'checklogin') ) >
			<cfif requestObj.isformurlvarset('ajax')>
				<cfset userobj.relogin('atchecklogin #module# #action#','ajax')>
			<cfelse>
				<cfset userobj.relogin('atchecklogin #module# #action#')>
			</cfif>
		</cfif>
		
		<!--- check user is allowed to see this module
		<cfif NOT userObj.isAllowed(module,'view')>
			<cfset userObj.relogin()>
		</cfif> --->
		
		<!--- create the display object, pack it with template requirements --->
		<cfset displayObj = createobject('component', 'resources.displayobject').init(arguments.requestObj)>
		<cfset displayObj.addTopTemplate(variables.mymodules[module].actions[action].Template)>
		<cfset displayObj.setSecurityObject(userObj)>
		<cfset displayObj.setTitle(variables.mymodules[module].label & ' : ' & variables.mymodules[module].actions[action].name)>
		<cfset displayObj.setMenuObject(variables.menuObj)>
		<cfset displayObj.setFormSubmit(variables.mymodules[module].actions[action].formsubmit)>
		<cfif structkeyexists(variables.mymodules[module].actions[action],'templates') AND arraylen(variables.mymodules[module].actions[action].templates)>
			<cfloop from="1" to="#arraylen(variables.mymodules[module].actions[action].templates)#" index="templateitem">
				<cfset displayObj.addTemplate(name = variables.mymodules[module].actions[action].templates[templateitem].name,
													title = variables.mymodules[module].actions[action].templates[templateitem].title,
														file = variables.mymodules[module].actions[action].templates[templateitem].file)>
			</cfloop>
		</cfif>

		<!--- dispatch the event to the module controller --->
		<cfinvoke component="#module#.controller" method="#action#" returnvariable="controller">
			<cfinvokeargument name="displayObject" value="#displayObj#">
			<cfinvokeargument name="requestObject" value="#requestObj#">
			<cfinvokeargument name="userObj" value="#userObj#">
			<cfinvokeargument name="dispatcher" value="#this#">
		</cfinvoke>
		
		<cfreturn controller>
	</cffunction>
	
	<cffunction name="callExternalModuleMethod">
		<cfargument name="module" required="true">
		<cfargument name="method" required="true">
		<cfargument name="requestObj" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="addtlparams" required="false">
		
		<cfset var something = "">
			
		<cfinvoke component="#module#.controller" method="#method#" returnvariable="something">
			<cfinvokeargument name="requestObject" value="#requestObj#">
			<cfinvokeargument name="securityObject" value="#session.user.security#">
			<cfinvokeargument name="userobj" value="#arguments.userobj#">
			<cfif structkeyexists(arguments,'addtlparams')>
				<cfinvokeargument name="addtlparams" value="#arguments.addtlparams#">
			</cfif>
		</cfinvoke>
		
		<cfreturn something/>
	</cffunction>
	
	<cffunction name="getSecurityItems" output="true">
		<cfset var itms = arraynew(1)>
		<cfset var itm = "">
		<cfset var cntr = 1>

		<cfloop collection="#variables.mymodules#" item="itm">
			<cfset itms[cntr] = structnew()>
			<cfset itms[cntr].name = variables.mymodules[itm].name>
			<cfset itms[cntr].securityItems = variables.mymodules[itm].securityItems>
			<cfset itms[cntr].label = variables.mymodules[itm].label>
			<cfset cntr = cntr + 1>
		</cfloop>

		<cfreturn itms>
	</cffunction>
	
	<cffunction name="setState">
		<cfargument name="state">
		<cfset variables.state = arguments.state>
	</cffunction>
	
	<cffunction name="getState">
		<cfreturn variables.state>
	</cffunction>
	
	<cffunction name="getPersistence">
		<cfreturn variables.state>
	</cffunction>
			
	<cffunction name="addmodule">
		<cfargument name="moduleXml" required="true">
		<cfargument name="foldername" required="true">
		
		<cfset var moduleinfo = structnew()>
		<cfset var actions = "">
		<cfset var i = "">
		<cfset var thisaction = "">
		<cfset var thisactioninfo = structnew()>
		<cfset var templates = arraynew(1)>
		<cfset var template = "">
		<cfset var templateinfo = structnew()>
		
		<cfset moduleinfo.name = arguments.modulexml.module.xmlattributes.name>
		<cfset moduleinfo.label = arguments.modulexml.module.xmlattributes.label>
		<cfset moduleinfo.menuorder = arguments.modulexml.module.xmlattributes.menuorder>
		<cfset moduleinfo.securityItems = arguments.modulexml.module.xmlattributes.securityitems>
		<cfset moduleinfo.folderName = arguments.foldername>
        
        <cfif isdefined("arguments.modulexml.module.xmlattributes.topnav") AND arguments.modulexml.module.xmlattributes.topnav>
            <cfset moduleinfo.topmenunav = 1>
        <cfelse>
        	<cfset moduleinfo.topmenunav = 0>
        </cfif>

		<cfset actions = xmlsearch(arguments.modulexml, '//module/action/')>
		<cfset moduleinfo.actionsarray = arraynew(1)>
		
		<cfloop from="1" to="#arraylen(actions)#" index="i">
			<cfset thisaction = actions[i]>
			<cfset thisactioninfo = structnew()>

			<cfif structkeyexists(thisaction.xmlattributes, "template")>
				<cfset thisactioninfo.template = thisaction.xmlattributes.template>
			<cfelse>
				<cfset thisactioninfo.template = ''>
			</cfif>
			
			<cfif structkeyexists(thisaction.xmlattributes, "name")>
				<cfset thisactioninfo.name = thisaction.xmlattributes.name>
			</cfif>
			
			<cfif structkeyexists(thisaction.xmlattributes, "method")>
				<cfset thisactioninfo.method = thisaction.xmlattributes.method>
			<cfelse>
				<cfset thisactioninfo.method = rereplace(thisaction.xmlattributes.name,"[^a-zA-Z0-9]","","all")>
			</cfif>

			<cfif structkeyexists(thisaction.xmlattributes, "onsuccess")>
				<cfset thisactioninfo.onsuccess = thisaction.xmlattributes.onsuccess>
			</cfif>

			<cfif structkeyexists(thisaction.xmlattributes, 'formsubmit')>
				<cfset thisactioninfo.formsubmit = thisaction.xmlattributes.formsubmit>
			<cfelse>
				<cfset thisactioninfo.formsubmit = "">
			</cfif>

			<!--->
			<cfif structkeyexists(thisaction.xmlattributes, 'issecurityitem') AND thisaction.xmlattributes.issecurityitem>
				<cfset thisactioninfo.issecurityitem = 1>
			<cfelse>
				<cfset thisactioninfo.issecurityitem = 0>
			</cfif>
			--->

			<cfif structkeyexists(thisaction.xmlattributes, 'onmenu') AND thisaction.xmlattributes.onmenu>
				<cfset thisactioninfo.onmenu = 1>
			<cfelse>
				<cfset thisactioninfo.onmenu = 0>
			</cfif>

			<cfset templates = arraynew(1)>

			<cfif arraylen(thisaction.xmlchildren)>
				
				<cfloop from="1" to="#arraylen(thisaction.xmlchildren)#" index="j">
					<cfset template = thisaction.xmlchildren[j]>
					<cfset templateinfo = structnew()>
					<cfset templateinfo.file = template.xmlattributes.file>
					<cfset templateinfo.name = template.xmlattributes.name>
					<cfset templateinfo.title = template.xmlattributes.title>
					<cfset arrayappend(templates, templateinfo)>
				</cfloop>
				
				<cfset thisactioninfo.templates = templates>
			</cfif>
			<cfset arrayappend(moduleinfo.actionsarray, thisactioninfo)>
			<cfset moduleinfo.actions[thisactioninfo.method] = thisactioninfo>
		</cfloop>

		<cfset variables.mymodules[name] = moduleinfo>
	</cffunction>
</cfcomponent>