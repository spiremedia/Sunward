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
			FROM members_log
			INNER JOIN users ON userid = users.id
			WHERE actiondate > getDate() - 10
			ORDER BY actiondate DESC
		</cfquery>
		
		<cfreturn add>
	</cffunction>
	
	<cffunction name="getItemHistory">
		<cfargument name="id" required="true">
	
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT description, fname + ' ' + lname fullname, actiondate 
			FROM members_log
			INNER JOIN users ON userid = users.id
			WHERE memberid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			ORDER BY actiondate DESC
		</cfquery>
		
		<cfreturn add>
	</cffunction>
	<cffunction name="event">
		<cfargument name="eventname">
		<cfargument name="itemref">
        <cfargument name="moreInfo">

		<cfswitch expression="#arguments.eventname#">
			<cfcase value="insert member">
				<cfset insertmember(moreinfo)>
			</cfcase>
			<cfcase value="update member">
				<cfset updatemember(moreinfo)>
			</cfcase>
			<cfcase value="delete member">
				<cfset deletemember(moreInfo)>
			</cfcase>
		</cfswitch>
		
	</cffunction>
	<cffunction name="insertMember">
		<cfargument name="moreinfo" required="true">
				
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							memberid = moreinfo.id,
							description = 'Added Member "#moreinfo.name#".')>
	</cffunction>
	
	<cffunction name="updatemember">
		<cfargument name="moreinfo" required="true">

		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							memberid = moreinfo.id,
							description = 'Updated Member "#moreinfo.name#".')>
	</cffunction>
    
    <cffunction name="deletemember">
		<cfargument name="moreinfo" required="true">

		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							memberid = moreinfo.id,
							description = 'Deleted Member "#moreinfo.name#".')>
	</cffunction>
    
   	<cffunction name="insertLog" access="private">
		<cfargument name="userid">
		<cfargument name="memberid">
		<cfargument name="description">
		
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
			INSERT INTO members_log (
				id,
				memberid,
				userid,
				description
			) VALUES (
				<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.memberid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	
</cfcomponent>