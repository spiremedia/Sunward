<cfcomponent name="requestDecorator" output="false">

	<cffunction name="init" output="false">
		<cfargument name="decoratedObject" required="yes" >
		<cfset variables.decoratedObject = arguments.decoratedObject>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setvar" output="false">
		<cfargument name="name">
		<cfargument name="value">
		
		<cfset variables.decoratedObject.setVar(name, value)>
	</cffunction>
	
	<cffunction name="getvar" output="false">
		<cfargument name="name">
				
		<cfreturn variables.decoratedObject.getVar(name)>
	</cffunction>
	
	<cffunction name="isvarset" output="false">
		<cfargument name="name">
		<cfreturn variables.decoratedObject.isVarSet(name)>
	</cffunction>
	
	<cffunction name="isformurlvarset" output="false">
		<cfargument name="name">
		<cfreturn variables.decoratedObject.isformurlvarset(name)>
	</cffunction>
	
	<cffunction name="getformurlvar" output="false">
		<cfargument name="name">
		<cfreturn variables.decoratedObject.getformurlvar(name)>
	</cffunction>
    
    <cffunction name="getunsafeformurlvar" output="false">
		<cfargument name="name">
		<cfreturn variables.decoratedObject.getunsafeformurlvar(name)>
	</cffunction>
	
	<cffunction name="getallformurlvars" output="false">
		<cfreturn variables.decoratedObject.getallformurlvars()>
	</cffunction>
	
	<cffunction name="getUrlIdentifyer">
		<cfreturn variables.decoratedObject.getUrlIdentifyer()>
	</cffunction>
	
    <cffunction name="getUserObject" output="false">
		<cfreturn variables.decoratedObject.getUserObject()>
	</cffunction>
    
    <cffunction name="getStateObject" output="false">
		<cfreturn variables.decoratedObject.getStateObject()>
	</cffunction>
    
    <cffunction name="setStateObject" output="false">
		<cfargument name="stateObject" required="true">
		<cfset variables.decoratedObject.setStateObject(arguments.stateObject)>
	</cffunction>
	
	<cffunction name="dump">
		<cfset variables.decoratedObject.dump()>
	</cffunction>
	
</cfcomponent>