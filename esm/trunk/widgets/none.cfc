<cfcomponent name="plain" extends="arraywidget">
	<cffunction name="init">
		<cfset super.init()>
		<cfset variables.type="plain">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="showHtml">
		<cfset var s = arraynew(1)>
		<cfset var itmindx = 0>
		
		<cfloop from="1" to="#arraylen(variables.htmlitems)#" index="itmindx">

				<cfset addtostring('<b>#variables.htmlitems[itmindx].title#</b>' & variables.htmlitems[itmindx].html)>
					
		</cfloop>
		
		<cfreturn arraytolist(variables.mystring,"#chr(13)##chr(10)#")>
	</cffunction>
</cfcomponent>