<cfcomponent name="members" output="false" extends="resources.abstractModel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getMembers" output="false">
		<cfset var sg = "">
	
		<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
			SELECT id, username, name, email, memberTypes
			FROM members 
			WHERE deleted = 0
			ORDER BY name
		</cfquery>
		
		<cfreturn sg/>
	</cffunction>
	
	<cffunction name="load" output="false">
		<cfargument name="id" required="true">
		<cfset var sg = "">
		<cfset var itm = "">
		
		<cfset sg = getMember(id = arguments.id)>	
	
		<cfparam name="variables.itemdata" default="#structnew()#">
		
		<cfloop list="#sg.columnlist#" index="itm">
			<cfset variables.itemdata[itm] = sg[itm][1]>
		</cfloop> 
		
		<cfset variables.itemdata.id = arguments.id>
   
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getMember" output="false">
		<cfargument name="id">
		<cfset var sg = "">
	
		<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
			SELECT id, username, name, email, modified, memberTypes
			FROM members 
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfreturn sg/>
	</cffunction>
		
	<cffunction name="setvalues">
		<cfargument name="itemdata">
	
		<cfset variables.itemdata = arguments.itemdata>
		
	</cffunction>
	
	<cffunction name="validate">		
		<cfset var lcl = structnew()>
		<cfset var requestvars = variables.itemData>
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var mylocal = structnew()>
		
		<cfset vdtr.notblank('username', requestvars.username, 'The Username is required.')>
		<cfset vdtr.notblank('name', requestvars.name, 'The Name is required.')>
		<cfset vdtr.validemail('email', requestvars.email, 'The Email must be a valid email address.')>
		
		<cfset vdtr.maxlength('username', 50, requestvars.username, 'The Username should not exceed 50 characters in length.')>
		<cfset vdtr.maxlength('name', 150, requestvars.name, 'The Name should not exceed 150 characters in length.')>
		<cfset vdtr.maxlength('email', 100, requestvars.email, 'The Email should not exceed 100 characters in length.')>
		<cfset vdtr.maxlength('password', 15, requestvars.password, 'The Password should not exceed 15 characters in length.')>
		
		<cfset mylocal.sameusers = search(requestvars.username,'username')>
	
		<!--- valiation for new users --->
		<cfif requestvars.id EQ "">
			<cfif mylocal.sameusers.recordcount>
				<cfset vdtr.addError('username','This Username is already taken, please choose another.')>
			</cfif>
			<cfset vdtr.isvalidpassword('password', requestvars.password, "The password is required and must be 5 - 15 chars long.")>
		<cfelse><!--- validation for existing users --->
			<cfif mylocal.sameusers.recordcount AND requestvars.id NEQ mylocal.sameusers.id>
				<cfset vdtr.addError('username','This Username is already taken, please choose another.')>
			</cfif>
			<cfif requestvars.password NEQ "">
				<cfset vdtr.isvalidpassword('password', requestvars.password, "The password is required and must be 5 - 15 chars long.")>
			</cfif>
		</cfif>
		
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="search" output="false">
		<cfargument name="search">
		<cfargument name="field">
	
		<cfset var users = "">
		<cfset var searchlist = "name,email,username">
	
		<cfquery name="users" datasource="#variables.request.getvar('dsn')#" result="m">
			SELECT id, username, name, email, modified, memberTypes
			FROM members_view 
			WHERE ( 1=0
					<cfif isdefined("arguments.field")>
						<cfloop list="#arguments.field#" index="word">
							OR #word# = <cfqueryparam value="#search#" cfsqltype="cf_sql_varchar">
						</cfloop>
					<cfelse>
						<cfloop list="#searchlist#" index="word">
							OR #word# LIKE <cfqueryparam value="%#search#%" cfsqltype="cf_sql_varchar">
						</cfloop>
					</cfif>
					
				)
		</cfquery>
	
		<cfreturn users/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var id = "">
		<cfif variables.itemData.id EQ ''>
			<cfset id = insertMember(argumentcollection = variables.itemData)>
			<cfset variables.observeEvent('insert member', variables.itemData)>
		<cfelse>
			<cfset id = updateMember(argumentcollection = variables.itemData)>
			<cfset variables.observeEvent('update member', variables.itemData)>
		</cfif>
		<cfreturn id>
	</cffunction>
	
	<cffunction name="insertMember" output="false">
		
		<cfset var users = "">
		<cfset var id = createuuid()>
		<cfset variables.itemdata.id = id>

		<cfquery name="users" datasource="#variables.request.getvar('dsn')#">
			INSERT INTO members ( 
				id,
				username,
				name,
				email,
				password, 
				memberTypes
			)VALUES (
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#hash(arguments.password)#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.memberTypes#" cfsqltype="cf_sql_varchar">
			)			
		</cfquery>
		<cfreturn id />
	</cffunction>
	
	<cffunction name="updateMember" output="false">
		
		<cfset var users = "">
	
		<cfquery name="users" datasource="#variables.request.getvar('dsn')#">
			UPDATE members SET 
				username=<cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar">,
				name=<cfqueryparam value="#arguments.name#" cfsqltype="cf_sql_varchar">,
				<cfif arguments.password NEQ "">
					password=<cfqueryparam value="#hash(arguments.password)#" cfsqltype="cf_sql_varchar">,
				</cfif>
				email=<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">, 
				memberTypes = <cfqueryparam value="#arguments.memberTypes#" cfsqltype="cf_sql_varchar">,
				modified = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			WHERE 
				id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
	
		<cfreturn id />
	</cffunction>
	
	<cffunction name="deleteMember" output="false">
		<cfargument name="id" required="true">
		<cfset var users = "">
		
		<cfset load(arguments.id)>		
		<cfset variables.observeEvent('delete member', variables.itemData)>
		
		<cfquery name="users" datasource="#variables.request.getvar('dsn')#">
			UPDATE members 
			SET deleted=1, 
				modified = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			WHERE id= <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>

	</cffunction>

	<cffunction name="validateDelete" output="false">
		<cfargument name="id" required="true">
		
        <cfset var mylocal = structnew()>
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
        
		<cfreturn vdtr>
	</cffunction>
</cfcomponent>
	