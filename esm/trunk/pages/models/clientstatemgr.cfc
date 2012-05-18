<cfcomponent name="clientstatemgr" extends="resources.abstractStateMgr">
	
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		<cfset variables.requestObject = arguments.requestObject>	
		<cfset variables.userObject = arguments.userObject>
		<cfreturn this>
	</cffunction>

	<cffunction name="event">
		<cfargument name="eventname">
		<cfargument name="modelRef">
		<cfargument name="moreInfo">

		<cfswitch expression="#arguments.eventname#">
			<cfcase value="page up down,delete page,move page">
				<cfset prepnotify(modelref, 1)>
			</cfcase>
			<cfcase value="publish page">
				<!--- determine if shold reload just page or surrounding pages --->
				<cfif moreInfo.reloadsurrounding>
					<cfset prepnotify(modelref, 1)>
				<cfelse>
					<cfset prepnotify(modelref, 0)>
				</cfif>
			</cfcase>
			
			<cfcase value="pre publish page">
				<!--- used for clearing cache if page url is changed --->
				<cfset prepnotify(modelref, 1)>
			</cfcase>
		</cfswitch>

	</cffunction>
	
	<cffunction name="prepnotify">
		<cfargument name="pageref" required="true">
		<cfargument name="clearsurroundings" required="true">
		
		<cfset var smo = pageref.getPagesObj().getSiteMapObj('published')>
		<cfset var refreshparams = structnew()>
		<cfset var siteinfo = "">
		<cfset var urlistances = "">

		<!--- determine if clearsurroundings --->
		<cfset addStateParam('clearsurroundings', arguments.clearsurroundings)>
		
		<!--- put toghether relevant data --->
		<cfset addStateParam('id', arguments.pageref.getPageId())>
		
		<!--- set module to act upon --->
		<cfset addStateParam('module', 'system')>
		
		<cfset sendNotification()>
		
	</cffunction>
</cfcomponent>