<cfcomponent name="simple" extends="arraywidget">
	<cffunction name="init">
		<cfset super.init()>
		<cfset variables.type="simple">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="showHtml">
		<cfset var s = arraynew(1)>
		<cfset var itmindx = 0>
		
		<cfloop from="1" to="#arraylen(variables.htmlitems)#" index="itmindx">

				<cfset addtostring('<dl class="simple">')>
				<cfset addtostring('<dt class="selected"><span>#variables.htmlitems[itmindx].title#</span></dt>')>
				<cfset addtostring('<dd></dd></dl>')>
				
				<cfset addtostring('<div class="group">')>
				<cfset addtostring('<div class="inner">')>
				<cfset addtostring('<div class="bottom">')>
				<cfset addtostring('<div class="inner">')>
				<cfset addtostring('<div class="panel">')>
				
				<cfset addtostring(variables.htmlitems[itmindx].html)>
				
				<cfset addtostring('</div>')>
				<cfset addtostring('</div>')>
				<cfset addtostring('</div>')>
				<cfset addtostring('</div>')>
				<cfset addtostring('</div>')>
	
		</cfloop>
		
		<cfreturn arraytolist(variables.mystring,"#chr(13)##chr(10)#")>
	</cffunction>
</cfcomponent>