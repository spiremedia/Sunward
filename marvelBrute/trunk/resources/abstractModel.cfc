<cfcomponent name="abstractmodule">
	<cffunction name="showHTML"><cfinclude template="#getTemplate()#"></cffunction>
	<cffunction name="setTemplate">
		<cfargument name="tplt">
		<cfset variables.template = arguments.tplt>
	</cffunction>
	<cffunction name="getTemplate">
		<cfif not structkeyexists(variables,'tplt')>
			<cfthrow message="template not set in module">
		</cfif>
		<cfreturn variables.tplt>
	</cffunction>
</cfcomponent>