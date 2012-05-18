<cfcomponent name="events controller" output="false" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="data">
		<cfargument name="requestObject">
		<cfargument name="pageRef">

		<cfset var model = getModel(requestObject = arguments.requestObject)>
		
		<cfset variables.requestObject = arguments.requestObject>
		
		<cfparam name="data.view" default="list">
		<cfswitch expression="#data.view#">
			<cfcase value="list">
				<cfset variables.control = createObject('component','modules.events.listcontroller').init(data, model, requestObject)>
			</cfcase>
			<cfcase value="item,register,thanks">
				<cfset variables.control = createObject('component','modules.events.eventViewController').init(data, model, requestObject, pageRef)>
			</cfcase>
		</cfswitch>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getModel">
		<cfargument name="requestObject" required="true">
		<cfreturn createObject('component', 'modules.events.models.events').init(requestObject = arguments.requestObject)>
	</cffunction>
	
	<cffunction name="showHTML" output="false">
		<cfreturn variables.control.showHTML()>
	</cffunction>
	
	<cffunction name="dump">
		<cfset variables.control.dump()>
	</cffunction>
	
	<cffunction name="getPagesforSiteSearch">
		<cfargument name="aggregator">

		<cfset var model = getModel(requestObject = variables.requestObject)>
		<cfset var itms = model.getEventsList()>
		<cfset var webpath = "NewsAndEvents/Event/">
        <cfset var indexable = "">
		
		<cfloop query="itms">
        	<cfset indexable = aggregator.newpageindexable()>
            <cfset indexable.setkey(itms.id)>
            <cfset indexable.setpath(webpath & itms.id & '/')>
            <cfset indexable.settitle(itms.title)>
            <cfset indexable.setdescription(itms.description)>
            <cfset indexable.saveForIndex()>
        </cfloop>
		
	</cffunction>

	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
	
</cfcomponent>