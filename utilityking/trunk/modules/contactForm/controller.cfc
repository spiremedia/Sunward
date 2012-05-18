<cfcomponent extends="resources.abstractController" ouput="false">

	<cffunction name="init" output="false">
		<cfargument name="data">
		<cfargument name="pageref">
		<cfargument name="parameterlist" default="#structnew()#">
		<cfargument name="requestObject">
			
		<cfset var mdl = getModel(requestObject = arguments.requestObject, data = arguments.data)> 
		<cfset variables.vdtr = createObject('component', 'resources.abstractController').getUtility('datavalidator').init()>
		<cfparam name="arguments.data.itemToDisplay" default="contactFormView">
		<cfparam name="arguments.data.reply" default="Thanks">	

		<!--- determine if form submission --->
		<cfif requestObject.isformurlvarset('contactFormID')>				
			<!--- validate form --->
			<cfset variables.vdtr = mdl.validateContactForm()>			
			<cfif variables.vdtr.passValidation()>
				<!--- save form --->
				<cfset mdl.processContactForm()>
			</cfif>
		</cfif>
		
		<cfset data.vdtr = variables.vdtr>
		
		<cfset structappend(variables, arguments.data)>		
		<cfset variables.ctrl = createObject('component','modules.contactform.views.#replace(arguments.data.itemToDisplay, " ", "", "All")#').init(requestObject = requestObject, mdl = mdl, data = data)>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="getModel">
		<cfargument name="requestObject" required="true">
		<cfargument name="data">
		<cfreturn createObject('component', 'modules.contactform.models.contactform').init(requestObject = arguments.requestObject, data = arguments.data)>
	</cffunction>
	
	<cffunction name="showHTML" output="false">
		<cfreturn variables.ctrl.showHTML()>
	</cffunction>

	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
    
</cfcomponent>