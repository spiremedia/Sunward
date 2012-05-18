<cfcomponent name="cloudView" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="data">
		<cfargument name="requestObject">

		<cfset variables.requestObject = arguments.requestObject>
        <cfset variables.data = arguments.data>
       
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getModel">
		<cfif NOT isdefined("variables.cloudModel")>
			<cfset variables.cloudModel = createObject('component', 'modules.tagcloud.cloudmodel').init(requestObject = variables.requestObject)>
        </cfif>
		<cfreturn variables.cloudModel>
    </cffunction>
	
	<cffunction name="showHTML">
		<cfset var view = createObject('component', 'modules.tagcloud.cloudview').init(requestObject = variables.requestObject)>
        <cfset var mdl = getModel()>
        
        <cfif NOT mdl.loaded()>
       		<cfset loadModel()>
		</cfif>
        
		<cfset view.setModel(mdl)>

		<cfreturn view.showHTML()>
	</cffunction>
    
    <cffunction name="loadModel">
    	<cfset var mdl = getModel()>
       	<cfset var pages = "">
        <cfset var words = "">
        <cfset var wordidx = "">
        <cfset var wordparser = createObject('component', 'utilities.wordparser').init(requestObject = variables.requestObject)>
		<cfset var filename = requestObject.getVar("machineroot") & "/modules/tagCloud/clouddata.txt">
        
        <cfif fileexists(filename)>
			<cffile action="read" file="#filename#" variable="words">
            <cfset words = deserializejson(words)>
            <cfloop from="1" to="#arraylen(words)#" index="wordidx">
				<cfset mdl.addCloudItem(words[wordidx].word, words[wordidx].cnt)>
            </cfloop>
		</cfif>
         	       
    </cffunction>
	
</cfcomponent>