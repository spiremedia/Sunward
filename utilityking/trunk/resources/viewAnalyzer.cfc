<cfcomponent name="templateViews" output="false">
	<!--- 
		I am given a path in init and a foldername in load view. 
		I parse the view for functions called showcontentobject with a regex.  
		I parse these method call strings and return the important information in a query
	--->
	<cffunction name="init" output="false">	
		<cfargument name="filepath">
		<cfset variables.filepath = arguments.filepath>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="loadView" output="false">
		<cfargument name="view" required="true">
		<cfset var html = "">
		
		<cfset var lcl = structnew()>
		<cfset var re = "showContentObject\([''""]([^'""]+)[''""],[ ]?[''""]([^'""]+)[''""](,[ ]?[''""]([^'""]+)[''""])?\)">
		
		<cfset variables.viewinfo = querynew('name,modulename,parameterlist')>
		<cfset variables.pageinfo = structnew()>
		
		<cffile action="read" file="#variables.filepath##arguments.view#/index.cfm" variable="html">
		
		<cfset lcl.reresults = refindnocase(re, html, 0, true)>
        
		<cfloop condition="lcl.reresults.len[1] NEQ 0">
			<cfset lcl.label = mid(html,lcl.reresults.pos[2],lcl.reresults.len[2])>
			<cfset lcl.modulename = mid(html,lcl.reresults.pos[3],lcl.reresults.len[3])>
			<cfif lcl.reresults.len[5]>
				<cfset lcl.parameterlist = mid(html,lcl.reresults.pos[5],lcl.reresults.len[5])>
			<cfelse>
				<cfset lcl.parameterlist = "">
			</cfif>
			<cfset lcl.tempparameterlist = lcl.parameterlist>
			<cfset lcl.parameterlist = structnew()>
			
			<cfloop list="#lcl.tempparameterlist#" index="lcl.lcntr">
				<cfif find("=", lcl.lcntr)>
					<cfset lcl.parameterlist[gettoken(lcl.lcntr, 1, '=')] = gettoken(lcl.lcntr, 2, '=')>
				<cfelse>
					<cfset lcl.parameterlist[gettoken(lcl.lcntr, 1, '=')] = 1>
				</cfif>
			</cfloop>
			
			<cfset addContentObject(lcl.label, lcl.modulename, lcl.parameterlist)>
			<cfset lcl.reresults = refindnocase(re, html, lcl.reresults.pos[1] + 1, true)>	
		</cfloop>

	</cffunction>
	
	<cffunction name="addContentObject" output="false">
		<cfargument name="label">
		<cfargument name="modulename">
		<cfargument name="parameterlist" default="">

		<cfset queryaddrow(variables.viewinfo)>
		<cfset querysetcell(variables.viewinfo,'name', label)>
		<cfset querysetcell(variables.viewinfo,'modulename', modulename)>
		<cfset querysetcell(variables.viewinfo,'parameterlist', parameterlist)>
	</cffunction>
	
	<cffunction name="getViewInfo" output="false">
		<cfreturn variables.viewinfo>
	</cffunction>
	
</cfcomponent>