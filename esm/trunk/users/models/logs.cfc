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
			FROM users_log
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
			FROM users_log
			INNER JOIN users ON userid = users.id
			WHERE usersid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			ORDER BY actiondate DESC
		</cfquery>
		
		<cfreturn add>
	</cffunction>
	<cffunction name="event">
		<cfargument name="eventname">
		<cfargument name="modelRef">
		<cfargument name="moreInfo">

		<cfswitch expression="#arguments.eventname#">
			<cfcase value="insert user">
				<cfset insertUser(moreInfo)>
			</cfcase>
			<cfcase value="update user">
				<cfset updateUser(moreInfo)>
			</cfcase>
			<cfcase value="delete user">
				<cfset deleteUser(moreInfo)>
			</cfcase>
			<cfcase value="user updates password">
				<cfset userUpdatesPassword(moreInfo)>
			</cfcase>
		</cfswitch>
		
	</cffunction>
	<cffunction name="insertUser">
		<cfargument name="moreinfo" required="true">
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							usersid = moreinfo.id,
							description = 'Added user "#moreinfo.opi_un_poip#".')>
	</cffunction>
	
	<cffunction name="updateUser">
		<cfargument name="moreinfo" required="true">
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							usersid = moreinfo.id,
							description = 'Updated user "#moreinfo.opi_un_poip#".')>
	</cffunction>
	
	<cffunction name="deleteUser">
		<cfargument name="moreinfo" required="true">
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							usersid = moreinfo.id,
							description = 'Deleted user "#moreinfo.username#".')>
	</cffunction>
	
	<cffunction name="userUpdatesPassword">
		<cfargument name="moreinfo" required="true">
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							usersid = moreinfo.id,
							description = 'User updates password.')>
	</cffunction>
	
	<cffunction name="updatedContentObject">
		<cfargument name="pageref" required="true">
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							usersid = arguments.pageRef.getField('id'),
							description = 'Updated content Object ## on "#arguments.pageRef.getField('name')#".')>
	</cffunction>
	
	<cffunction name="addedContentObject">
		<cfargument name="pageref" required="true">
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							usersid = arguments.pageRef.getField('id'),
							description = 'Added Content Object ## on "#arguments.pageRef.getField('name')#".')>
	</cffunction>
	
	<cffunction name="insertLog" access="private">
		<cfargument name="userid">
		<cfargument name="usersid">
		<cfargument name="description">
		
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
		INSERT INTO users_log (
			id,
			usersid,
			userid,
			description,
			siteid
		) VALUES (
			<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.usersid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#variables.userObject.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		)
		</cfquery>
	</cffunction>
	
	
</cfcomponent>