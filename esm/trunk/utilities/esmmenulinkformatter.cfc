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
		<cfset add('<ul>')>
	</cffunction>
	
	<cffunction name="postgroup">
		<cfargument name="depth">
		<cfset add('</ul>')>
	</cffunction>
	
	<cffunction name="preitem">
		<cfargument name="depth">
		<cfset add('<li>')>
	</cffunction>
	
	<cffunction name="postitem">
		<cfargument name="depth">
		<cfset add('</li>')>
	</cffunction>
	
	<cffunction name="item">
		<cfargument name="data">
		<cfset var selected = "">
		<cfif variables.selected EQ data.id>
			<cfset selected = "class=""selected""">
		</cfif>
		<cfset add("<a id=""#data.id#"" #selected# href=""/pages/editPage/?id=#data.id#"">#data.pagename#</a>")>
	</cffunction>
	
	<cffunction name="render">
		<cfreturn arraytolist(variables.strlist,"#chr(13)##chr(10)#")>
	</cffunction>
</cfcomponent>