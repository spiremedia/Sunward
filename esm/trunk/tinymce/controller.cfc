<cfcomponent name="tinymce" extends="resources.abstractController">
	
	<cffunction name="getTinyMceModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','tinymce.models.tinymce').init(arguments.requestObject, arguments.userObj)>
		<cfreturn mdl/>
	</cffunction>	
	
	<cffunction name="showJSPageList">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var jslist = ''>
		<cfset var model = getTinyMceModel(arguments.requestObject, arguments.userObj)>
		<cfset var sitepages = dispatcher.callExternalModuleMethod('pages','getPages', arguments.requestObject, arguments.userobj)>
		<cfset var siteassets = dispatcher.callExternalModuleMethod('assets','getAvailableAssets', arguments.requestObject, arguments.userobj)>
		<cfset var siteid = userObj.getCurrentSiteId()>

		<cfset sitepages = duplicate(sitepages)>
        
        <cfloop query="sitepages">
        	<cfset sitepages.urlpath[sitepages.currentrow] = "{{link[#siteid#][#id#]}}">
			<cfset sitepages.pagename[sitepages.currentrow] = replace(sitepages.pagename[sitepages.currentrow],"&nbsp;",".","all")>
        </cfloop>
        
		<cfloop from="1" to="#siteassets.recordcount#" index="i">
			<cfset queryaddrow(sitepages)>
			<cfset querysetcell(sitepages, 'id', siteassets.id[i])>
			<cfset querysetcell(sitepages, 'pagename', siteassets.assetgroupname[i] & ' - ' & siteassets.name[i])>
			<cfset querysetcell(sitepages, 'urlpath', '{{asset[#siteassets.id[i]#]}}')><!---/docs/assets/' & siteassets.filename[i])>	--->				
		</cfloop>
		
		<cfset jslist = model.getJSPageList(sitepages)>

		<cfcontent reset=true type="text/javascript;charset=UTF-8"><cfoutput>#jslist#</cfoutput>
		<cfabort>
	</cffunction>
	
	<cffunction name="showJSImageList">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var jslist = ''>
		<cfset var model = getTinyMceModel(arguments.requestObject, arguments.userObj)>
		<cfset var siteimages = dispatcher.callExternalModuleMethod('assets','getAvailableAssets', arguments.requestObject, arguments.userobj)>
		
		<cfset jslist = model.getJSImageList(siteimages)>

		<cfcontent reset=true type="text/javascript;charset=UTF-8"><cfoutput>#jslist#</cfoutput>
		<cfabort>
	</cffunction>
    
    <cffunction name="getStyle">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var d = "">

        <cfhttp method="get" result="d" url="#userobj.getcurrentsiteurl()##requestObject.getformurlvar('file')#">

		<cfcontent reset="true"><cfoutput>#d.filecontent#</cfoutput>
		<cfabort>
	</cffunction>
	
</cfcomponent>