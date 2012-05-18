<cfcomponent name="model" output="false" extends="resources.abstractContentObjectEditorModel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		
		<cfset loadItem(variables.request.getFormUrlVar('id'))>
		
		<cfparam name="variables.formid" default="">

		<cfreturn this>
	</cffunction>
	
	<cffunction name="getinfo">
		<cfset var r = structnew()>
		<cfset r.id = variables.id>
		<cfset r.formid = variables.formid>
		<cfreturn r>
	</cffunction>
	<!--- TODO setup this model to be inheritance based to save duplicaating load item --->
			
	<cffunction name="setvalues">
		<cfargument name="itemdata">
		<cfset variables.id = arguments.itemdata.id>
		<cfset variables.formid = arguments.itemdata.formid>
	</cffunction>
	
	<cffunction name="validate">		
		<cfset var lcl = structnew()>
		
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var mylocal = structnew()>
		
		<cfif variables.formid EQ "">
			<cfset vdtr.addError('formid', 'Please choose a form.')>
		</cfif>
		
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var mydata = structnew()>

		<cfset mydata.formid = variables.formid>

		<cfset saveData(mydata)>
	</cffunction>

</cfcomponent>
	