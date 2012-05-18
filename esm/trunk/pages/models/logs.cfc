<cfcomponent name="logobserver">
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		<cfset variables.requestObject = arguments.requestObject>	
		<cfset variables.userObject = arguments.userObject>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getRecentHistory">
		<cfargument name="userObj" required="true">
	
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT description, fname + ' ' + lname fullname, actiondate 
			FROM sitepages_log
			INNER JOIN users ON userid = users.id
			WHERE actiondate > getDate() - 10
			AND siteid = <cfqueryparam value="#userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
			ORDER BY actiondate DESC
		</cfquery>
		
		<cfreturn add>
	</cffunction>
	
	<cffunction name="getItemHistory">
		<cfargument name="id" required="true">
	
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT description, fname + ' ' + lname fullname, actiondate 
			FROM sitepages_log
			INNER JOIN users ON userid = users.id
			WHERE pageid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			ORDER BY actiondate DESC
		</cfquery>
		
		<cfreturn add>
	</cffunction>

	<cffunction name="event">
		<cfargument name="eventname">
		<cfargument name="modelRef">
		<cfargument name="moreInfo">

		<cfswitch expression="#arguments.eventname#">
			<cfcase value="publish page">
				<cfset publishPage(modelref,moreInfo)>
			</cfcase>
			<cfcase value="insert page">
				<cfset insertPage(modelref, moreInfo)>
			</cfcase>
			<cfcase value="update page">
				<cfset updatePage(modelref, moreInfo)>
			</cfcase>
			<cfcase value="delete page">
				<cfset deletePage(modelref, moreInfo)>
			</cfcase>
			<cfcase value="request review">
				<cfset requestReview(modelref, moreInfo)>
			</cfcase>
			<cfcase value="request revise">
				<cfset requestRevise(modelref, moreInfo)>
			</cfcase>
			<cfcase value="updated content object">
				<cfset updatedcontentobject(modelref)>
			</cfcase>
			<cfcase value="added content object">
				<cfset addedcontentobject(modelref)>
			</cfcase>
			<cfcase value="Item Reverted">
				<cfset itemreverted(modelref, moreInfo)>
			</cfcase>
			<cfcase value="page up down">
				<cfset pageupdown(modelref, moreInfo)>
			</cfcase>
			
		</cfswitch>
		
	</cffunction>
	<cffunction name="insertPage">
		<cfargument name="pageref" required="true">
		<cfargument name="moreinfo" required="true">
		
		<cfset var parentpage = createObject('component','pages.models.pages').init(variables.requestObject,variables.userObject).loadPage(moreinfo.parentid).getPageInfo()>
				
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							pageid = moreinfo.id,
							description = 'Added page "#moreinfo.pagename#" under "#parentpage.urlpath#".')>
	</cffunction>
	
	<cffunction name="pageupdown">
		<cfargument name="pageref" required="true">
		<cfargument name="moreinfo" required="true">
		<cfset var dir = "">
		
		<cfif requestObject.isformurlvarset('dir')>
			<cfset dir = requestObject.getFormUrlVar('dir')>
		</cfif>
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							pageid = moreinfo.id,
							description = 'Page, "#moreinfo.urlpath#", moved #dir#.')>
	</cffunction>
	
	<cffunction name="updatePage">
		<cfargument name="pageref" required="true">
		<cfargument name="moreinfo" required="true">
		
		<cfset var page = createObject('component','pages.models.pages').init(variables.requestObject,variables.userObject).loadPage(moreinfo.id).getPageInfo()>
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							pageid = moreinfo.id,
							description = 'Updated page "#page.urlpath#".')>
	</cffunction>
	
	<cffunction name="publishPage">
		<cfargument name="pageref" required="true">
		<cfargument name="moreinfo" required="true">
		
		<cfset var page = createObject('component','pages.models.pages').init(variables.requestObject,variables.userObject).loadPage(moreinfo.id).getPageInfo()>
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							pageid = moreinfo.id,
							description = 'Published page "#page.urlpath#".')>
	</cffunction>
	
	<cffunction name="deletePage">
		<cfargument name="pageref" required="true">
		<cfargument name="moreinfo" required="true">
		
		<cfset var page = createObject('component','pages.models.pages').init(variables.requestObject,variables.userObject).loadPage(moreinfo.id).getPageInfo()>
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							pageid = moreinfo.id,
							description = 'Deleted page "#page.urlpath#".')>
	</cffunction>
	
	<cffunction name="itemreverted">
		<cfargument name="pageref" required="true">
		<cfargument name="moreinfo" required="true">
		
		<cfset var revertinfo = createObject('component','pages.models.reversion').init(variables.requestObject,variables.userObject).getRevertibleItem(moreinfo.revertibleId)>
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							pageid = moreinfo.targetpageid,
							description = 'Reversion to spot "#moreinfo.targetContentObjectName#" from spot "#revertInfo.name#" on page "/#revertinfo.urlpath#" originally published "#dateformat(revertinfo.publisheddatetime,"mm/dd/yy")# #timeformat(revertinfo.publisheddatetime, "hh:mm tt")#".')>
	</cffunction>
	
	<cffunction name="requestReview">
		<cfargument name="pageref" required="true">
		<cfargument name="moreInfo">

		<cfset var sentto = createObject('component','users.models.users').init(variables.requestObject,variables.userObject).getUser(moreinfo.sentto)>
		<cfset var page = createObject('component','pages.models.pages').init(variables.requestObject,variables.userObject).loadPage(moreinfo.pageid).getPageInfo()>
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							pageid = moreinfo.pageid,
							description = 'Sent page "#page.urlpath#" for REVIEW to #sentto.fname# #sentto.lname#.')>
	</cffunction>
	
	<cffunction name="requestRevise">
		<cfargument name="pageref" required="true">
		<cfargument name="moreInfo">
		
		<cfset var sentto = createObject('component','users.models.users').init(variables.requestObject,variables.userObject).getUser(moreinfo.sentto)>
		<cfset var page = createObject('component','pages.models.pages').init(variables.requestObject,variables.userObject).loadPage(moreinfo.pageid).getPageInfo()>
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							pageid = moreinfo.pageid,
							description = 'Sent page "#page.urlpath#" for REVISION to #sentto.fname# #sentto.lname#.')>
	</cffunction>
	
	<cffunction name="updatedContentObject">
		<cfargument name="pageref" required="true">
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							pageid = arguments.pageRef.getField('id'),
							description = 'Updated content Object ## on "#arguments.pageRef.getField('name')#".')>
	</cffunction>
	
	<cffunction name="addedContentObject">
		<cfargument name="pageref" required="true">
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							pageid = arguments.pageRef.getField('id'),
							description = 'Added Content Object ## on "#arguments.pageRef.getField('name')#".')>
	</cffunction>
	
	<cffunction name="insertLog" access="private">
		<cfargument name="userid">
		<cfargument name="pageid">
		<cfargument name="description">
		
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
		INSERT INTO sitepages_log (
			id,
			pageid,
			userid,
			description,
			siteid
		) VALUES (
			<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.pageid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#variables.userObject.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		)
		</cfquery>
	</cffunction>
	
	
</cfcomponent>