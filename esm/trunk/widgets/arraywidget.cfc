<cfcomponent name="arraywidget" output="false">
	
	<cffunction name="init" output="false">
		<cfset variables.htmlitems = arraynew(1)>
		<cfset variables.mystring = arraynew(1)>
		<cfset variables.active = 1>
		<cfset variables.type = 'accordion'>
		<cfif isdefined("arguments.id")>
			<cfset variables.id = arguments.id>
		</cfif>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setID" output="false">
		<cfargument name="id" required="true">
		<cfset variables.id = arguments.id>
	</cffunction>
	
	<cffunction name="settitle" access="private" output="false">
		<cfargument name="title" required="true">
		<cfif variables.type EQ 'accordion'>
			<cfreturn title>
		<cfelse>
			<cfreturn "<span>#title#</span>">
		</cfif>
	</cffunction>
	
	<cffunction name="setinfo" output="false">
		<cfargument name="info" required="true">
		
	</cffunction>
	
	<cffunction name="showHtml" output="false">
		<cfset var s = arraynew(1)>
		<cfset var itmindx = 0>
		<cfset var str = '<dl class="#variables.type#" '>
		<cfif structkeyexists(variables,'id')>
			<cfset str = str & "id=""#variables.id#""">
		</cfif>
		<cfset addtostring(str & '>')>
		
		<cfloop from="1" to="#arraylen(variables.htmlitems)#" index="itmindx">
			
			<cfif listfind(variables.active, itmindx)>
				<cfset addtostring('<dt class="selected">#settitle(variables.htmlitems[itmindx].title)#</dt>')>
				<cfset addtostring('<dd>')>
			<cfelse>
				<cfset addtostring('<dt>#settitle(variables.htmlitems[itmindx].title)#</dt>')>
				<cfset addtostring('<dd style="display:none">')>
			</cfif>
			
			<cfset addtostring(variables.htmlitems[itmindx].html)>
			<cfset addtostring('</dd>')>
		</cfloop>
		
		<cfset addtostring('</dl>')>
		
		<cfreturn arraytolist(variables.mystring,"#chr(13)##chr(10)#")>
	</cffunction>
	
	<cffunction name="settype" output="false">
		<cfargument name="type">
		<cfset variables.type = arguments.type>
	</cffunction>
	
	<cffunction name="setselected"  output="false">
		<cfargument name="active">
		<cfset variables.active = arguments.active>
	</cffunction>
	
	<cffunction name="add" output="false">
		<cfargument name="title" required="true">
		<cfargument name="html" required="true">
		
		<cfset arrayappend(variables.htmlitems, arguments)>
	</cffunction>
	
	<cffunction name="addtostring" access="private"  output="false">
		<cfargument name="string" required="true">
		<cfset arrayappend(variables.mystring,string)>
	</cffunction>
	
</cfcomponent>