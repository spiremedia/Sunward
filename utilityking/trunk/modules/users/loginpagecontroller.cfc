<cfcomponent name="user controller" output="false" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="data">
		<cfargument name="requestObject">
        <cfargument name="parameterlist">
		<cfargument name="pageRef">

		<cfset variables.requestObject = arguments.requestObject>

		<cfreturn this>
	</cffunction>
	
    <cffunction name="validate">
		<cfargument name="vdtr" required="true">
       		
		<cfset var info = variables.requestObject.getAllFormUrlVars()>
		<cfset var validationResult = "">
	        
		<cfset vdtr.lengthbetween('un',2,20, info.un, 'A username is required')>
		<cfset vdtr.lengthbetween('pd',2,20, info.pd, 'The password must be between 5 and 20 chars')>
		
        <cfif NOT vdtr.passValidation()>
        	<cfreturn vdtr>
        </cfif>
        
		<cfset validationResult = requestObject.getUserObject().checkCredentials(info.un, info.pd, variables.requestObject)>

        <cfif validationResult NEQ 1>
        	<cfset vdtr.addError('un', validationResult)>
        </cfif>
        
        <cfreturn vdtr>
	</cffunction>
    
	<cffunction name="showHTML" output="false">
		<cfset var vdtr = getUtility('datavalidator').init()>
		<cfset var form = "">
		<cfset var html = "">
	
		<!--- <cfif variables.requestObject.isformurlvarset('un') AND
				variables.requestObject.isformurlvarset('pd')>
			<cfset validate(vdtr)>
			<cfif vdtr.passValidation()>
				<cflocation url="#requestObject.getUserObject().getLoginRelocationPath()#" addtoken="no">
			</cfif>
		</cfif>
	
		<cfset form = getUtility('formbuilder')>
		<cfset form.init(variables.requestObject,"userlogin",'Post',vdtr)>
		<cfset form.addFormItem('un', 'User Name', 'text')>
		<cfset form.addFormItem('pd', 'Password', 'password')>
		<cfset form.addSubmit('submit','', 'Submit')>
        <cfif requestObject.isFormUrlVarSet('reason')>
        	<cfreturn '<ul class="errors"><li>#requestObject.getFormUrlVar('reason')#</li></ul>' & form.showHTML()>
        <cfelse>
        	<cfreturn form.showHTML()>
        </cfif> --->
		
	</cffunction>
    	
	<cffunction name="dump">
		<cfset variables.control.dump()>
	</cffunction>
    
    <cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>

</cfcomponent>