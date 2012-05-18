<cfcomponent name="views" output="false">
	<!--- COMMENT: 
			I get info on all the views
	--->
	<cffunction name="init" output="false">
		<cfargument name="mc">
		
		<cfset var filepath = arguments.mc & '/views/'>
		<cfset var dirs = createObject('component', 'utilities.fileSystem').getDirectoryListing(filepath)>
		<cfset var viewitem = "">
		<cfset variables.views = structnew()>
	
		<cfloop query="dirs">
			<cfif dirs.type EQ "dir" AND dirs.name NEQ '.svn' AND fileexists(filepath & dirs.name & '/index.cfm')>

				<cfset viewItem = createObject('component','resources.viewAnalyzer').init(filepath)>
				<cfset viewItem.loadView(dirs.name)>
				<cfset addView(dirs.name, viewItem.getViewInfo())>
			</cfif>
		</cfloop>

		<cfreturn this/>
	</cffunction>
			
	<cffunction name="addView" output="false">
		<cfargument name="name" required="true">
		<cfargument name="info" required="true">
		<cfset variables.views[name] = info>
	</cffunction>
	
	<cffunction name="getViewData"  output="false">
		<cfargument name="userview" default="false">
		<cfset var d = "">
        <cfset var indx = ''>
		
		<!--- ip check --->
		<cfif structisempty(variables.views)>
			<cfthrow message="Views not loaded">
		</cfif>
        
        <cfset d = duplicate(variables.views)>
        
        <cfif arguments.userview><!--- for esm consumption, remove views starting with _ --->
        	<cfloop collection="#d#" item="indx">
            	<cfif left(indx, 1) EQ '_'>
                	<cfoutput>clear #indx#<br></cfoutput>
                	<cfset structdelete(d,indx)>
                </cfif>
            </cfloop>
        </cfif>

		<cfreturn createObject('component','utilities.json').encode(d)>
	</cffunction>
	
	<cffunction name="getView">
		<cfargument name="name" required="true">
		

		<cfif NOT structkeyexists(variables.views, name)>
			<cfthrow message="View '#name#' is not defined in the loaded views. Please confirm that it exists in the views directory">
		</cfif>		
		
		<cfreturn variables.views[name]>
	</cffunction>
	
	<cffunction name="dump">
		<cfdump var="#variables.views#"><cfabort>
	</cffunction>
</cfcomponent>