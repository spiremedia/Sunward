<cfcomponent name="page" output="false">

	<cffunction name="init" output="false">
		<cfargument name="pageInfo" required="true">
		<cfargument name="requestObject" required="true">
		
		<cfset variables.requestObject = arguments.requestObject>

		<cfif 	NOT ispreview() 
				AND isdefined("arguments.pageinfo.relocate") 
				AND len(arguments.pageinfo.relocate)>
			<cflocation url="#arguments.pageinfo.relocate#" addtoken="no">
		</cfif>
        		
		<!--- is page is expired, show alternate --->
		<cfif isdefined("arguments.pageinfo.expired") AND arguments.pageinfo.expired>
			<cfset variables.pageinfo.template="_blank">
			<cfset variables.pageinfo.title = "Page is Expired">
			<cfset variables.pageinfo.description = "Page is Expired">
			<cfset variables.pageinfo.keywords = "Page is Expired">
			<cfset addObjectByModulePath("oneContent", "htmlContent", "This page is expired.")>
			<cfset showpage()>
			<cfabort>
		</cfif>
		
		<cfset variables.pageInfo = arguments.pageInfo>
		<cfparam name="arguments.pageInfo.parentid" default="0">
		<cfparam name="arguments.pageInfo.backgroundimage" default="">
		<cfset variables.queriedObjects = structnew()>
		<cfset variables.pageobjects = structnew()>
		<cfparam name="variables.pageInfo.is404" default="false">
		<cfparam name="variables.pageInfo.memberTypes" default="">
        <cfif (NOT structkeyexists(variables.pageinfo, "description") OR variables.pageinfo.description EQ "")
			AND requestObject.isVarSet("defaultdescription")>
        	<cfset variables.pageinfo.description = requestObject.getVar("defaultdescription")>
        </cfif>
        <cfif (NOT structkeyexists(variables.pageinfo, "keywords") OR variables.pageinfo.keywords EQ "")
			AND requestObject.isVarSet("defaultkeywords")>
        	<cfset variables.pageinfo.keywords = requestObject.getVar("defaultkeywords")>
        </cfif>
		
		<cfset checkPageRestrictions()>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="checkPageRestrictions">
		<cfif NOT ispreview() AND isPageRestricted()>
			<!--- if user not logged in --->
			<cfif NOT requestObject.getUserObject().isloggedin()>
				<cflocation url="/Users/Login/?ReturnPage=/#requestObject.getformurlvar('path')#" addtoken="no"><cfabort>
			</cfif>
			<!--- if user does not have correct permissions --->
			<cfif NOT isAccessAuthorized()>
				<cflocation url="/Users/AccessDenied/" addtoken="no"><cfabort>
			</cfif>
		</cfif>
	</cffunction>
	
	<cffunction name="preObjectLoad" output="false">
		<!--- do nothing, can be used by inheriting classes --->
	</cffunction>
	
	<cffunction name="postObjectLoad" output="false">
		
		<!--- do nothing, can be used by inheriting classes --->
	</cffunction>
	
	<cffunction name="getbreadcrumbs" output="false">
		<cfparam name="variables.pageinfo.breadcrumbs" default="">
		<cfreturn variables.pageinfo.breadcrumbs>
	</cffunction>
	
	<cffunction name="getField" output="false">
		<cfargument name="fieldname" required="true">
		<cfif not structkeyexists(variables.pageinfo, fieldname)>
			<cfthrow message="field '#fieldname#' not set in pageinfo">
		</cfif>
		<cfreturn variables.pageinfo[fieldname]>
	</cffunction>
    
    <cffunction name="setField" output="false">
		<cfargument name="fieldname" required="true">
        <cfargument name="value" required="true">
		
		<cfset variables.pageinfo[fieldname] = value>
	</cffunction>
	
	<cffunction name="getSiteMap" output="false">
		<cfif not structkeyexists(variables, 'sitemap')>
			<cfset variables.sitemap = createObject('component','resources.sitemap').init(variables.requestObject, this)>
		</cfif>
		<cfreturn variables.sitemap>
	</cffunction>
	
	<cffunction name="loadObjects" output="false">
		<!--- 
		page content objects get loaded here.  
		Use the module object to get all required ones deduced from the template. 
		Then combine with data from getObjects query
		--->
		<cfargument name="views" required="true">
		<cfargument name="modules" required="true">
		<!--- <cfdump var="#pageInfo.template#" label="blah"><cfabort> --->

		<cfset var requiredObjects = views.getView(pageInfo.template)>
		<cfset var existingObjects = setQueryData()>

		<cfloop query="requiredObjects">
			<!-- if there is a content object with the correct name in the queried objects -->
			<cfif structkeyexists(queriedobjects, requiredObjects.name)>
				<cfset addObject(	queriedobjects[requiredObjects.name].id,
									name, 
									modules.getModule(	module = queriedobjects[requiredObjects.name].module, 
														requestObject = variables.requestObject, 
														parameterList = parameterList,
														pageref = this,
														possiblemodules = requiredobjects.modulename,
														data = queriedobjects[requiredObjects.name].data,
														name = name ) )>
			<!-- if there is no content object for an editable spot, then give the blank editable module -->
			<cfelseif structkeyexists(parameterlist,'editable')>
				
				<cfset addObject(	'',
									name, 
									modules.getModule(	module = 'blankeditable', 
														requestObject = variables.requestObject, 
														parameterList = parameterList,
														pageref = this,
														possiblemodules = requiredobjects.modulename,
														name = name) )>
			<!-- Last case, this should be a default object like navigation or breadcrumbs -->
			<cfelse>
				<cfset addObject(	'',
									name, 
									modules.getModule(	module = modulename, 
														requestObject = variables.requestObject, 
														parameterList = parameterList,
														pageref = this,
														possiblemodules = requiredobjects.modulename,
														name = name ) )>
			</cfif>
		</cfloop>

	</cffunction>
	
	<cffunction name="addObject" output="false">
		<cfargument name="id">
		<cfargument name="name">
		<cfargument name="obj">
		<cfset variables.pageobjects[name] = structnew()>
		<cfset variables.pageobjects[name].obj = arguments.obj>
		<cfset variables.pageobjects[name].id = arguments.id>
	</cffunction>
	
	<cffunction name="addObjectByModulePath" output="false">
		<cfargument name="name" required="true">
		<cfargument name="pathName" required="true">
		<cfargument name="data" default="#structnew()#">

		<cfset variables.pageobjects[name] = structnew()>
		<cfset variables.pageobjects[name].id = "">
		<cfset variables.pageobjects[name].obj = createObject('component','modules.#arguments.pathName#.controller').init(data = arguments.data, requestObject = variables.requestObject, pageRef = this)>
	</cffunction>
	
	<cffunction name="getObject" output="false">
		<cfargument name="name">
		<cfreturn variables.pageobjects[name].obj>
	</cffunction>
	
	<cffunction name="getObjectId" output="false">
		<cfargument name="name">
		<cfreturn variables.pageobjects[name].id>
	</cffunction>
	
	<cffunction name="showContentObject" output="false">
		<cfargument name="name" required="true">
		<cfargument name="module" required="true">
		<cfargument name="parameterlist" default="">
		
		<cfset var html = "">
		<cfset var json = "">

		<cfinvoke component="#getObject(name)#" method="showhtml" returnvariable="html"></cfinvoke>
		
		<cfif ispreview('edit') AND html EQ '' AND find('editable', arguments.parameterlist)>
			<cfset html = '<span class="myhint">#name#</span>'>
		</cfif>
		
		<cfif find('editable', arguments.parameterlist) AND ispreview('edit')>
			<cfset json = createObject('component', 'utilities.json').encode(arguments)>
			<cfset html = '#chr(13)##chr(10)##chr(13)##chr(10)#<input class="contentObjectMarker" id="#getObjectId(name)#" type="hidden" name="#arguments.name#" value=''#json#''>' & html & '&nbsp;'>
		</cfif>
		
		<cfreturn html>
	</cffunction>
	
	<cffunction name="ContentObjectNotEmpty" output="false">
		<cfargument name="name" required="true">
		<cfif ispreview('edit')>
			<cfreturn true>
		</cfif>
		<cfreturn variables.pageObjects[name].obj.notEmpty()>
	</cffunction>
	
	<cffunction name="setQueryData">
		<cfset var q ="">
		<cfset var jsonobj = createObject('component','utilities.json')>
		<cfset var me = "">
		<cfset var membertype = "">
		
		<cfif ispreview() AND requestObject.isFormUrlVarSet('showMemberType')>
			<cfset membertype = requestObject.getFormUrlVar('showMemberType')>
		<cfelse> 
			<cfset membertype = requestObject.getUserObject().getMemberType()>
		</cfif>
		
		<cfif structkeyexists(pageinfo, 'id')>
			<cfset me = getSiteMap().getPageObjects(
					pageid = getPageId(),
					ispreview = ispreview(),
					memberType = memberType)>
				
			<cfoutput query="me" group="name">
				<!--- structure will already exist if content area exists for a marketing group, without this if, content would only be shown for default --->
				<cfif NOT structKeyExists(queriedobjects, name)>
					<cfset queriedobjects[name] = structnew()>
					<!--- htmlcontent and simplecontent are published as straight content, not json --->
					<cfif left(data,1) EQ "{">
						<cfset queriedobjects[name].data = jsonobj.decode(data)>
					<cfelse>
						<cfset queriedobjects[name].data = data>
					</cfif>
					<cfset queriedobjects[name].id = id>
					<cfset queriedobjects[name].module = module>
					<cfset queriedobjects[name].name = name>
				</cfif>
			</cfoutput>
		</cfif>
	</cffunction>
    	
	<cffunction name="getQueryData">
		<cfargument name="name">
		<cfif NOT structkeyexists(variables.queriedobjects,name)>
			<cfreturn "">
		<cfelse>
			<cfreturn variables.queriedobjects[name]>
		</cfif>
	</cffunction>
	
	<cffunction name="showPage">
    	<cfset var lcl = structnew()>
		<cfinclude template="../views/#variables.pageinfo.template#/index.cfm">
       
		<cfif ispreview()> 
            <link rel="stylesheet" href="/ui/esm/esm.css" />
            <script src="/ui/esm/jquery.esmclick.js"></script>
			<script type="text/javascript">
				$(function(){ 
					<cfif requestObject.isFormUrlVarSet("preview") AND requestObject.getFormUrlVar("preview") EQ "edit">
						$('a').click(function(){return false});
					<cfelse>
						$('a').attr("target","_blank");//click(function(){return false});
					</cfif>
					$('.contentObjectMarker').parent().hover(function(){
						$(this).addClass("contentObject-edit");
					},function(){
						$(this).removeClass("contentObject-edit");
					});
					<cfoutput>$('.contentObjectMarker').esmclick({link:'#variables.requestObject.getVar('cmslocation')#contentLink/|action|/?pageid=#variables.getPageId()#&siteid=#variables.requestObject.getVar('siteid')#'});</cfoutput>
				});  
			</script>
		</cfif>
	</cffunction>
	
	<cffunction name="getMainMenu">
		<cfreturn variables.getSiteMap().getMainMenu()>
	</cffunction>
	
	<cffunction name="getSiblingPages">
		<cfreturn variables.getSiteMap().getSiblingPages()>
	</cffunction>
	
	<cffunction name="getChildPages">
		<cfargument name="id" default="#getPageId()#">
		<cfreturn variables.getSiteMap().getChildPages(arguments.id)>
	</cffunction>
    
    <cffunction name="getSectionPages">
		<cfreturn variables.getSiteMap().getSectionPages(gettoppageid())>
	</cffunction>
    
    <cffunction name="getSectionChildPages">
		<cfreturn variables.getSiteMap().getSectionPages(gettoppagechildid())>
	</cffunction>
	
	<cffunction name="getDHTMLnav">
		<cfargument name="id" required="no" default="">
		<cfreturn variables.getSiteMap().getDHTMLNav(arguments.id)>
	</cffunction>
	
	<cffunction name="gettoppageid" output="false">
		<cfset var lcl = structnew()>
		<cfset lcl.breadcrumbs = getbreadcrumbs()>
		<cfset lcl.breadcrumbs = listtoarray(lcl.breadcrumbs,"|")>
		<cfif arraylen(lcl.breadcrumbs) gt 1>
			<cfreturn gettoken(lcl.breadcrumbs[2],2,"~")>
		</cfif>
		<cfreturn getPageId()>
	</cffunction>
	
	<cffunction name="gettoppagechildid" output="false">
		<cfset var lcl = structnew()>
		<cfset lcl.breadcrumbs = getbreadcrumbs()>
		<cfset lcl.breadcrumbs = listtoarray(lcl.breadcrumbs,"|")>
		<cfif arraylen(lcl.breadcrumbs) gt 2>
			<cfreturn gettoken(lcl.breadcrumbs[3],2,"~")>
		</cfif>
		<cfreturn ''>
	</cffunction>
	
	<cffunction name="getPageId" output="false">
		<cfparam name="variables.pageinfo.id" default="">
		<cfreturn variables.pageinfo.id>
	</cffunction>
	
	<cffunction name="ispreview">
    	<cfargument name="previewtype" default="any">
		
		<cfif NOT variables.requestObject.isformurlvarset('preview')>
			<cfreturn false>
		</cfif>
        
        <cfif NOT isIPSafe(ip = CGI.REMOTE_ADDR)>
			<cfreturn false>
        </cfif>
        
        <cfif previewtype EQ 'any' AND variables.requestObject.isformurlvarset('preview')>
        	<cfreturn true>
        </cfif>
        
        <cfif listfind('edit,view', variables.requestObject.getformurlvar('preview')) 
			AND previewtype EQ variables.requestObject.getformurlvar('preview')>
        	<cfreturn true>
        </cfif>
        
        <cfreturn false>
	</cffunction>
	
    <cffunction name="isIPSafe">
		<cfargument name="ip" required="true">  
        <cfset var qry = "">
        
        <cfif isdefined("variables.checkedSafeIp")>
        	<cfreturn variables.checkedSafeIp>
        </cfif>

		<cfquery name="qry" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT COUNT(*) cnt FROM securityIPs
			WHERE 
				ip = <cfqueryparam value="#arguments.ip#" cfsqltype="cf_sql_varchar">
				AND (
						(
							accessDate >= DATEADD ( d , -1, getDate() ) 
							AND usertype = 'User'
						)
					OR 
						usertype = 'System'
					)
		</cfquery>
        
        <cfset variables.checkedSafeIp = qry.cnt>

        <cfreturn qry.cnt>
    </cffunction>
	
	<cffunction name="set404">
		<cfargument name="send">
		<cfset setField('is404', send)>
	</cffunction>
	
	<cffunction name="is404">
		<cfreturn getField('is404')>
	</cffunction>
    
    <cffunction name="getCacheLength">
		<cfset var len = 100000>
		<cfset var itm = "">
		<cfset var locallen = 0>
		<cfset var debugstr = "">
		<cfloop collection="#variables.pageobjects#" item="itm">
			<cftry>
				<cfset locallen = variables.pageobjects[itm].obj.getCacheLength()>
				<!--- <cfset debugstr = debugstr & " " & variables.pageobjects[itm].name & " = " & locallen & "<br>"> --->
				<cfcatch>
					<cfoutput>item in ""#itm#"" has issue or does not have getCacheLength function</cfoutput>
					<cfabort>
				</cfcatch>
			</cftry>
			<cfif locallen EQ 0>
				<cfreturn 0>
			</cfif>
			<cfif locallen LT len>
				<cfset len = locallen>
			</cfif>
		</cfloop>
		<cfreturn len>
	</cffunction>
	
	<cffunction name="isPageRestricted">
		<cfif listLen(pageinfo.memberTypes)>
        	<cfreturn true>
		</cfif>        
        <cfreturn false>
	</cffunction>
	
	<cffunction name="isAccessAuthorized">			
		<cfloop list="#pageinfo.memberTypes#" index="i">
			<cfif ListFindNoCase(requestObject.getUserObject().getMemberType(),i)>
				<cfreturn true>
			</cfif>
		</cfloop>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="dump">
		<cfset var m = structnew()>
		<cfset m.page = pageInfo>
		<cfset m.queriedObjects = queriedObjects>
		<cfset m.pageobjects = pageObjects>
		<cfdump var=#m#><cfabort>
	</cffunction>
	
</cfcomponent>