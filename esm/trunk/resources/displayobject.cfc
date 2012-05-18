<cfcomponent name="displayobject" output="false">
	<!--- COMMENT: I accept the required templates, accept html snippets, and render them.--->
	<cffunction name="init">
		<cfargument name="requestObj" required="true">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.templates = structnew()><!--- a structure of arrays that contains info about teach template described in the modulexml --->
		<cfset variables.htmlitems = structnew()><!--- a structure of rendered html. Gets creatd when rendertemplate is called --->
		<cfset variables.datas = structnew()><!--- data items that are made available to templates by the controller for processing by --->
		<cfset variables.reselected = structnew()><!--- templates can relselect which widget item is selected. Reselected items are stored here --->
		<cfset variables.pagetitle = "ESM">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setsecurityobject" output="false">
		<cfargument name="securityObj">
		<cfset variables.securityObj = arguments.securityObj>
	</cffunction>
	
	<cffunction name="setmenuobject" output="false">
		<cfargument name="menuObj">
		<cfset variables.menuObj = arguments.menuObj>
	</cffunction>
	
	<cffunction name="getmenuobject" output="false">
		<cfreturn variables.menuObj/>
	</cffunction>
	
	<cffunction name="getmainMenuHtml" output="false">
		<cfargument name="level" default="top">
		<cfreturn variables.menuObj.getMainMenuHtml(variables.securityObj, variables.requestObj, arguments.level)>
	</cffunction>
	
	<cffunction name="getSubMenuHtml" output="false">
		<cfreturn variables.menuObj.getSubMenuHtml(variables.securityObj, variables.requestObj)>
	</cffunction>
	
	<cffunction name="addTemplate" output="false">
		<cfargument name="name">
		<cfargument name="title">
		<cfargument name="file">
		
		<cfset var template = structnew()>
		
		<cfif not structkeyexists(variables.templates, name)>
			<cfset variables.templates[name] = arraynew(1)>
		</cfif>
		
		<cfset template.title = arguments.title>
		<cfset template.file = arguments.file>
		
		<cfset arrayappend(variables.templates[arguments.name], template)>
	</cffunction>
	
	<cffunction name="renderTemplate" output="false">
		<cfargument name="name">
		<cfargument name="templatelist"><!--- use this var to override templates set in xml --->
		<cfset var html = "">
		<cfset var tr = "">
		<cfset var tplt = "">
		<cfset var newselected = "">
		
		<cfif NOT structkeyexists(variables.templates, name)>
			<cfthrow message="You are attempting to render template '#arguments.name#' which is not declared in the modulexml file">
		</cfif>

		<cfif isdefined("arguments.templatelist") AND listlen(arguments.templatelist) NEQ arraylen(variables.templates[arguments.name])>
			<cfthrow message="Rendering #name#. If you pass templatelist, it must contain as many templates as set in the xml. Currently xml has #arraylen(variables.templates[arguments.name])# templates and templatelist = '#arguments.templatelist#'.">
		</cfif>

	
		<cfloop from="1" to="#arraylen(variables.templates[arguments.name])#" index="tplt">
			<cfset tr = createObject('component', 'resources.templaterunner').init()>
			<cfif isdefined("arguments.templatelist")>
				<cfset tr.setTemplate( variables.requestObj.getModuleFromPath() & '/templates/' & listgetat(arguments.templatelist, tplt) )>
			<cfelse>	
				<cfset tr.setTemplate( variables.requestObj.getModuleFromPath() & '/templates/' & variables.templates[name][tplt].file )>
			</cfif>
			<cfset tr.setData( variables.getTemplateDatas() )>
			<cfset tr.setSecurity( variables.securityObj )>
			<cfset tr.setrequestObj( variables.requestObj )>
			<cfset sethtmlobj( name, tr.getHTML() )>
			<cfset newselected = tr.getSelected()><!--- temlate can change which item is selected if it wants to --->
			<cfif newselected>
				<cfset setWidgetOpen(name,newselected)>
			</cfif>
		</cfloop>
	</cffunction>
		
	<cffunction name="setData" output="false">
		<cfargument name="name">
		<cfargument name="data">
		<cfset variables.datas[name] = data>
	</cffunction>	
	
	<cffunction name="setWidgetOpen" output="false">
		<cfargument name="name">
		<cfargument name="panes">
		
		<cfset variables.reselected[name] = panes>
	</cffunction>
	
	<cffunction name="setFormSubmit" output="false">
		<cfargument name="isfs" required="true">
		<cfset variables.formsubmit = arguments.isfs>
	</cffunction>
	
	<cffunction name="setSuccess" output="false">
		<cfargument name="s" required="true">
		<cfset variables.onSuccess = arguments.s>
	</cffunction>
	
	<cffunction name="setTitle" output="false">
		<cfargument name="s" required="true">
		<cfset variables.pagetitle = variables.pagetitle & " : " & arguments.s>
	</cffunction>
	
	<cffunction name="getTitle" output="false">
		<cfreturn variables.pagetitle>
	</cffunction>
	
	<cffunction name="onSuccess" output="false">
		<cfset sendjson('location', "/#requestObj.getModuleFromPath()#/#variables.onsuccess#/")>
	</cffunction>
	
	<cffunction name="showHTML">
		<cfargument name="html" required="false">
	
		<cfif structkeyexists(arguments,'html')>
			<cfcontent reset="true"><cfoutput>#arguments.html#</cfoutput><cfabort>		
		</cfif>
		
		<!--- This funciton is used to outpout the results of a single rendereed template. Make sure its a single rendered template --->
		<cfif structisempty(variables.htmlitems) AND listlen(structkeylist(variables.htmlitems)) NEQ 1>
			<cfthrow message ="if no html is sent to showhtml, then one and only one item must be set as a template and have been rendered">
		</cfif>
		
		<cfif arraylen(variables.htmlitems[structkeylist(variables.htmlitems)]) NEQ 1>
			<cfthrow message ="if no html is sent to showhtml, then one and only one item must be set as a template and have been rendered">
		</cfif>
		
		<cfcontent reset="true"><cfoutput>#variables.htmlitems[structkeylist(variables.htmlitems)][1]#</cfoutput><cfabort>		
		
	</cffunction>
	
	<cffunction name="sendJson" output="false">
		<cfargument name="data">
		
		<cfset var s = structnew()>
		<cfset var jo = createObject('component','utilities.json')>
		<cfsetting showdebugoutput="false">
		<cfset showHTML( jo.encode(data) )>
	</cffunction>
	
	<cffunction name="sendXLS" output="false">
		<cfargument name="data">
		<cfargument name="altColumnList" required="no">
		
		<cfset var headers = data.columnlist>
		<cfset var itm = "">
		<cfset var lines = arraynew(1)>
		<cfset var line = ''>
		
		<cfif isDefined("arguments.altColumnList")>
			<cfset headers = arguments.altColumnList>
		</cfif>

		<cfset arrayappend(lines, replace(headers,",","#chr(9)#","all")) >
		<cfoutput query="data">
			<cfset line = arraynew(1)>
			<cfloop list="#headers#" index="itm">
				<cfset arrayappend(line, trim(data[itm][data.currentrow]))>
			</cfloop>
			<cfset arrayappend(lines, arraytolist(line, "#chr(9)#"))>
		</cfoutput>

<cfcontent reset="true" type="application/msexcel"><cfoutput>#arraytolist(lines,"#chr(13)##chr(10)#")#</cfoutput><cfabort>
	</cffunction>
	
	<cffunction name="sendXML" output="false">
		<cfargument name="xml">

<cfcontent reset="true" type="application/xml"><cfoutput>#toString(arguments.xml)#</cfoutput><cfabort>
	</cffunction>
	
	<cffunction name="isFormSubmit" output="false">
		<cfreturn (structkeyexists(variables, 'formsubmit') AND len(variables.formsubmit))>
	</cffunction>
	
	<cffunction name="getFormSubmit" output="false">
		<cfreturn variables.formsubmit>
	</cffunction>
	
	<cffunction name="getData" output="false">
		<cfargument name="name">
		<cfif not structkeyexists(variables.datas, name)>
			<cfthrow message="data #name# has not been set">
		</cfif>
		<cfreturn variables.datas[name]/>
	</cffunction>
	
	<cffunction name="getTemplateDatas" output="false">
		<cfreturn variables.datas/>
	</cffunction>
	
	<cffunction name="getEsmUrl" output="false">
		<cfreturn variables.requestObj.getvar('esmurl')/>
	</cffunction>
	
	<cffunction name="setHtmlObj">
		<cfargument name="name" required="true">
		<cfargument name="html" required="true">
		
		<cfif not structkeyexists(variables.htmlitems, name)>
			<cfset variables.htmlitems[name] = arraynew(1)>
		</cfif>
		
		<cfset arrayappend(variables.htmlitems[name], html)>
	</cffunction>
	
	<cffunction name="addTopTemplate">
		<cfargument name="toptemplate">
		<cfset variables.toptemplate = arguments.toptemplate>
	</cffunction>
	
	<cffunction name="getTopTemplate">
		<cfreturn variables.toptemplate>
	</cffunction>
	
	<cffunction name="renderItem" output="false">
		<cfargument name="name" required="true">
		<cfargument name="type" default="accordion">
		
		<cfset var htmlwidget = "">
		<cfset var htmlObj = "">
		<cfset var storedItems = ''>
		<cfset var i = ''>
		<cfset title = "">
		
		<cfif not structkeyexists(variables.htmlitems,name)>
			<cfthrow message="Html item '#name#' is not set for processing. Please fix in model.">
		</cfif>
			
		<cfset storeditems = variables.htmlitems[name]>
		
		<cfset htmlwidget = createObject('component', 'widgets.#arguments.type#').init(id=arguments.name)>
	
		<cfif structkeyexists(variables.reselected,name)>
			<cfset htmlwidget.setselected(variables.reselected[name])>
		</cfif>
		
		<cfloop from="1" to="#arraylen(storeditems)#" index="htmlObjcntr">
			<cfset title = variables.templates[name][htmlObjcntr].title>
			<cfset htmlwidget.add(title, storeditems[htmlObjcntr])>
		</cfloop>
	
		<cfreturn htmlwidget.showHtml()>		
	</cffunction>
	
	<cffunction name="process">
		<cfinclude template="../templates/#gettoptemplate()#.cfm">
	</cffunction>
	
	<cffunction name="relocate">
		<cfargument name="loc">
		<cflocation url="#arguments.loc#" addtoken="no">
	</cffunction>
	
</cfcomponent>