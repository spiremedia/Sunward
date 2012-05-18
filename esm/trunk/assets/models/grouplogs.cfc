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
			FROM assetgroups_log
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
			FROM assetgroups_log
			INNER JOIN users ON userid = users.id
			WHERE assetgroupid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			ORDER BY actiondate DESC
		</cfquery>
		
		<cfreturn add>
	</cffunction>
	<cffunction name="event">
		<cfargument name="eventname">
		<cfargument name="modelRef">
		<cfargument name="moreInfo">

		<cfswitch expression="#arguments.eventname#">
			<cfcase value="insert assetgroup">
				<cfset insertAssetgroup(moreInfo)>
			</cfcase>
			<cfcase value="update assetgroup">
				<cfset updateAssetgroup(moreInfo)>
			</cfcase>
			<cfcase value="delete assetgroup">
				<cfset deleteAssetgroup(moreInfo)>
			</cfcase>
		</cfswitch>
		
	</cffunction>
	<cffunction name="insertAssetgroup">
		<cfargument name="moreinfo" required="true">
				
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							assetgroupid = moreinfo.id,
							description = 'Added Asset Group "#moreinfo.name#".')>
	</cffunction>
	
	<cffunction name="updateAssetgroup">
		<cfargument name="moreinfo" required="true">
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							assetgroupid = moreinfo.id,
							description = 'Updated Asset Group "#moreinfo.name#".')>
	</cffunction>
	
	<cffunction name="deleteAssetgroup">
		<cfargument name="moreinfo" required="true">
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							assetgroupid = moreinfo.id,
							description = 'Deleted Asset Group "#moreinfo.name#".')>
	</cffunction>
	
	<cffunction name="insertLog" access="private">
		<cfargument name="userid">
		<cfargument name="assetgroupid">
		<cfargument name="description">
		
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
		INSERT INTO assetgroups_log (
			id,
			assetgroupid,
			userid,
			description
		) VALUES (
			<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.assetgroupid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
		)
		</cfquery>
	</cffunction>
	
	
</cfcomponent>