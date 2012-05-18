<cfcomponent extends="resources.abstractController" ouput="false">

	<cffunction name="init" output="false">
		<cfargument name="data">
		<cfargument name="pageref">
		<cfargument name="parameterlist" default="">
		<cfargument name="requestObject">
		
		<cfset var model = getModel(requestObject = arguments.requestObject)> 

        <cfset variables.requestObject = arguments.requestObject>
		
		<cfparam name="data.view" default="list">
		<cfswitch expression="#data.view#">
			<cfcase value="list">
				<cfset variables.control = createObject('component','modules.news.listcontroller').init(data, model, requestObject)>
			</cfcase>
			<cfcase value="item">
				<cfset variables.control = createObject('component','modules.news.newsViewController').init(data, model, requestObject)>
			</cfcase>
		</cfswitch>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="getModel">
		<cfargument name="requestObject" required="true">
		<cfreturn createObject('component', 'modules.news.models.news').init(requestObject = arguments.requestObject)>
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
		<cfset var itms = model.getAllAvailableNewsItems()>
		<cfset var webpath = "NewsAndEvents/News/View/">
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