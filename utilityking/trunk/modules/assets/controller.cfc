<cfcomponent name="simplecontent" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="data">
		<cfargument name="requestObject">
		<cfset var model = getModel(requestObject = arguments.requestObject)>
		<cfset var xtnsions = 'doc,jpg,pdf,rtf,txt,xls'>
		<cfset var tmp = arraynew(1)>
		<cfset var tmpxtn = "">

		<cfset variables.assetqry = querynew('none')>
		<cfset variables.requestObject = arguments.requestObject>
		
		<cfif isdefined("data.assetids") AND data.assetids NEQ "">
			<cfset variables.assetqry = model.getasset(data.assetids)>
		<cfelseif isdefined("data.assetgroupid") AND data.assetgroupid NEQ "">
			<cfset variables.assetqry = model.getassetgroup(data.assetgroupid)>		
		</cfif>
				
		<cfoutput query="variables.assetqry">
			<cfset tmpxtn = lcase(right(filename,3))>
			<cfif listfindnocase(xtnsions, tmpxtn)>
				<cfset arrayappend(tmp, tmpxtn)>
			<cfelse>
				<cfset arrayappend(tmp, 'unknown')>
			</cfif>
		</cfoutput>
		
		<cfset queryaddcolumn(variables.assetqry, "xtn", 'VarChar', tmp)>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getModel">
		<cfargument name="requestObject" required="true">
		<cfreturn createObject('component', 'modules.assets.model').init(requestObject = arguments.requestObject)>
	</cffunction>
	
	<cffunction name="showHTML">
		<cfset var html = "">
		<cfset var extText = "">
		<cfset var sizeText = "">
		<cfsavecontent variable="html">
			
			<cfoutput query="variables.assetqry">
				<cfset sizeText = "">
				<cfset extText = ucase(ListLast(filename,'.'))>
				<cfif filesize gt 1024000>
					<cfset sizeText = Numberformat(filesize/1024000, '____._') & 'MB'>
				<cfelseif filesize gt 0>
					<cfset sizeText = Numberformat(filesize/1024, '___') & 'KB'>
				</cfif>
				<cfif extText eq 'PDF'>
					<cfset extText = '<a href="http://www.Adobe.com" title="Download the latest version of Adobe Reader" target="_blank">' & extText & '</a>'>
				<cfelseif extText eq 'MP3'>
					<cfset extText = '<a href="www.microsoft.com/windows/windowsmedia/" title="" target="_blank">' & extText & '</a>'>
				<cfelseif extText eq 'WMV'>
					<cfset extText = '<a href="www.microsoft.com/windows/windowsmedia/" title="" target="_blank">' & extText & '</a>'>
				</cfif>
				<div class="supportingData  doc_#xtn#">
					<a href="/docs/assets/#filename#" target="_blank">#name#<!---> (#extText# | #sizeText#) ---></a>
				</div>
			</cfoutput>
	
		</cfsavecontent>
		<cfreturn html>
	</cffunction>
	
	<cffunction name="dump">
		<cfdump var="#variables.assetqry#">
		<cfabort>
	</cffunction>
	
	<cffunction name="getPagesforSiteSearch">
    	<cfargument name="aggregator">
		
		<cfset var assets = getModel(variables.requestObject).getAllAssets()>
        <cfset var indexable = "">

        <cfloop query="assets">
        	<cfset indexable = aggregator.newFileIndexable()>
            <cfset indexable.setkey(assets.id)>
			<cfset indexable.setpath('docs\assets\' & assets.id & '\' & assets.filename)>
            <cfset indexable.settitle(assets.name)>
            <cfset indexable.setdescription(assets.description)>
            <cfset indexable.saveForIndex()>
        </cfloop>
	</cffunction>

</cfcomponent>