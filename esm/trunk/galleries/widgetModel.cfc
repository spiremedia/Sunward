<cfcomponent name="model" output="false" extends="resources.abstractContentObjectEditorModel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		
		<cfset loadItem(variables.request.getFormUrlVar('id'))>
		
		<cfparam name="variables.gallerygroupid" default="">
		<cfparam name="variables.displaymode" default="">

		<cfreturn this>
	</cffunction>
	
	<cffunction name="getinfo">
		<cfset var r = structnew()>
		<cfset r.id = variables.id>
		<cfset r.gallerygroupid = variables.gallerygroupid>
		<cfset r.displaymode = variables.displaymode>
		<cfreturn r>
	</cffunction>
	<!--- TODO setup this model to be inheritance based to save duplicaating load item --->
			
	<cffunction name="setvalues">
		<cfargument name="itemdata">
		<cfset variables.id = arguments.itemdata.id>
		<cfset variables.gallerygroupid = arguments.itemdata.gallerygroupid>
		<cfset variables.displaymode = arguments.itemdata.displaymode>
	</cffunction>
	
	<cffunction name="validate">		
		<cfset var lcl = structnew()>
		
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		
		<cfif variables.gallerygroupid EQ "">
			<cfset vdtr.addError('galleryGroupName', 'Please choose one a Group.')>
		</cfif>
		
		<cfif variables.gallerygroupid EQ "">
			<cfset vdtr.addError('displaymode', 'Please choose a displaymode.')>
		</cfif>
				
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var mydata = structnew()>

		<cfset mydata.gallerygroupid = variables.gallerygroupid>
		<cfset mydata.displaymode = variables.displaymode>

		<cfset saveData(mydata)>
	</cffunction>

</cfcomponent>
	