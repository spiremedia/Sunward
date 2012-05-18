<cfcomponent name="model" output="false" extends="resources.abstractContentObjectEditorModel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		
		<cfset loadItem(variables.request.getFormUrlVar('id'))>
		
		<cfparam name="variables.recipient_dealership" default="">
		<cfparam name="variables.reply" default="">

		<cfreturn this>
	</cffunction>
	
	<cffunction name="getinfo">
		<cfset var r = structnew()>
		<cfset r.id = variables.id>
		<cfset r.recipient_dealership = variables.recipient_dealership>
		<cfset r.reply = variables.reply>
		<cfreturn r>
	</cffunction>
	<!--- TODO setup this model to be inheritance based to save duplicaating load item --->
			
	<cffunction name="setvalues">
		<cfargument name="itemdata">
		<cfset variables.id = arguments.itemdata.id>
		<cfset variables.recipient_dealership = arguments.itemdata.recipient_dealership>
		<cfset variables.reply = arguments.itemdata.reply>
	</cffunction>
	
	<cffunction name="validate">		
		<cfset var lcl = structnew()>
		
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		
		<cfset vdtr.validemail('recipient_dealership', variables.recipient_dealership, 'The Email Recipient for Dealership Inquiries must be a valid email.')>
		<cfset vdtr.notblank('reply', variables.reply, 'Please enter a Form Submission Reply.')>
				
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var mydata = structnew()>

		<cfset mydata.recipient_dealership = variables.recipient_dealership>
		<cfset mydata.reply = variables.reply>

		<cfset saveData(mydata)>
	</cffunction>

</cfcomponent>
	