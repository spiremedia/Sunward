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
			FROM gallerygroups_log
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
			FROM gallerygroups_log
			INNER JOIN users ON userid = users.id
			WHERE gallerygroupid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			ORDER BY actiondate DESC
		</cfquery>
		
		<cfreturn add>
	</cffunction>
	
	<cffunction name="event">
		<cfargument name="eventname">
		<cfargument name="modelRef">
		<cfargument name="moreInfo">

		<cfswitch expression="#arguments.eventname#">
			<cfcase value="insert gallerygroup">
				<cfset insertGallerygroup(moreInfo)>
			</cfcase>
			<cfcase value="update gallerygroup">
				<cfset updateGallerygroup(moreInfo)>
			</cfcase>
			<cfcase value="delete gallerygroup">
				<cfset deleteGallerygroup(moreInfo)>
			</cfcase>
		</cfswitch>
		
	</cffunction>
	<cffunction name="insertGalleryGroup">
		<cfargument name="moreinfo" required="true">
				
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							gallerygroupid = moreinfo.id,
							description = 'Added Gallery Group "#moreinfo.name#".')>
	</cffunction>
	
	<cffunction name="updateGallerygroup">
		<cfargument name="moreinfo" required="true">
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							GalleryGroupid = moreinfo.id,
							description = 'Updated Gallery Group "#moreinfo.name#".')>
	</cffunction>
	
	<cffunction name="deleteGallerygroup">
		<cfargument name="moreinfo" required="true">
		
		<cfset insertLog(	userid = variables.userObject.getUserId(), 
							gallerygroupid = moreinfo.id,
							description = 'Deleted Gallery Group "#moreinfo.name#".')>
	</cffunction>
	
	<cffunction name="insertLog" access="private">
		<cfargument name="userid">
		<cfargument name="gallerygroupid">
		<cfargument name="description">
		
		<cfset var add = "">
		
		<cfquery name="add" datasource="#variables.requestObject.getVar('dsn')#">
		INSERT INTO gallerygroups_log (
			id,
			gallerygroupid,
			userid,
			description
		) VALUES (
			<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.gallerygroupid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.userid#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#arguments.description#" cfsqltype="cf_sql_varchar">
		)
		</cfquery>
	</cffunction>
	
	
</cfcomponent>