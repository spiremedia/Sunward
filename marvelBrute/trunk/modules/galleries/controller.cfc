<cfcomponent name="cloudView" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="data">
		<cfargument name="requestObject">

		<cfset variables.requestObject = arguments.requestObject>
        <cfset variables.data = arguments.data>
       	<cfset variables.name = arguments.name>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getModel">
		<cfif NOT isdefined("variables.galleriesModel")>
			<cfset variables.galleriesModel = createObject('component', 'modules.galleries.galleriesmodel').init(requestObject = variables.requestObject)>
        </cfif>
		<cfreturn variables.galleriesModel>
    </cffunction>
	
	<cffunction name="getView">
		<cfargument name="view" required="true">
		<cfreturn createObject('component', 'modules.galleries.views.#arguments.view#').init(
					requestObject = variables.requestObject,
					data = variables.data,
					name = variables.name)>
    </cffunction>
	
	<cffunction name="showHTML">
		<cfset var view = "">
        <cfset var mdl = getModel()>

        <cfset view = getView(data.displaymode)>
		<cfset view.setModel(mdl)>

		<cfreturn view.showHTML()>
	</cffunction>

	
</cfcomponent>