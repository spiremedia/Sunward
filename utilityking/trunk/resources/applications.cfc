<cfcomponent name="modules">
	<!--- COMMENT: 
			I manage all of the applications for each module and action including discovering from xml
		
	--->
	<cffunction name="init">
		<cfargument name="machineRoot">
		<cfset var dirinfo = "">
		<cfset var filepath = arguments.machineRoot & '/modules/'>
		<cfset var dirs = createObject('component', 'utilities.fileSystem').getDirectoryListing(filepath)>
		<cfset var modulexml = "">
		<cfset variables.mymodules = structnew()>
		<cfset variables.appactions = arraynew(1)>
        <cfset variables.postprocesses = arraynew(1)>
		
		<cfloop query="dirs">
			<cfset modulexml = "">
			<cfif fileexists( filepath & name & '/configxml.cfm' )>
				<cfinclude template="/modules/#name#/configxml.cfm">
				<cfif isXML( modulexml )>
					<cfset addapp(name, modulexml)>
				</cfif>
			</cfif>
		</cfloop>

		<cfreturn this/>
	</cffunction>

	<cffunction name="addapp">
		<cfargument name="name" required="true">
		<cfargument name="modulexml" required="true">
		<cfset var i = "">
		<cfset var ii = "">
		<cfset var info = structnew()>
		<cfset var evt = "">
        <cfset var prs = "">
		<cfset var act = "">
		<cfset var json = createobject('component','utilities.json').init()>
		<cfset var actions = xmlsearch(modulexml,"/moduleInfo/action")>
        <cfset var processes = xmlsearch(modulexml,"/moduleInfo/postProcess")>

		<cfloop from="1" to="#arraylen(actions)#" index="i">
			<cfset info = structnew()>
			<cfset evt = actions[i]>
			<cfset info.match = evt.xmlattributes.match>
			<cfset info.folder = name>
			
			<cfloop from="1" to="#arraylen(evt.xmlChildren)#" index = "ii">
				<cfset act = evt.xmlChildren[ii]>
				<cfset info[act.xmlName] = act.xmlText>
			</cfloop>
			
			<cfset info.loadcfc = 'modules.' & info.folder & '.' & info.loadcfc & 'page'>
			
			<cfset arrayappend(variables.appactions, info)>
		</cfloop>
        
        <cfloop from="1" to="#arraylen(processes)#" index="i">
			<cfset info = structnew()>
			<cfset prs = processes[i]>

			<cfset info.replaceString = prs.xmlattributes.replaceString>
			
			<cfloop list="#prs.xmlattributes.parameterList#" index="info.lcntr">
				<cfif find("=", info.lcntr)>
					<cfset info.parameterlist[gettoken(info.lcntr, 1, '=')] = gettoken(info.lcntr, 2, '=')>
				<cfelse>
					<cfset info.parameterlist[gettoken(info.lcntr, 1, '=')] = 1>
				</cfif>
			</cfloop>
            
			<cfset info.folder = name>
			
			<cfset arrayappend(variables.postprocesses, info)>
		</cfloop>

	</cffunction>
	
	<cffunction name="search">
		<cfargument name="path" required="true">
		<cfset var item = "">
		<cfset var i = ''>
		<cfloop from="1" to="#arraylen(variables.appactions)#" index="i">
			<cfif refindnocase(variables.appactions[i].match, path)>
				<cfreturn variables.appactions[i]>
			</cfif>
		</cfloop>
		<cfreturn structnew()>
	</cffunction>
    
    <cffunction name="getPostProcesses">
		<cfreturn variables.postprocesses>
	</cffunction>
</cfcomponent>