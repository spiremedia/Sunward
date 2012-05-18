<cfcomponent name="formatter">
	<cffunction name="init">
		<cfargument name="selected" default="">
		<cfset variables.selected = arguments.selected>
		<cfset variables.strlist = arraynew(1)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="add">
		<cfargument name="itm">
		<cfset arrayappend(variables.strlist, itm)>
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
		<cfset var selected = "">
		<cfif variables.selected EQ data.id>
			<cfset selected = "selected">
		</cfif>
		<cfset add("<option value=""#data.id#"" #selected#>#repeatstring("&nbsp;", arguments.depth)##data.pagename#</option>")>
	</cffunction>
	
	<cffunction name="render">
		<cfreturn arraytolist(variables.strlist,"#chr(13)##chr(10)#")>
	</cffunction>
</cfcomponent>