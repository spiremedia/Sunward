<cfcomponent name="formatter">
	<cffunction name="init">
		<cfargument name="selected" default="">
		<cfset variables.selected = arguments.selected>
		<cfset variables.qry = querynew('id,pagename,urlpath')>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="add">
		
	</cffunction>
	
	<cffunction name="pregroup">
		<cfargument name="depth">
	</cffunction>
	
	<cffunction name="postgroup">
		<cfargument name="depth">
	</cffunction>
	
	<cffunction name="preitem">
		<cfargument name="depth">
	</cffunction>
	
	<cffunction name="postitem">
		<cfargument name="depth">
	</cffunction>
	
	<cffunction name="item">
		<cfargument name="data">
		<cfargument name="depth">
		<cfset queryaddrow(variables.qry)>
		<cfset querysetcell(variables.qry,  'id', data.id)>
		<cfset querysetcell(variables.qry, 'pagename', repeatstring('&nbsp;',depth) & data.pagename)>
		<cfset querysetcell(variables.qry, 'urlpath', data.urlpath)>
		
	</cffunction>
	
	<cffunction name="render">
		<cfreturn variables.qry>
	</cffunction>
</cfcomponent>