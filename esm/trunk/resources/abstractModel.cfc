<cfcomponent name="model">
	<cffunction name="attachObserver">
		<cfargument name="observer" required="true">
		<cfif not isdefined('variables.observers')>
			<cfset variables.observers = arraynew(1)>
		</cfif>
		<cfset arrayappend(variables.observers, arguments.observer)>
	</cffunction>
	
	<cffunction name="observeEvent">
		<cfargument name="eventName">
		<cfargument name="more">
        <cfif isDefined("variables.observers")>
            <cfloop from="1" to="#arraylen(variables.observers)#" index="i">
                <cfset variables.observers[i].event(arguments.eventName, this, more)>
            </cfloop>
        </cfif>
	</cffunction>
	
	<cffunction name="getWidget">
		<cfargument name="widgetname">
		<cfreturn createobject('component','widget.#widgetname#').init()>
	</cffunction>
	
	<cffunction name="getResource">
		<cfargument name="resourcename">
		<cfargument name="requestObj">
		<cfargument name="userObj">
		<cfreturn createobject('component','resources.#resourcename#').init(requestObj, userObj)>
	</cffunction>
</cfcomponent>