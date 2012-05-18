<cfcomponent name="workflow" extends="resources.abstractModel">
	<cffunction name="init">
		<cfargument name="requestObj">
		<cfset variables.requestObj = arguments.requestObj>
		<cfreturn this>
	</cffunction>

	<cffunction name="getNextOwner">
		<cfargument name="pageid" required="true">
		<cfargument name="userObj" required="true">
		<cfset var count = 0>
		<cfset var apage = "">
		<cfset var parents = arraynew(1)>
		<cfset var temp = structnew()>
		<cfset var q = querynew('id,name')>
			
		<cfquery name="apage" datasource="#variables.requestObj.getvar('dsn')#">
			SELECT sitepages.id, 
					ownerid,
					parentid,
					fname,
					lname
			FROM sitepages
			LEFT OUTER  JOIN users ON ownerid = users.id
			WHERE sitepages.id = <cfqueryparam value="#arguments.pageid#" cfsqltype="cf_sql_varchar">
			AND siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#:staged" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif apage.ownerid NEQ "">
			<cfset temp.userid = apage.ownerid>
			<cfset temp.username = apage.fname & ' ' & apage.lname>
			<cfset queryaddrow(q)>
			<cfset querysetcell(q,'id', temp.userid)>
			<cfset querysetcell(q,'name', temp.username)>
		</cfif>
		
		<cfloop condition = "apage.parentid NEQ '' AND COUNT LT 10">
			<cfset count = count + 1>
			
			<cfquery name="apage" datasource="#variables.requestObj.getvar('dsn')#">
				SELECT  sitepages.id, 
						ownerid,
						parentid,
						fname,
						lname
				FROM sitepages
				LEFT OUTER  JOIN users ON ownerid = users.id
				WHERE sitepages.id = <cfqueryparam value="#apage.parentid#" cfsqltype="cf_sql_varchar">
				AND siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#:staged" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfif apage.ownerid NEQ "">
				<cfset temp = structnew()>
				<cfset temp.userid = apage.ownerid>
				<cfset temp.username = apage.fname & ' ' & apage.lname>
				<cfset queryaddrow(q)>
				<cfset querysetcell(q,'id', temp.userid)>
				<cfset querysetcell(q,'name', temp.username)>
			</cfif>
			
		</cfloop>

		<cfreturn q>
	</cffunction>
	
	<cffunction name="getReviewables">
		<cfargument name="userid">
		<cfargument name="userobj">
	
		<cfset var r = "">

		<cfquery name="r" datasource="#variables.requestObj.getvar('dsn')#">
			SELECT 
				sp.id, sp.pagename, sp.urlpath,
				workflow.status, 
				byuser.fname + ' ' + byuser.lname byname, 
				touser.fname + ' ' + touser.lname toname, 
				workflow.comment, 
				workflow.datetime 
			FROM workflow
			INNER JOIN sitepages_view sp ON workflow.pageid = sp.id
			INNER JOIN users byuser ON workflow.initiatedby = byuser.id
			INNER JOIN users touser ON workflow.targetedto = touser.id
			WHERE touser.id = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">
				AND workflow.status = 'review'
				AND sp.siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#:staged" cfsqltype="cf_sql_varchar">
				AND (SELECT COUNT(*) FROM workflow wf2 WHERE wf2.status = 'published' AND wf2.workflowgroupid = workflow.workflowgroupid) = 0
		</cfquery>
		
		<cfreturn r>
	</cffunction>
	
	<cffunction name="isPageReviseable">
		<cfargument name="pageid" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var reviseableinfo = getReviewInfo(pageid, userobj)>
				
		<cfreturn reviseableinfo.recordcount>
	</cffunction>
	
	<cffunction name="setPublished">
		<cfargument name="pageid" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var wfs = getOpenPageWorkflows(pageid, userobj)>
		<cfset var targets = structnew()>
		<cfset var groups = structnew()>
		<cfset var grpid = "">
		<cfset var userid = "">
		
		<cfloop query="wfs">
			<cfset targets[initiatedby] = 1>
			<cfset targets[targetedto] = 1>
			<cfset groups[workflowgroupid] = 1>
		</cfloop>
		
		<cfset structdelete(targets, arguments.userObj.getUserID())>
		
		<cfloop collection="#targets#" item="userid">
			<cfset sendPublishedEmail(sentby = arguments.userObj.getUserID(),
										sentto = userid,
										pageid = arguments.pageid,
										userobj = arguments.userobj)>
		</cfloop>
		
		<cfloop collection="#groups#" item="grpid">
			<cfquery name="r" datasource="#variables.requestObj.getvar('dsn')#">
				INSERT INTO workflow (
					id,
					initiatedby,
					targetedto,
					pageid,
					siteid,
					comment,
					status,
					workflowgroupid
				) VALUES (
					<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.userObj.getUserID()#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam cfsqltype="cf_sql_varchar" null="true">,
					<cfqueryparam value="#arguments.pageid#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#arguments.userobj.getCurrentSiteId()#:staged" cfsqltype="cf_sql_varchar">,
					<cfqueryparam null="true" cfsqltype="cf_sql_varchar">,
					'published',
					<cfqueryparam value="#grpid#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
		</cfloop>
		
	</cffunction>
	
	<cffunction name="sendPublishedEmail">
		<cfargument name="sentby" required="true">
		<cfargument name="sentto" required="true">
		<cfargument name="pageid" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset var user = createObject('component','users.models.users').init(variables.requestObj,arguments.userObj)>
		<cfset var targetuserinfo = "">
		<cfset var recipientuserinfo = "">
		<cfset var page = createObject('component','pages.models.pages').init(variables.requestObj, userobj).loadPage(arguments.pageid)>
		<cfset var email = createObject('component', 'utilities.email').init(requestObj = variables.requestObj)>
		
		<cfset page = page.getPageInfo()>
		
		<cfset email.setSubject('Page Published : #page.pagename#')>
		
		
		<cfset targetuserinfo = user.getUser(sentby)>
		<cfset email.setSender('#targetuserinfo.fname# #targetuserinfo.lname# <#targetuserinfo.username#>')>
		<cfset recipientuserinfo = user.getUser(sentto)>
		<cfset email.setRecipient('#recipientuserinfo.fname# #recipientuserinfo.lname# <#recipientuserinfo.username#>')>
		
		<!--- TODO : setup a module for sending email --->
		<cfset email.setBody("<p>Dear #recipientuserinfo.fname# #recipientuserinfo.lname#,</p>
<p>The page titled #page.pagename# has been sent published by #userObj.getFullName()#.</p>")>
		<cfset email.sendMessage()>
	</cffunction>
	
	<cffunction name="getUserWorkflows">
		<cfargument name="userid">
		<cfargument name="userobj">
		<cfargument name="status">
	
		<cfset var r = "">
		
		<cfquery name="r" datasource="#variables.requestObj.getvar('dsn')#">
			SELECT sitepages.pagename, 
				workflow.status, 
				byuser.fname, byuser.lname, 
				touser.fname, touser.lname, 
				workflow.comment, 
				workflow.datetime 
			FROM workflow wf
			INNER JOIN sitepages ON wf.pageid = sitepages.id
			INNER JOIN users byuser ON initiatedby = byuser.id
			INNER JOIN users touser ON targetedto = to user.id
			WHERE touserid = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">
			AND status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar">
			AND siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#:staged" cfsqltype="cf_sql_varchar">
			AND (SELECT COUNT(*) FROM workflow wf2 WHERE wf2.status = 'published' AND wf2.workflowgroup = wf.workflowgroup) = 0
		</cfquery>
		
		<cfreturn r>
	</cffunction>
	
	<cffunction name="getOpenPageWorkflows">
		<cfargument name="pageid" required="true">
		<cfargument name="userobj" required="true">
	
		<cfset var r = "">
		
		<cfquery name="r" datasource="#variables.requestObj.getvar('dsn')#">
			SELECT 
				initiatedby, targetedto, workflowgroupid
			FROM workflow
			WHERE pageid = <cfqueryparam value="#arguments.pageid#" cfsqltype="cf_sql_varchar">
				AND siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#:staged" cfsqltype="cf_sql_varchar">
				AND (SELECT COUNT(*) FROM workflow wf2 WHERE wf2.status = 'published' AND wf2.workflowgroupid = workflow.workflowgroupid) = 0
		</cfquery>
		
		<cfreturn r>
	</cffunction>
	
	<cffunction name="getReviewInfo">
		<cfargument name="pageid" required="true">
		<cfargument name="userobj" required="true">
	
		<cfset var r = "">
		
		<cfquery name="r" datasource="#variables.requestObj.getvar('dsn')#">
			SELECT 
				workflow.id,
				workflowgroupid,
				initiatedby,
				targetedto
			FROM workflow
			WHERE targetedto = <cfqueryparam value="#arguments.userobj.getuserid()#" cfsqltype="cf_sql_varchar">
				AND workflow.status = 'review'
				AND siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#:staged" cfsqltype="cf_sql_varchar">
				AND (SELECT COUNT(*) FROM workflow wf2 WHERE wf2.status = 'published' AND wf2.workflowgroupid = workflow.workflowgroupid) = 0
		</cfquery>
		
		<cfreturn r>
	</cffunction>
	
	<cffunction name="getReviseables">
		<cfargument name="userid">
		<cfargument name="userobj">
	
		<cfset var r = "">
		
		<cfquery name="r" datasource="#variables.requestObj.getvar('dsn')#">
			SELECT sp.pagename, sp.id, sp.urlpath,
				wf.status, 
				byuser.fname + ' ' + byuser.lname byname, 
				touser.fname + ' ' + touser.lname toname, 
				wf.comment, 
				wf.datetime 
			FROM workflow wf
			INNER JOIN sitepages_view sp ON wf.pageid = sp.id
			INNER JOIN users byuser ON initiatedby = byuser.id
			INNER JOIN users touser ON targetedto = touser.id
			WHERE touser.id = <cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">
			AND wf.status = 'revise'
			AND sp.siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#:staged" cfsqltype="cf_sql_varchar">
			AND (SELECT COUNT(*) FROM workflow wf2 WHERE wf2.status = 'published' AND wf2.workflowgroupid = wf.workflowgroupid) = 0
		</cfquery>
		
		<cfreturn r>
	</cffunction>
	
	<cffunction name="startReview">
		<cfargument name="pageid">
		<cfargument name="targetuserid">
		<cfargument name="comment">
		<cfargument name="userObj">
		
		<cfset var r = "">
		<cfset var wflid = "">
		
		<cfset var alreadystarted = getOpenPageWorkflows(pageid, userobj)>
		
		<cfif alreadystarted.recordcount>
			<cfset wflid = alreadystarted.workflowgroupid>
		<cfelse>
			<cfset wflid = createuuid()>
		</cfif>		
		
		<cfset arguments.sentto = arguments.targetuserid>
	
		<cfset variables.observeEvent('request review', arguments)>
		
		<!--- TODO : check no duplicates --->
		<cfquery name="r" datasource="#variables.requestObj.getvar('dsn')#">
			INSERT INTO workflow (
				id,
				initiatedby,
				targetedto,
				pageid,
				siteid,
				comment,
				status,
				workflowgroupid
			) VALUES (
				<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.userObj.getUserID()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.targetuserid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.pageid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.userobj.getCurrentSiteId()#:staged" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.comment#" cfsqltype="cf_sql_varchar">,
				'review',
				<cfqueryparam value="#wflid#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
		
		<cfset startReviewEmail(startedby = arguments.userObj.getUserID(),
								targetedto = arguments.targetuserid,
								comment = arguments.comment,
								pageid = arguments.pageid,
								userobj = arguments.userobj)>
		
	</cffunction>
	
	<cffunction name="startRevise">
		<cfargument name="pageid">
		<cfargument name="comment">
		<cfargument name="userobj">
		
		<cfset var r = "">
		
		<cfset var reviewinfo = getReviewInfo(pageid, userobj)>
		
		<cfif reviewinfo.recordcount EQ 0>
			<cfthrow message="for start revise in workflow, could not find initial review request.">
		</cfif>
		
		<cfset arguments.sentto = reviewinfo.initiatedby>
		<cfset variables.observeEvent('request revise', arguments)>
		
		<cfquery name="r" datasource="#variables.requestObj.getvar('dsn')#">
			INSERT INTO workflow (
				id,
				initiatedby,
				targetedto,
				pageid,
				siteid,
				comment,
				status,
				workflowgroupid
			) VALUES (
				<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.userObj.getUserID()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#reviewinfo.initiatedby#" cfsqltype="cf_sql_varchar">, 
				<cfqueryparam value="#arguments.pageid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#userobj.getCurrentSiteId()#:staged" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.comment#" cfsqltype="cf_sql_varchar">,
				'revise',
				<cfqueryparam value="#reviewinfo.workflowgroupid#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
		
		<cfset startReviseEmail(startedby = arguments.userObj.getUserID(),
								targetedto = reviewinfo.initiatedby,
								comment = arguments.comment,
								pageid = arguments.pageid,
								userobj = arguments.userobj)>

	</cffunction>
	
	<cffunction name="startreviewemail">
		<cfargument name="startedby">
		<cfargument name="targetedto">
		<cfargument name="comment">
		<cfargument name="pageid">
		<cfargument name="userObj">
		
		<cfset var user = createObject('component','users.models.users').init(variables.requestObj,arguments.userObj)>
		<cfset var targetuserinfo = "">
		<cfset var recipientuserinfo = "">
		<cfset var page = createObject('component','pages.models.pages').init(variables.requestObj, userobj).loadPage(arguments.pageid)>
		<cfset var email = createObject('component', 'utilities.email').init(requestObj = variables.requestObj)>
		
		<cfset page = page.getPageInfo()>
		
		<cfset email.setSubject('Page Needs Reviewing : #page.pagename#')>
		
		<cfset targetuserinfo = user.getUser(startedby)>
		<cfset email.setSender('#targetuserinfo.fname# #targetuserinfo.lname# <#targetuserinfo.username#>')>
		<cfset recipientuserinfo = user.getUser(targetedto)>
		<cfset email.setRecipient('#recipientuserinfo.fname# #recipientuserinfo.lname# <#recipientuserinfo.username#>')>
		
		<!--- TODO : setup a module for sending email --->
		<cfset email.setBody("<p>Dear #recipientuserinfo.fname# #recipientuserinfo.lname#,</p>
<p>The page titled #page.pagename# has been sent to you by #targetuserinfo.fname# #targetuserinfo.lname#.</p>
<p>Please REVIEW it here <a href='#variables.requestObj.getVar('esmurl')#pages/EditPage/?id=#arguments.pageid#'>#variables.requestObj.getVar('esmurl')#pages/EditPage/?id=#arguments.pageid#</a></p>
<p>with comments : #arguments.comment#</p>")>
		<cfset email.sendMessage()>
	</cffunction>
		
	<cffunction name="startreviseemail">
		<cfargument name="startedby">
		<cfargument name="targetedto">
		<cfargument name="comment">
		<cfargument name="pageid">
		<cfargument name="userobj">
		
		<cfset var user = createObject('component','users.models.users').init(variables.requestObj,arguments.userObj)>
		<cfset var targetuserinfo = "">
		<cfset var recipientuserinfo = "">
		<cfset var page = createObject('component','pages.models.pages').init(variables.requestObj, userobj).loadPage(arguments.pageid)>
		<cfset var email = createObject('component', 'utilities.email').init(requestObj = variables.requestObj)>
		
		<cfset page = page.getPageInfo()>
		
		<cfset email.setSubject('Page Needs Revision : #page.pagename#')>
		
		<cfset targetuserinfo = user.getUser(startedby)>
		<cfset email.setSender('#targetuserinfo.fname# #targetuserinfo.lname# <#targetuserinfo.username#>')>
		<cfset recipientuserinfo = user.getUser(targetedto)>
		<cfset email.setRecipient('#recipientuserinfo.fname# #recipientuserinfo.lname# <#recipientuserinfo.username#>')>
		
		<!--- TODO : setup a module for sending email --->
		<cfset email.setBody("<p>Dear #recipientuserinfo.fname# #recipientuserinfo.lname#,</p>
<p>The page titled #page.pagename# has been sent to you by #targetuserinfo.fname# #targetuserinfo.lname#.</p>
<p>Please REVISE it here <a href='#variables.requestObj.getVar('esmurl')#pages/EditPage/?id=#arguments.pageid#'>#variables.requestObj.getVar('esmurl')#pages/EditPage/?id=#arguments.pageid#</a></p>
<p>with comments : #arguments.comment#</p>")>
		<cfset email.sendMessage()>
	</cffunction>
	
	<cffunction name="getWorkFlowHistory">
		<cfargument name="workflowgroupid">
		<cfargument name="userid">
		<cfargument name="comment">
	
		<cfset var r = "">
	
		<cfquery name="r" datasource="#variables.requestObj.getvar('dsn')#">
			SELECT sitepages.pagename, 
				workflow.status, 
				byuser.fname, byuser.lname, 
				touser.fname, touser.lname, 
				workflow.comment, 
				workflow.datetime 
			FROM workflow wf
			INNER JOIN sitepages ON wf.pageid = sitepages.id
			INNER JOIN users byuser ON initiatedby = byuser.id
			INNER JOIN users touser ON targetedto = to user.id
			WHERE workflowgroupid = <cfqueryparam value="#arguments.workflowgroupid#" cfsqltype="cf_sql_varchar">
			AND siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#:staged" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn r>
	</cffunction>
	
</cfcomponent>