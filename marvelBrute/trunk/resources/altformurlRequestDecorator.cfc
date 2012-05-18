<cfcomponent name="requestDecorator" extends="resources.abstractRequestDecorator" output="false">
	
	<cffunction name="setRequestFields">
		<cfargument name="fieldStruct" required="yes">
		
		<cfset variables.fakeRequest = arguments.fieldStruct>
	</cffunction>
	
	<cffunction name="isformurlvarset" output="false">
		<cfargument name="name">
		<cfreturn structKeyExists(variables.fakeRequest,name)>
	</cffunction>
	
	<cffunction name="getformurlvar" output="false">
		<cfargument name="name">
		<cfif NOT structkeyexists(variables.fakeRequest, arguments.name)>
			<cfthrow message="'#name#' is not set in formurlvars in requestobject">
		</cfif>
		<cfreturn htmleditformat(variables.fakeRequest[arguments.name])>
	</cffunction>
	
	<cffunction name="getunsafeformurlvar" output="false">
		<cfargument name="name">
		<cfif NOT structkeyexists(variables.fakeRequest, arguments.name)>
			<cfthrow message="'#name#' is not set in formurlvars in requestobject">
		</cfif>
		<cfreturn variables.fakeRequest[arguments.name]>
	</cffunction>
	
	<cffunction name="getallformurlvars" output="false">
		<cfreturn variables.fakeRequest>
	</cffunction>
</cfcomponent>