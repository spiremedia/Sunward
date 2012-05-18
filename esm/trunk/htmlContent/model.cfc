<cfcomponent name="model" output="false" extends="resources.abstractContentObjectEditorModel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>

		<cfset loadItem(variables.request.getFormUrlVar('id'))>
		
		<cfparam name="variables.content" default="">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getContent">
		<cfset var parser = createobject('component','utilities.embeddedlinksandassetsparser').init(variables.request)>
		<cfset variables.content = parser.preprocessforwysywig(variables.content)>
		
		<cfreturn variables.content>
	</cffunction>
	<!--- TODO setup this model to be inheritance based to save duplicaating load item --->
			
	<cffunction name="setvalues">
		<cfargument name="itemdata">
		
		<cfset variables.id = arguments.itemdata.id>
		<cfset variables.content = arguments.itemdata.content>
		
	</cffunction>
	
	<cffunction name="validate">		
		<cfset var lcl = structnew()>
		
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var mylocal = structnew()>
		
		<cfset vdtr.notblank('name', variables.content, 'The Content Object may not be blank.')>
		
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var mydata = structnew()>
       	<cfset var parser = createobject('component','utilities.embeddedlinksandassetsparser').init(variables.request)>

		<cfset mydata.content = parser.postprocessfromwysywig(variables.content)>
		
		<cfset saveData(mydata)>
	</cffunction>

</cfcomponent>
	