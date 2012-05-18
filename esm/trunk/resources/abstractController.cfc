<cfcomponent name="parent controller">
	<cffunction name="getResource">
		<cfargument name="name" required="true">
		<cftry>
			<cfreturn createObject('component','resources.#arguments.name#').init(arguments)>
			<cfcatch>
				<cfthrow message="Could not find resource #arguments.name#">
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="getwidget">
		<cfargument name="name" required="true">
		<cftry>
			<cfreturn createObject('component','widgets.#arguments.name#').init(arguments)>
			<cfcatch>
				<cfthrow message="Could not find widget #arguments.name#">
			</cfcatch>
		</cftry>
	</cffunction>
	
	<cffunction name="getUtility">
		<cfargument name="name" required="true">
		<cftry>
			<cfreturn createObject('component','utilities.#arguments.name#')>
			<cfcatch>
				<cfthrow message="Could not find util #arguments.name#">
			</cfcatch>
		</cftry>
	</cffunction>
</cfcomponent>