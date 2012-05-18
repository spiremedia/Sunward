<cfcomponent name="model" output="false" extends="resources.abstractContentObjectEditorModel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		
		<cfset loadItem(variables.request.getFormUrlVar('id'))>
		
		<cfparam name="variables.label" default="">

		<cfreturn this>
	</cffunction>
	
	<cffunction name="getinfo">
		<cfset var r = structnew()>
		<cfset r.id = variables.id>
		<cfset r.label = variables.label>
		<cfreturn r>
	</cffunction>
	<!--- TODO setup this model to be inheritance based to save duplicaating load item --->
			
	<cffunction name="setvalues">
		<cfargument name="itemdata">
		<cfset variables.id = arguments.itemdata.id>
		<cfset variables.label = arguments.itemdata.label>
	</cffunction>
	
	<cffunction name="validate">		
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var mydata = structnew()>
		<cfset mydata.label = variables.label>
		<cfset saveData(mydata)>
	</cffunction>

</cfcomponent>
	