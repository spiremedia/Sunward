<cfcomponent name="formatter">
	<cffunction name="init">
		<cfargument name="selected">
		<cfset variables.selectedid = arguments.selected>
		<cfset variables.strlist = arraynew(1)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="add">
		<cfargument name="itm">
		<cfset arrayappend(variables.strlist, itm)>
	</cffunction>
	
	<cffunction name="pregroup">
		<cfargument name="depth">
		<cfargument name="groupcount">
		<cfset add('<ul>')>
	</cffunction>
	
	<cffunction name="postgroup">
		<cfargument name="depth">
		<cfset add('</ul>')>
	</cffunction>
	
	<cffunction name="preitem">
		<cfargument name="data">
		<cfargument name="depth">
		<cfargument name="groupcount">
		<cfargument name="itemcount">
		
		<cfset add('<li>')>	
	</cffunction>
	
	<cffunction name="postitem">
		<cfargument name="data">
		<cfargument name="depth">
		<cfargument name="groupcount">
		<cfargument name="itemcount">
		<cfset add('</li>')>
	</cffunction>
	
	<cffunction name="item">
		<cfargument name="data">
		<cfargument name="depth">
		<cfargument name="groupcount">
		<cfargument name="itemcount">
		<cfset var selectedtxt = "">

		<cfif variables.selectedid EQ data.id>
			<cfset selectedtxt = "class=""selected""">
		</cfif>
		<cfset add('<a #selectedtxt# href="/pages/editPage/?id=#data.id#" title="#xmlformat(data.pagename)#">#xmlformat(data.pagename)#</a>')>
	</cffunction>
	
	<cffunction name="render">
		<cfreturn arraytolist(variables.strlist,"#chr(13)##chr(10)#")>
	</cffunction>
</cfcomponent>