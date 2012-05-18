<cfcomponent name="templaterunner" output="false">
	
	<cffunction name="init" output="false">
		<cfset variables.newselected = false>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="createWidget" output="false">
		<cfargument name="type" default="accordion">
		<cfset var widg = createObject('component','widgets.#arguments.type#').init()>
		<cfset widg.setInfo(arguments)>
		<cfreturn widg>
	</cffunction>
	
	<cffunction name="settemplate" output="false">
		<cfargument name="t" required="true">
		<cfset variables.template = arguments.t>
	</cffunction>
	
	<cffunction name="setSecurity" output="false">
		<cfargument name="s" required="true">
		<cfset variables.securityObj = arguments.s>
	</cffunction>
	
	<cffunction name="setRequestobj" output="false">
		<cfargument name="s" required="true">
		<cfset variables.requestObj = arguments.s>
	</cffunction>
	
	<cffunction name="setInfo" output="false">
		<cfargument name="t" required="true">
		<cfset variables.info = arguments.t>
	</cffunction>
	
	<cffunction name="setSelected" output="false">
		<cfargument name="newselected" required="true">
		<cfset variables.newselected = arguments.newselected>
	</cffunction>
	
	<cffunction name="getSelected" output="false">
		<cfreturn variables.newselected>
	</cffunction>
	
	<cffunction name="setdata" output="false">
		<cfargument name="d" required="true">
		<cfset variables.data = arguments.d>
	</cffunction>
	
	<cffunction name="getDataItem" output="false">
		<cfargument name="name">
		<cfif not structkeyexists(variables.data, name)>
			<cfthrow message="data '#name#' has not been set for template runner consumption in template '#variables.template#'">
		</cfif>
	
		<cfreturn variables.data[name]/>
	</cffunction>
	
	<cffunction name="isDataItemSet" output="false">
		<cfargument name="name">
		<cfreturn structkeyexists(variables.data, name)>
	</cffunction>
	
	<cffunction name="getHTML" output="false">
		<cfset var m = "">
		<cfset var lcl = structnew()>
        <cfset var items = structnew()>
		<cfsavecontent variable="m"><cfinclude template="../#variables.template#"></cfsavecontent>
		<cfreturn m>
	</cffunction>

</cfcomponent>