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
			FROM securitygroups_log
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
			FROM securitygroups_log
			INNER JOIN users ON userid = users.id
			WHERE securitygroupid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			ORDER BY actiondate DESC
		</cfquery>
		
		<cfreturn add>
	</cffunction>
	<cffunction name="event">
		<cfargument name="eventname">
		<cfargument name="modelRef">
		<cfargument name="moreInfo">

		<cfswitch expression="#arguments.eventname#">
			<cfcase value="insert securitygroup">
				<cfset insertSecuritygroup(moreInfo)>
			</cfcase>
			<cfcase value="update securitygroup">
				<cfset updateSecuritygroup(moreInfo)>
			</cfcase>
			<cfcase value="delete securitygroup">
				<cfset deleteSecuritygroup(moreInfo)>
			</cfcase>
		</cfswitch>
		
	</cffunction>
	<cffunction name="insertSecuritygroup">
		<cfargument name="moreinfo" required="true">
				
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							securitygroupid = moreinfo.id,
							description = 'Added Security Group "#moreinfo.name#".')>
	</cffunction>
	
	<cffunction name="updateSecuritygroup">
		<cfargument name="moreinfo" required="true">
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							securitygroupid = moreinfo.id,
							description = 'Updated Security Group "#moreinfo.name#".')>
	</cffunction>
	
	<cffunction name="deleteSecuritygroup">
		<cfargument name="moreinfo" required="true">
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							securitygroupid = moreinfo.id,
							description = 'Deleted Security Group "#moreinfo.name#".')>
	</cffunction>
	
	<cffunction name="insertLog" access="private">
		<cfargument name="userid">
		<cfargument name="securitygroupid">
		<cfargument name="description">
		
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
		INSERT INTO securitygroups_log (
			id,
			securitygroupid,
			userid,
			description,
			siteid
		) VALUES (
			<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.securitygroupid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#variables.userObject.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		)
		</cfquery>
	</cffunction>
	
	
</cfcomponent>