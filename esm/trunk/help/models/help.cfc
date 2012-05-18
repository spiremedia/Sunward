<cfcomponent name="Help MOdel" output="false" extends="resources.abstractModel">
	<cffunction name="init">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.userObject = arguments.userObject>
		<cfset variables.helpDocsFolder = requestObject.getVar('machineroot') & 'help/docs/'>
		<cfset variables.itemdata = structnew()>
		<cfreturn this>
	</cffunction>
		
	
	<cffunction name="load" output="false">
		<cfargument name="m" required="true">
	
		<cfset var contents = "">
		<cfset var file = "">
		<cfset file = variables.helpDocsFolder 
					& rereplace(m,"[^a-z0-9A-Z]", "_","all")
					& ".html">
		<cfif fileexists(file)>
			<cffile action="read" file="#file#" variable="contents">
			<cfset variables.itemdata.new = 0>
		<cfelse>
			<cffile action="read" file="#variables.helpDocsFolder#default.html" variable="contents">
			<cfset variables.itemdata.new = 1>			
		</cfif>
		
		<cfset variables.itemdata.contents = contents>
		<cfset variables.itemdata.module = m>
		
	</cffunction>
		
	<cffunction name="getHelpItems" output="false">
		<cfset var files = "">
		<cfset var i = structnew()>
		<cfdirectory action="list" name="files" directory="#variables.helpDocsFolder#">

		<cfquery dbtype="query" name="files">
			SELECT * FROM files 
			WHERE name <> 'default.html'
            	AND name <> '.svn'
			ORDER BY name
		</cfquery>
		
		<cfset i.module = arraynew(1)>
		
		<cfloop query="files">
			<cfset arrayappend(i.module,replace(name,".html","","all"))>
		</cfloop>
		
		<cfset queryaddcolumn(files, "module", i.module)>
				
		<cfreturn files/>
	</cffunction>
	
	<cffunction name="search" output="false">
		<cfargument name="search">
		<cfargument name="field">
	
		<cfset var srch = "">
		<cfset var searchlist = "name, title">
		
		<cfreturn srch/>
	</cffunction>
	
	<cffunction name="setvalues">
		<cfargument name="itemdata">
		<cfset variables.itemdata = arguments.itemdata>
	</cffunction>
	
	<cffunction name="setvalue">
		<cfargument name="name">
		<cfargument name="val">
		<cfset variables.itemdata[name] = trim(val)>
	</cffunction>
	
	<cffunction name="getVar" output="false">
		<cfargument name="name">
		
		<cfif not structkeyexists(variables.itemdata, name)>
			<cfthrow message="var #name# not in itemdata">
		</cfif>
		
		<cfreturn variables.itemdata[name]>
	</cffunction>
	
	<cffunction name="validate">		
		
		<cfset var lcl = structnew()>
		<cfset var requestvars = variables.itemData>
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var mylocal = structnew()>
		
		<!--- <cfset vdtr.notblank('title', requestvars.title, 'The Title is required.')> --->
		<cfset vdtr.notblank('html', requestvars.contents, 'Some Content is required.')>
				
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var file = variables.helpDocsFolder 
					& rereplace(itemdata.module,"[^a-z0-9A-Z]", "_","all")
					& ".html">
		<cfset var contents = replacenocase(variables.itemdata.contents, requestObject.getVar('esmurl'), "/", "all")>
		<cffile action="write" file="#file#" output="#contents#" mode="644">
	</cffunction>
	
	<cffunction name="deleteHelpItem" output="false">
		<cfargument name="m" required="true">
		<cfargument name="a" required="true">
		
		<cfset var file = variables.helpDocsFolder 
					& rereplace(m,"[^a-z0-9A-Z]", "","all")
					& ".html">
		<cffile action="delete" file="#file#">
	</cffunction>
	
</cfcomponent>