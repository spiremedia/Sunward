<cfcomponent name="dhtmlPager" extends="modules.simplecontent.controller">
	
    <cffunction name="init">
		<cfset variables.requestObject = arguments.requestObject>
		
		<cfparam name="arguments.name" default="noname">
    	<cfset arguments.data.name = arguments.name>
        <cfparam name="arguments.data.dhtmltype" default="default">
        <cfparam name="arguments.data.startsopen" default="1">
        <cfparam name="arguments.data.items" default="#arraynew(1)#">
        <!--- force type if specified in template --->
        <cfif isdefined("arguments.parameterlist.type")>
        	<cfset arguments.data.dhtmltype = arguments.parameterlist.type>
        </cfif>
        <cfif not listfindnocase("accordion,tabs,button,default", arguments.data.dhtmltype)>
        	<cfthrow message="invalid dhtml type ""#arguments.data.dhtmltype#""">
        </cfif>
        <cfset variables.view = createObject('component', "modules.dhtmlpager.#arguments.data.dhtmltype#View").init(arguments.requestObject, arguments.data)>
    	<cfreturn this>
    </cffunction>
    
    <cffunction name="showHTML">
    	<cfreturn parseForLanguage( variables.view.showHTML() )>
    </cffunction>
	
	<cffunction name="showReversionHTML">
    	<cfreturn parseForLanguage( variables.view.showHTML() )>
    </cffunction>
    
</cfcomponent>
