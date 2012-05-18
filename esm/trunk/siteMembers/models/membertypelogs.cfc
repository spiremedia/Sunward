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
			FROM membertypes_log
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
			FROM membertypes_log
			INNER JOIN users ON userid = users.id
			WHERE membertypeid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			ORDER BY actiondate DESC
		</cfquery>
		
		<cfreturn add>
	</cffunction>
	<cffunction name="event">
		<cfargument name="eventname">
		<cfargument name="modelRef">
		<cfargument name="moreInfo">

		<cfswitch expression="#arguments.eventname#">
			<cfcase value="insert member type">
				<cfset insertmembertype(moreinfo)>
			</cfcase>
			<cfcase value="update member type">
				<cfset updatemembertype(moreinfo)>
			</cfcase>
			<cfcase value="delete member type">
				<cfset deletemembertype(moreInfo)>
			</cfcase>
		</cfswitch>
		
	</cffunction>
	<cffunction name="insertMemberType">
		<cfargument name="moreinfo" required="true">
				
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							typeid = moreinfo.id,
							description = 'Added Member Type "#moreinfo.name#".')>
	</cffunction>
	
	<cffunction name="updatemembertype">
		<cfargument name="moreinfo" required="true">

		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							typeid = moreinfo.id,
							description = 'Updated Member Type "#moreinfo.name#".')>
	</cffunction>
    
    <cffunction name="deletemembertype">
		<cfargument name="moreinfo" required="true">

		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							typeid = moreinfo.id,
							description = 'Deleted Member Type "#moreinfo.name#".')>
	</cffunction>
    
   	<cffunction name="insertLog" access="private">
		<cfargument name="userid">
		<cfargument name="typeid">
		<cfargument name="description">
		
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
			INSERT INTO membertypes_log (
				id,
				membertypeid,
				userid,
				description
			) VALUES (
				<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.typeid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	
</cfcomponent>