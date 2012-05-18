<cfcomponent name="accordion" extends="arraywidget">
	<cffunction name="init">
		<cfset super.init(argumentcollection = arguments)>
		<cfset variables.type="accordion">
		<cfreturn this>
	</cffunction>
</cfcomponent>