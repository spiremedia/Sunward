<cfcomponent name="panels" extends="arraywidget" output="false">
	
	<cffunction name="init" output="false">
		<cfset super.init(argumentcollection = arguments)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="showHtml" output="false">
		<cfset var s = arraynew(1)>
		<cfset var itmindx = 0>
		<cfset var str = '<dl class="title" '>
		
		<cfif structkeyexists(variables,'id')>
			<cfset str = str & "id=""#variables.id#""">
		</cfif>
		
		<cfset addtostring(str & '>')>
		
		<cfloop from="1" to="#arraylen(variables.htmlitems)#" index="itmindx">
			<cfif itmindx EQ 1>
				<cfset addtostring('<dt>#variables.htmlitems[itmindx].html#</dt><dd>&nbsp;</dd>')>
			<cfelse>
				<cfset addtostring('<dt class="alternate">Actions</dt>')>
				<cfset addtostring('<dd class="alternate">#variables.htmlitems[itmindx].html#</dd>')>
			</cfif>
		</cfloop>
		
		<cfset addtostring('</dl>')>
		
		<cfreturn arraytolist(variables.mystring,"#chr(13)##chr(10)#")>
	</cffunction>
</cfcomponent>