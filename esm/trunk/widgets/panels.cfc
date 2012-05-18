<cfcomponent name="panels" extends="arraywidget">
	<cffunction name="init">
		<cfset super.init(argumentcollection = arguments)>
		<cfset variables.type="panels">
		<cfreturn this>
	</cffunction>
</cfcomponent>