<cfcomponent name="logobserver">
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		<cfset variables.requestObject = arguments.requestObject>	
		<cfset variables.userObject = arguments.userObject>
		<cfreturn this>
	</cffunction>
	<cffunction name="getRecent">
		<cfargument name="days">
	
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT description, fname + ' ' + lname fullname, actiondate 
			FROM galleryImages_log
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
			FROM galleryImages_log
			INNER JOIN users ON userid = users.id
			WHERE galleryImageid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			ORDER BY actiondate DESC
		</cfquery>
		
		<cfreturn add>
	</cffunction>
	
	<cffunction name="event">
		<cfargument name="eventname">
		<cfargument name="modelRef">

		<cfswitch expression="#arguments.eventname#">
			<cfcase value="add">
				<cfset addMethod(modelref)>
			</cfcase>
			<cfcase value="resize,rotate,crop,revert">
				<cfset alterImageMethod(modelref, arguments.eventname)>
			</cfcase>
			<cfcase value="edit">
				<cfset editMethod(modelref)>
			</cfcase>
			<cfcase value="upload Image">
				<cfset uploadMethod(modelref)>
			</cfcase>
			<cfcase value="delete">
				<cfset deleteMethod(modelref)>
			</cfcase>
		</cfswitch>
		
	</cffunction>
	
	<cffunction name="addMethod" access="private">
		<cfargument name="pageref" required="true">
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							galleryImageid = arguments.pageRef.getField('id'),
							description = 'Added "#arguments.pageRef.getField('name')#".')>
	</cffunction>
	
	<cffunction name="alterImageMethod" access="private">
		<cfargument name="pageref" required="true">
		<cfargument name="methodname" required="true">
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							galleryImageid = arguments.pageRef.getField('id'),
							description = arguments.methodname & 'ed Image "#arguments.pageRef.getField('name')#".')>
	</cffunction>
	
	<cffunction name="uploadMethod" access="private">
		<cfargument name="pageref" required="true">
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							galleryImageid = arguments.pageRef.getField('id'),
							description = 'Uploaded Image to "#arguments.pageRef.getField('name')#".')>
	</cffunction>
	
	<cffunction name="editMethod" access="private">
		<cfargument name="pageref" required="true">

		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							galleryImageid = arguments.pageRef.getField('id'),
							description = 'Updated "#arguments.pageRef.getField('name')#".')>
	</cffunction>
	
	<cffunction name="deleteMethod" access="private">
		<cfargument name="pageref" required="true">

		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							galleryImageid = arguments.pageRef.getField('id'),
							description = 'Deleted "#arguments.pageRef.getField('name')#"')>
	</cffunction>
	
	<cffunction name="insertLog" access="private">
		<cfargument name="userid">
		<cfargument name="assetid">
		<cfargument name="description">
		
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
		INSERT INTO galleryImages_log (
			id,
			galleryImageid,
			userid,
			description,
			actiondate
		) VALUES (
			<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.galleryImageid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
		)
		</cfquery>
	</cffunction>
	
	
</cfcomponent>