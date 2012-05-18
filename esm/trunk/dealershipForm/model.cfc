<cfcomponent name="model" output="false" extends="resources.abstractContentObjectEditorModel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		
		<cfset loadItem(variables.request.getFormUrlVar('id'))>
		
		<!--- <cfparam name="variables.src" default="#variables.request.getVar('isgurl')#"> --->
		<cfreturn this>
	</cffunction>
	
	<!--- <cffunction name="getSrc">
		<cfreturn variables.src>
	</cffunction> --->
	<!--- TODO setup this model to be inheritance based to save duplicaating load item --->
			
	<cffunction name="setvalues">
		<cfargument name="itemdata">
		<cfset variables.id = arguments.itemdata.id>
		<!--- <cfset variables.src = arguments.itemdata.src> --->
	</cffunction>
	
	<cffunction name="validate">		
		<cfset var lcl = structnew()>
		
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var mylocal = structnew()>
		
		<!--- <cfset vdtr.notblank('src', variables.src, 'The Location should not be blank.')>
		<cfif trim(variables.src) neq ''>
			<cfset vdtr.regexnomatchtest('redirect', '^https?:\/\/', variables.src, 'The Location should be an absolute path (ie. http://fpanet.org/).')> 
		</cfif> --->
		
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var mydata = structnew()>
		<!--- <cfset mydata.src = variables.src> --->
		<cfset saveData(mydata)> 
	</cffunction>

</cfcomponent>
	