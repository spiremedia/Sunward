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
			FROM forms_log
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
			FROM forms_log
			INNER JOIN users ON userid = users.id
			WHERE formid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			ORDER BY actiondate DESC
		</cfquery>
		
		<cfreturn add>
	</cffunction>
	<cffunction name="event">
		<cfargument name="eventname">
		<cfargument name="modelRef">
		<cfargument name="moreInfo">

		<cfswitch expression="#arguments.eventname#">
			<cfcase value="insert form">
				<cfset insertForm(moreInfo)>
			</cfcase>
			<cfcase value="update form">
				<cfset updateForm(moreInfo)>
			</cfcase>
			<cfcase value="delete form">
				<cfset deleteForm(moreInfo)>
			</cfcase>
			<cfcase value="updated content object">
				<cfset updatedcontentobject(modelref)>
			</cfcase>
			<cfcase value="added content object">
				<cfset addedcontentobject(modelref)>
			</cfcase>
		</cfswitch>
		
	</cffunction>
	<cffunction name="insertForm">
		<cfargument name="moreinfo" required="true">
				
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							formid = moreinfo.id,
							description = 'Added form "#moreinfo.name#".')>
	</cffunction>
	
	<cffunction name="updateForm">
		<cfargument name="moreinfo" required="true">
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							formid = moreinfo.id,
							description = 'Updated form "#moreinfo.name#".')>
	</cffunction>
	
	<cffunction name="deleteForm">
		<cfargument name="moreinfo" required="true">
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							formid = moreinfo.id,
							description = 'Deleted form "#moreinfo.name#".')>
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
		<cfargument name="formid">
		<cfargument name="description">
		
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
		INSERT INTO forms_log (
			id,
			formid,
			userid,
			description,
			siteid
		) VALUES (
			<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.formid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#variables.userObject.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		)
		</cfquery>
	</cffunction>
	
	
</cfcomponent>