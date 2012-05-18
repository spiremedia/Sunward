<cfcomponent name="Pages" extends="resources.abstractcontroller">
	
	<cffunction name="getPagesModel">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset mdl = createObject('component','pages.models.pages').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','pages.models.esmmenustatemgr').init(arguments.requestObject, arguments.userObj))>
		<cfset mdl.attachObserver(createObject('component','pages.models.clientstatemgr').init(arguments.requestObject, arguments.userObj))>	
		<cfset mdl.attachObserver(createObject('component','pages.models.logs').init(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
	
	<cffunction name="getLogObj">
		<cfargument name="requestObject">
		<cfargument name="userObj">

		<cfreturn createObject('component','pages.models.logs').init(arguments.requestObject, arguments.userObj)>
	</cffunction>
	
	<cffunction name="getWorkflowModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','pages.models.workflow').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','pages.models.logs').init(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
    
    <cffunction name="getContentReversionModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','pages.models.reversion').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','pages.models.logs').init(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
	
	<cffunction name="StartPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var pagemodel = getPagesModel(requestObject, userobj)>
		<cfset var logs = createObject('component','pages.models.logs').init(requestObject, userobj)>

		<cfset displayObject.setData('list', pagemodel.getPages('accordion', 'published', "", dispatcher.getPersistence()))>
		<cfset displayObject.setData('recentActivity', logs.getRecentHistory(userobj))>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="addPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var persist = dispatcher.getPersistence()>
		<cfset var views = "">
		<cfset var viewquery = querynew('value,label')>
		<cfset var imagequery = querynew('value,label')>
		<cfset var viewitem = "">
		<cfset var model = getPagesModel(requestObject, userobj)>
		<cfset var workflow = getWorkflowModel(requestObject, userobj)>
		<cfset var logs = getlogObj(argumentcollection = arguments)>
		<cfset var viewname = 'views-' & arguments.userobj.getCurrentSiteId()>
		<cfset var viewlist = "">	
		<!---<cfset displayObject.setData('securityItems', dispatcher.getSecurityItems())>--->

		<cfset displayObject.setData('userobj', userobj)>
		<cfset displayObject.setData('availableUsers', dispatcher.callExternalModuleMethod('users','getAvailableUsers', requestObject, userobj) )>		
		<cfset displayObject.setData('availablePages', model.getPages(frmt='optionsQuery',map='staged',startid=userobj.getLocationTopAllowedParentID()) )>

		<!--- if views havent been loaded into application, reload them --->
       
		<cfif NOT persist.isvarset('viewname')>
			<cftry>
            
			<cfset views = createObject('component', 'resources.clientTemplates').init(requestObject, userobj).get()>
			<cfset persist.setVar(viewname, views)>

			<cfcatch>
				<cfoutput>
				Trying to get views at #arguments.userobj.getCurrentSiteUrl()#views/getViews.cfm<br>
				Found <cfdump var=#views#>
<cfdump var="#cfcatch#">
				</cfoutput>
				<cfabort>
			</cfcatch>
			</cftry>
		<cfelse>
			<cfset views = persist.getvar('views')>
		</cfif>
        
        <cfset viewlist = listsort(Structkeylist(views), 'text')>
		
		<cfloop list="#viewlist#" index="viewitem">
			<cfset queryaddrow(viewquery)>
			<cfset querysetcell(viewquery, 'value', viewitem)>
			<cfset querysetcell(viewquery, 'label', replace(viewitem, "_", " ", "ALL"))>
		</cfloop>	
	
		<cfset displayObject.setData('views', viewquery)>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		<cfset displayObject.setData('memberTypes', dispatcher.callExternalModuleMethod('sitemembers','getAvailableMemberTypes', requestObject, userobj) )>
       
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('isreviseable', workflow.isPageReviseable(requestObject.getformurlvar('id'), userobj))>
			<cfset displayObject.setData('page', model.loadPage(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('id',requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('list', model.getPages('accordion', 'published', requestObject.getformurlvar('id'), dispatcher.getPersistence()))>
			<cfset displayObject.setData('itemhistory', logs.getItemHistory(requestObject.getformurlvar('id')))>
			<cfif requestObject.isFormUrlVarSet('page')>
				<cfset displayObject.setWidgetOpen('mainContent','2,7')>
			<cfelse>
				<cfset displayObject.setWidgetOpen('mainContent','2')>
			</cfif>
			<!--- check if user has permissions to access page 
			 superusers always have access 
			 rootallowed users always have access 
			 page restricted users should only be allowed to see top restricted page and it's descendents
			 --->
			<cfif not (userobj.isSuper() OR userobj.isPathAllowed("") OR userobj.isDescendentPathAllowed(displayObject.getData('page').getpath()))>
					You do not have sufficient privileges to view this page.<cfabort>
			</cfif>
			
		<cfelse>
			<cfset displayObject.setData('page', model.getNewPage())>
			<cfset displayObject.setData('id', 0)>
			<cfset displayObject.setData('list', model.getPages('accordion', 'published', "", dispatcher.getPersistence()))>
			<cfset displayObject.setWidgetOpen('mainContent','1')>
		</cfif>
	
		<cfif requestObject.isformurlvarset('search')>
			<cfset displayObject.setData('search', 
				model.search(
					requestObject.getformurlvar('search')))>
		</cfif>

		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('maincontent')>
		
		<cfreturn displayObject>
		
	</cffunction>
	
	<cffunction name="editPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addPage(displayObject,requestObject,userobj,dispatcher)>
	</cffunction>
	
	<cffunction name="SavePage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var page = "">
		<cfset var requestvars = "">
		<cfset var workflow = getWorkflowModel(requestObject, userobj)>
		<cfset var updatedpage = "">
		
		<cfif requestObject.isformurlvarset('id')>
			<cfset page = getPagesModel(requestObject, userObj).loadPage(requestObject.getformurlvar('id'), 'staged')>
		<cfelse>
			<cfset page = getPagesModel(requestObject, userObj).init(requestObject, userobj).newPage(requestObject,'staged')>
		</cfif>

		<cfset requestvars = requestobject.getallformurlvars()>

		<cfset page.setValues(requestVars)>
			
		<cfset vdtr = page.validate()>

		<cfif vdtr.passvalidation()>
		
			<cfset lcl.id = page.save()>
			<cfset lcl.msg = structnew()>
			
			<cfif requestObject.isformurlvarset('publish')>
				<cfset vdtr = page.validatePublish()>
				
				<cfif vdtr.passValidation()>
					<cfset page.publish()>
					<cfset workflow.setPublished(requestObject.getformurlvar('id'), userobj)>
				<cfelse>
					<cfset lcl.msg.validation = vdtr.getErrors()>
					<cfset displayObject.sendJson( lcl.msg )>
				</cfif>
			</cfif>
			
			<cfif requestObject.getformurlvar('id') EQ 0 OR requestObject.getformurlvar('id') EQ ""><!-- if adding refresh the page so that we get the new form -->
				<cfset lcl.msg.message = "Page Added, Reloading">
				<cfset lcl.msg.relocate = "/Pages/editPage/?id=#lcl.id#&msg=Page Added, Now in drafts.">
			<cfelse>
				<cfset lcl.msg.message = "Page Updated">
                <cfif requestObject.isformurlvarset('publish')>
                    <cfset lcl.msg.message = lcl.msg.message & " and Published.">
                </cfif>
	
                <cfif requestObject.getFormUrlVar('templateold') NEQ requestObject.getFormUrlVar('template')
					OR requestObject.getFormUrlVar('showdate') NEQ requestObject.getFormUrlVar('showdateold')
					OR requestObject.getFormUrlVar('hidedate') NEQ requestObject.getFormUrlVar('hidedateold')>
					<cfset lcl.msg.resetoldvarsandreloadiframe = 0>
                </cfif>
				
				<cfif requestvars.pageurlold NEQ requestvars.pageurl OR 
					requestvars.pagenameold NEQ requestvars.pagename OR 
					requestObject.getFormUrlVar('parentidold') NEQ requestObject.getFormUrlVar('parentid')>
					<cfset updatedpage = getPagesModel(requestObject, userObj).loadPage(requestObject.getformurlvar('id'), 'staged')>
					<cfset lcl.msg.resetoldvarsandreloadiframe = updatedpage.getPath()>
                </cfif>
                
				<cfset lcl.msg.ajaxupdater = structnew()>
				<cfset lcl.msg.ajaxupdater.url = "/Pages/Browse/?id=#lcl.id#">
				<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
				<cfset lcl.msg.clearvalidation = 1>
			</cfif>
      
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
	</cffunction>
	<!---
	<cffunction name="PublishPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var page = "">
		
		
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="No Id Specified for publishing">
		</cfif>
		
		<cfset page = getPageModel(requestObject, userObject).loadPage(requestObject.getformurlvar('id'), 'staged')>
		
		<cfset vdtr = page.validatePublish()>
		
		<cfif vdtr.passValidation()>
			<cfset page.publish()>
			<cfset workflow.setPublished(requestObject.getformurlvar('id'), userobj)>
			
			<cfset lcl.msg = structnew()>
			
			<cfset lcl.msg.message = "Page Published.">
			<cfset lcl.msg.update = requestObject.getformurlvar('id')>
	
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
	</cffunction>
	--->
	<cffunction name="DraftPages">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var model = createObject('component', 
				'pages.models.pages').init(requestObject, userobj)>
				
		<cfset displayObject.setData('draftpages', model.getDraftPages())>
		<cfset displayObject.setData('list', model.getPages('accordion', 'published', "", dispatcher.getPersistence()))>
			
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('maincontent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="DraftPagesView">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var model = createObject('component', 
				'pages.models.pages').init(requestObject, userobj)>
				
		<cfset displayObject.setData('draftpages', model.getDraftPages())>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>

		<cfset displayObject.renderTemplate('html')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="DeletePage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getPagesModel(requestObject, userobj)>
		<cfset var page = model.loadPage(requestObject.getformurlvar('id'))>
		
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to deletecontentgroup">
		</cfif>

		<cfset vdtr = page.validateDelete()>
		
		<cfif vdtr.passvalidation()>
			<cfset page.deletePage(requestObject.getformurlvar('id'))>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Page has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/Pages/Browse/">
			<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>Page Deleted</div>">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>

	</cffunction>
	
	<cffunction name="Browse">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var model = createObject('component', 
				'pages.models.pages').init(requestObject, userobj)>
						
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>	
			<cfset displayObject.setData('list', model.getPages('accordion', 'published', requestObject.getformurlvar('id'), dispatcher.getPersistence()))>
		<cfelse>
			<cfset displayObject.setData('list', model.getPages('accordion', 'published', "", dispatcher.getPersistence()))>
		</cfif>
	
		<cfset displayObject.renderTemplate('html')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="getPages">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">

		<cfset var model = createObject('component', 
				'pages.models.pages').init(requestObject, userobj)>
						
		<cfreturn model.getPages('optionsQuery','staged')>
	</cffunction>
	
	<cffunction name="getPagebyPath">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="path" required="true">
		<cfargument name="pagestatus" required="false" default="staged">

		<cfset var model = createObject('component', 
				'pages.models.pages').init(requestObject, userobj)>
						
		<cfreturn model.getPagebyPath(arguments.path, arguments.pagestatus)>
	</cffunction>
	
	<cffunction name="getPageChildren">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		

		<cfset var model = createObject('component', 
				'pages.models.pages').init(requestObject, userobj)>
		
		<cfreturn model.getPages('optionsQuery',
								'published', 
								"",
								"",
								requestObject.getVar('startid'))>
	</cffunction>	
	
	<cffunction name="startreview">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var model = getWorkFlowModel(requestObject,UserObj)>
		<cfset var page = getPagesModel(requestObject,UserObj).loadPage(requestObject.getFormUrlVar('id'))>
		<cfset displayObject.setData('pageinfo', page.getPageInfo())>
		<!---><cfset displayObject.setData('securityItems', dispatcher.getSecurityItems())>--->
		<cfset displayObject.setData('pageowners', model.getNextOwner(requestObject.getFormUrlVar('id'), userobj))>

		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('maincontent')>
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="savereview">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var workflow = getWorkFlowModel(requestObject,UserObj)>
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		
		<cfset vdtr.notblank('reviewerid', requestObject.getFormUrlVar('reviewerid'), "The Reviewier is required")>
		<cfset vdtr.lengthbetween('comments', 1, 255, requestObject.getFormUrlVar('comments'), "A Comment is required and should be less than 255 chars. It is currently #len(requestObject.getFormUrlVar('comments'))# chars.")>			
		
		<cfif vdtr.passValidation()>
			<cfset workflow.startReview(pageid = requestObject.getFormUrlVar('pageid'),
									targetUserId = requestObject.getFormUrlVar('reviewerid'),
									comment = requestObject.getFormUrlVar('comments'),
									userobj = arguments.userobj)>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "Request for Review Sent!">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
	</cffunction>
	
	<cffunction name="startrevise">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var model = getWorkFlowModel(requestObject,UserObj)>
		<cfset var page = getPagesModel(requestObject,UserObj).loadPage(requestObject.getFormUrlVar('id'))>
		<cfset displayObject.setData('pageinfo', page.getPageInfo())>
		<!---><cfset displayObject.setData('securityItems', dispatcher.getSecurityItems())>--->
		
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('maincontent')>
		<cfreturn displayObject>
	</cffunction>
		
	<cffunction name="saverevise">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var workflow = getWorkFlowModel(requestObject,UserObj)>
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		
		<cfset vdtr.lengthbetween('comments', 1, 255, requestObject.getFormUrlVar('comments'), "A Comment is required and should be less than 255 chars. It is currently #len(requestObject.getFormUrlVar('comments'))# chars.")>			
		
		<cfif vdtr.passValidation()>
			<cfset workflow.startRevise(pageid = requestObject.getFormUrlVar('pageid'),
									comment = requestObject.getFormUrlVar('comments'),
									userobj = arguments.userobj)>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "Feedback Sent!">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
	</cffunction>
	
	<cffunction name="reviewablePages">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var workflowmodel = getWorkFlowModel(requestObject, userObj)>
		<cfset var pagesmodel = getPagesModel(requestObject, userObj)>
		
		<!---><cfset displayObject.setData('securityItems', dispatcher.getSecurityItems())>--->
		<cfset displayObject.setData('reviewables', workflowmodel.getReviewables(userobj.getUserId(), userobj))>
		<cfset displayObject.setData('list', pagesmodel.getPages('accordion', 'published', "", dispatcher.getPersistence()))>
		
		<cfset displayObject.setData('requestObj', arguments.requestObject)>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('maincontent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="reviseablePages">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var workflowmodel = getWorkFlowModel(requestObject, userObj)>
		<cfset var pagesmodel = getPagesModel(requestObject, userObj)>
		
		<!---><cfset displayObject.setData('securityItems', dispatcher.getSecurityItems())>--->
		<cfset displayObject.setData('reviseables', workflowmodel.getReviseables(userobj.getUserId(), userobj))>
	
		<cfset displayObject.setData('list', pagesmodel.getPages('accordion', 'published', "", dispatcher.getPersistence()))>
		
		<cfset displayObject.setData('requestObj', arguments.requestObject)>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('maincontent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="moveupdown">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var lcl = structnew()>
		<cfset var pagesmodel = getPagesModel(requestObject, userObj)>
		<cfset var id = requestObject.getFormUrlVar('id')>
		<cfset var page = pagesmodel.loadPage(id)>
		<cfset var dir = requestObject.getFormUrlVar('dir')>

		<cfset page.moveUpDown(dir)>
	
		<cfset lcl.msg = structnew()>
		<cfset lcl.msg.message = "Page Moved #dir#.">
				
		<cfset lcl.msg.ajaxupdater = structnew()>
		<cfset lcl.msg.ajaxupdater.url = "/Pages/Browse/?id=#id#">
		<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
		<cfset lcl.msg.clearvalidation = 1>
		
		<cfset displayObject.sendJson( lcl.msg )>
	</cffunction>
	
	<cffunction name="pageSearch">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var pagemodel = getPagesModel(arguments.requestObject, arguments.userObj)>
		
		<cfset displayObject.setData('list', pagemodel.getPages('accordion', 'published', "", dispatcher.getPersistence()))>
		<cfset displayObject.setData('searchResults', pagemodel.searchPages(arguments.requestObject.getFormUrlVar('searchkeyword')))>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		<cfset displayObject.setData('userobj', arguments.userobj)>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
    
    <cffunction name="pageviewframeset">
    	<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
        
		<cfset displayObject.setData('page', getPagesModel(requestObject, userObj).loadPage(requestObject.getformurlvar('id')))>
        
        <cfset displayObject.renderTemplate('html')>
        
        <cfreturn displayObject>
    </cffunction>
    
    <cffunction name="pageviewframetop">
    	<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
        <cfargument name="dispatcher" required="true">
        
       
        <cfset displayObject.setData('memberTypes', dispatcher.callExternalModuleMethod('siteMembers','getAvailableMemberTypes', requestObject, userobj) )>
        <cfset displayObject.renderTemplate('html')>
        
        <cfreturn displayObject>
    </cffunction>
<cffunction name="keywordanalysis">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var msg = structnew()>
        
        <cfset var model = getPagesModel(requestObject, userObj)>
     	<cfset var page = model.loadPage(requestObject.getformurlvar('id'))>
        <cfset var http = getUtility("http").init()>
		<cfset var words = getUtility("wordparser").init()>
        <cfset var html = "">
        <cfset var miscdata = createObject("component", "resources.miscdata").init(requestObject)>
        <cfset var keyphrases = miscdata.getItem("keyphrases")>
        
		<cfset lcl.link = userobj.getCurrentSiteUrl() & page.getPath() & "?preview=view&showmembertype=default">
        <cfset html = http.getPage(lcl.link)>

		<cfset html = rereplace(html, "<head[^>]*?>.*?</head>"," ","all")><!--- remove stuff between head tags code --->
		<cfset html = rereplace(html, "<script[^>]*?>.*?</script>"," ","all")><!--- remove <style>...</style> --->
        <cfset html = rereplace(html, "<style[^>]*?>.*?</style>"," ","all")><!--- remove <select>...</select> --->
		<cfset html = rereplace(html, "<[^>]+>"," ","all")>
        <cfset html = rereplace(html, "[\n\r\s]+"," ","all")>
        
        <cfloop list="#keyphrases#" delimiters="#chr(13)##chr(10)#" index="lcl.itm">
			<cfset words.addPhrase(trim(lcl.itm))>
            <cfset words.foundWord(trim(lcl.itm), 0)>
        </cfloop>
        
        <cfset words.loadString(html)>
       
        <cfset words = words.getWords()>
		<cfquery name="words" dbtype="query">
        	SELECT * FROM words 
            ORDER BY cnt DESC , word
        </cfquery>
        
        <cfsavecontent variable="lcl.html">
            <table class="list"><thead><tr><th>Word</th><th>Count</th><th>%</th><th>Word</th><th>Count</th><th>%</th><th>Word</th><th>Count</th><th>%</th></tr></thead>
			<cfoutput query="words">
            	<cfif currentrow mod 3 EQ 1>
                	<tr>
				</cfif>
             	<td<cfif listfindnocase(keyphrases, word, "#chr(13)##chr(10)#")> style="font-weight:bold;color:red"</cfif>>#word#</td><td>#cnt#</td><td>#pct#</td>
                <cfif currentrow mod 3 EQ 0>
					</tr>
				</cfif>
            </cfoutput>
            </table>
        </cfsavecontent>
        <cfset lcl.html = rereplace(lcl.html, "[\n\f\r\s]", " ","all")>
        <cfset msg.htmlupdater = structnew()>
        <cfset msg.htmlupdater.id = 'analysis'>
        <cfset msg.htmlupdater.html = lcl.html>
		<cfset displayObject.sendJson(msg)>
	</cffunction>
    
    
	<cffunction name="contentReversion">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var reversion = getContentReversionModel(requestObject,UserObj)>
		<cfset var pagemodel = getPagesModel(arguments.requestObject, arguments.userObj)>
		
		<cfset displayObject.setData('list', pagemodel.getPages('accordion', 'published', "", dispatcher.getPersistence()))>
		<cfset displayObject.setData('publishedpageslist', reversion.getPublishInstances() )>
		<cfset displayObject.setData('availablePages', pagemodel.getPages(frmt='optionsQuery',map='staged',startid=userobj.getLocationTopAllowedParentID()) )>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="getOldReverteableObjects">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var reversion = getContentReversionModel(requestObject,UserObj)>
		<cfset var pagemodel = getPagesModel(arguments.requestObject, arguments.userObj)>
		<cfset var lcl = structnew()>
		
		<cfset displayObject.setData('list', pagemodel.getPages('accordion', 'published', "", dispatcher.getPersistence()))>
		<cfset lcl.revertableObjects = reversion.getRevertableItemsByArchiveId(arguments.requestObject.getFormUrlVar('publishedpagearchiveid'))>
		
		<cfset lcl.msg = structnew()>
		<cfset lcl.msg.availableitems.items = arraynew(1)>
		<cfloop query="lcl.revertableObjects">
			<!---<cfset lcl.itm = {id=#id#,templateSpot="#name#",module="#module#",membertype="#membertype#"}>--->
			<cfset lcl.itm.id = id>
			<cfset lcl.itm.templateSpot = name>
			<cfset lcl.itm.module = module>
			<cfset lcl.itm.membertype = membertype>
			<cfset arrayappend(lcl.msg.availableitems.items, lcl.itm)>
		</cfloop>
		<cfset displayObject.sendJson( lcl.msg )>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="showRevertableContent">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfhttp method="get" url="#userObj.getCurrentSiteUrl()#system/reversionObjectView/?id=#requestObject.getFormUrlVar('id')#" result="lcl.r">

		<cfif lcl.r.statuscode EQ "200 OK">
			<cfset displayObject.showHTML(lcl.r.filecontent)>
		<cfelse>
			<cfset displayObject.showHTML("The content could not be shown")>
		</cfif>
		
	</cffunction>
	
	<cffunction name="getRevertibleTargetList">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var reversionModel = getContentReversionModel(requestObject,UserObj)>
		<cfset var viewlist = "">
		<cfset var revertableItem = reversionModel.getRevertibleItem(requestObject.getFormUrlVar('revertibleId'))>
		<cfset var persist = dispatcher.getPersistence()>
		<cfset var viewname = 'views-' & arguments.userobj.getCurrentSiteId()>
		<cfset var pagemodel = getPagesModel(arguments.requestObject, arguments.userObj).loadPage(requestObject.getFormUrlVar('targetPageid'))>
		<cfset var pageinfo = pagemodel.getPageInfo()>
		<cfset var loadedPageObjects = pagemodel.getObjects()>
		<cfset var memberTypes = dispatcher.callExternalModuleMethod('siteMembers','getAvailableMemberTypes', requestObject, userobj)>
		<cfset var targetSpotOptions = arraynew(1)>
		<cfset var msg = structnew()>
		
		<cfif persist.isvarset(viewname)>
			<cfset viewlist = persist.getvar(viewname)>
		<cfelse>
			<cfset viewlist = createObject('component', 'pages.models.clientTemplates').init(requestObject, userobj).get()>
			<cfset persist.setVar(viewname, viewlist)>
		</cfif>

		<cfif pageinfo.recordcount EQ 0>
			<cfset displayObject.showHTML("The page did not load properly.")>
		</cfif>
		
		<cfif NOT structkeyexists(viewlist, pageinfo.template)>
			<cfset displayObject.showHTML("The page template was not found in the templates list.")>
		</cfif>

		<cfset viewlist = viewlist[pageinfo.template]>

		<cfset targetSpotOptions = reversionModel.getRevertableTargets(	memberTypes = memberTypes, 
																		viewList = viewlist, 
																		module = revertableItem.module,
																		loadedPageObjects = loadedPageObjects)>
		<!--- <cfloop query="viewlist">
			<cfif structkeyexists(viewlist.parameterlist[currentrow],'editable') 
					AND parameterlist[currentrow]['editable']
					AND listfind(viewlist.modulename, revertableItem.module)>
				<cfset arrayappend(targetSpotOptions, name)>
			</cfif>
		</cfloop> --->
		
		<cfset msg.targetoptions = targetSpotOptions>
		<cfset displayObject.sendJson(msg)>
	</cffunction>
	
	<cffunction name="revertContentAction">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var revisionModel = getContentReversionModel(requestObject,UserObj)>
		<cfset var success = revisionModel.revertItem()>
		<cfset var msg = structnew()>
		<!--- <cfif success.ok> --->
			<cfset msg.revertContentRslt = 1>
		<!--- <cfelse>
			<cfset msg.revertContentRslt = 0>
		</cfif> --->
		<cfset displayObject.sendJson(msg)>
	</cffunction>
    
    <cffunction name="contentDefaults">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var pagemodel = getPagesModel(arguments.requestObject, arguments.userObj)>
		<cfset var site = application.sites.getSite(userObj.getCurrentSiteId())>
        
        <cfif structkeyexists(site, "defaultdescription")>
			<cfset displayObject.setData('defaultdescription', site.defaultdescription )>
        <cfelse>
        	<cfset displayObject.setData('defaultdescription', "" )>
        </cfif>
        
        <cfif structkeyexists(site, "defaultkeywords")>
			<cfset displayObject.setData('defaultkeywords', site.defaultkeywords )>
        <cfelse>
        	<cfset displayObject.setData('defaultkeywords', "" )>
        </cfif>

		<cfset displayObject.setData('list', pagemodel.getPages('accordion', 'published', "", dispatcher.getPersistence()))>
        
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
    
    <cffunction name="updateContentDefaults">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
    	<cfset var pagemodel = getPagesModel(arguments.requestObject, arguments.userObj)>
		<cfset var sites = application.sites.getSite(userObj.getCurrentSiteId())>
        <cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		
		<cfset vdtr.maxlength('defaultkeywords',  500, requestObject.getFormUrlVar('defaultkeywords'), "Keywords should be less than 500 chars. It is currently #len(requestObject.getFormUrlVar('defaultkeywords'))# chars.")>			
		<cfset vdtr.maxlength('defaultdescription',  500, requestObject.getFormUrlVar('defaultdescription'), "Description should be less than 500 chars. It is currently #len(requestObject.getFormUrlVar('defaultdescription'))# chars.")>			
		
		<cfif vdtr.passValidation()>
			<cfset application.sites.updateSiteField(name = 'defaultdescription',
									value = requestObject.getFormUrlVar('defaultdescription'),
									siteid = arguments.userobj.getCurrentSiteId() )>
			<cfset application.sites.updateSiteField(name = 'defaultkeywords',
									value = requestObject.getFormUrlVar('defaultkeywords'),
									siteid = arguments.userobj.getCurrentSiteId() )>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "Items Updated!">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
	</cffunction>
</cfcomponent>