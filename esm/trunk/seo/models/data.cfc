<cfcomponent name="Users Model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="load" output="false">
		<cfargument name="id" required="true">
		<cfset var sg = "">
		<cfset var itm = "">
	
		<cfset sg = getUser(id = arguments.id)>		
	
		<cfparam name="variables.itemdata" default="#structnew()#">
		
		<cfloop list="#sg.columnlist#" index="itm">
			<cfset variables.itemdata[itm] = sg[itm][1]>
		</cfloop> 
		
		<cfset variables.itemdata.id = arguments.id>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="getUsers" output="false">
		<cfset var users = "">
	
		<cfquery name="users" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				id, 
				lname, 
				fname, 
				username, 
				UPPER(SUBSTRING(lname, 1, 1)) fletter,
				lname + ', ' + fname fullname
			FROM users 
			WHERE  deleted = 0
			ORDER BY lname
		</cfquery>
		
		<cfreturn users/>
	</cffunction>
	
	<cffunction name="getUser" output="false">
		<cfargument name="id">
		<cfset var users = "">
	
		<cfquery name="user" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				id, lname, fname, username, SUBSTRING(lname, 1, 1) fletter,
				active, homephone, mobilephone, fax, company, line1, line2, city, state, country, postalcode, modified
			FROM users 
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
				
		</cfquery>
		
		<cfreturn user/>
	</cffunction>
	
	<cffunction name="checkLoginCredentials" output="false">
		<cfargument name="username">
		<cfargument name="password">
		<cfset var user = "">
	
		<cfquery name="user" datasource="#variables.request.getvar('dsn')#">
			SELECT 
				id, lname, fname, username, issuper
			FROM users_view
			WHERE active = 1 
					AND username = <cfqueryparam value="#trim(arguments.username)#" cfsqltype="cf_sql_varchar">
					AND password = <cfqueryparam value="#hash(trim(arguments.password))#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfreturn user/>
	</cffunction>
	
	<cffunction name="search" output="false">
		<cfargument name="search">
		<cfargument name="field">
	
		<cfset var users = "">
		<cfset var searchlist = "fname,lname,username,city,state,postalcode">
	
		<cfquery name="users" datasource="#variables.request.getvar('dsn')#" result="m">
			SELECT 
				id, lname, fname, username, SUBSTRING(lname, 1, 1) fletter, modified,
				active, homephone, mobilephone, fax, company, line1, line2, city, state, country, postalcode
			FROM users 
			WHERE active = 1 
			AND deleted = 0 
			AND 
				( 1=0
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
	
	<cffunction name="setvalues">
		<cfargument name="itemdata">
	
		<cfparam name="variables.itemdata" default="#structnew()#">
		<cfset structappend(variables.itemdata, arguments.itemdata)>
		
		<cfif not StructKeyExists(variables.itemdata,'active')>
			<cfset variables.itemdata.active = 0>
		</cfif>
		
	</cffunction>
	
	<cffunction name="validate">		
		<cfset var lcl = structnew()>
		<cfset var requestvars = variables.itemData>
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var mylocal = structnew()>
		
		<cfset mylocal.sameusers = search(requestvars.opi_un_poip,'username')>
	
		<!--- valiation for new users --->
		<cfif requestvars.id EQ "">
			<cfif mylocal.sameusers.recordcount>
				<cfset vdtr.addError('opi_un_poip','This Username is already taken, please choose another.')>
			</cfif>
			<cfset vdtr.isvalidpassword('password', requestvars.hjl_pwd_kjljk, "The password is required and must be 5 - 15 chars long.")>
		<cfelse><!--- validation for existing users --->
			<cfif mylocal.sameusers.recordcount AND requestvars.id NEQ mylocal.sameusers.id>
				<cfset vdtr.addError('opi_un_poip','This Username is already taken, please choose another.')>
			</cfif>
			<cfif requestvars.hjl_pwd_kjljk NEQ "">
				<cfset vdtr.isvalidpassword('password', requestvars.hjl_pwd_kjljk, "The password is required and must be 5 - 15 chars long.")>
			</cfif>
		</cfif>
		
        <cfif (requestvars.active NEQ 1) AND (requestvars.activeold EQ 1)>
			<!--- users set as inactive must get checked to make sure not page owners --->
            <cfquery name="mylocal.pageowners" datasource="#variables.request.getvar('dsn')#">
                SELECT DISTINCT p.pagename, s.name 
                FROM sitepages p
                INNER JOIN sites s ON left(p.siteid,35) = s.id
                WHERE p.ownerid = <cfqueryparam value="#requestvars.id#" cfsqltype="cf_sql_varchar">
            </cfquery>
            
            <cfif mylocal.pageowners.recordcount>
                <cfset vdtr.addError('active','This user is the page owner for page "#mylocal.pageowners.pagename#" of site "#mylocal.pageowners.name#" and therefore may not be set as not active.')>
            </cfif>
        </cfif>
		<cfset vdtr.validemail('opi_un_poip', requestvars.opi_un_poip, 'The Username must be a valid email.')>
		<cfset vdtr.notblank('fname', requestvars.fname, 'The First Name is required.')>
		<cfset vdtr.notblank('lname', requestvars.lname, 'The Last Name is required.')>
		
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="validatePasswordChange">		
		<cfset var lcl = structnew()>
		<cfset var requestvars = variables.itemData>
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var mylocal = structnew()>

		<cfset vdtr.isvalidpassword('newpassword', requestvars.newpassword, "The New Password is required and must be 5 - 15 chars long.")>
		
		<cfif requestvars.newpassword NEQ requestvars.newpasswordrpt>
			<cfset vdtr.addError('newpasswordrpt', "The New Password does not match the New Password Repeat.")>
		</cfif>
	
		<cfquery name="mylocal.checkpassword" datasource="#variables.request.getvar('dsn')#">
            SELECT count(*) cnt
			FROM users_view
            WHERE password = <cfqueryparam value="#hash(requestvars.oldpassword)#" cfsqltype="cf_sql_varchar">
				AND id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar">
        </cfquery>
    	
		<cfif mylocal.checkpassword.cnt EQ 0>
			<cfset vdtr.addError('oldpassword', "The Old Password does not match with the current password.")>
		</cfif>
				
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="updatepassword" output="false">
		<cfset var upd = "">
	
		<cfquery name="upd" datasource="#variables.request.getvar('dsn')#">
			UPDATE users SET 
				password = <cfqueryparam value="#hash(variables.itemdata.newpassword)#" cfsqltype="cf_sql_varchar"> 
			WHERE id = <cfqueryparam value="#variables.itemdata.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		
		<cfset variables.observeEvent('user updates password', variables.itemData)>

	</cffunction>
	
	<cffunction name="save">
		<cfset var id = "">
		<cfif variables.itemData.id EQ ''>
			<cfset id = insertUser(argumentcollection = variables.itemData)>
			<cfset variables.observeEvent('insert user', variables.itemData)>
		<cfelse>
			<cfset id = updateUser(argumentcollection = variables.itemData)>
			<cfset variables.observeEvent('update user', variables.itemData)>
		</cfif>
		<cfreturn id>
	</cffunction>
	
	<cffunction name="insertuser" output="false">
		
		<cfset var users = "">
		<cfset var id = createuuid()>
		<cfset variables.itemdata.id = id>
		
		<cfparam name="arguments.active" type="boolean" default="false">

		<cfquery name="users" datasource="#variables.request.getvar('dsn')#">
			INSERT INTO users ( 
				id,
				active,
				fname,
				lname,
				username,
				password,
				homephone, 
				mobilephone, 
				fax, 
				company, 
				line1, 
				line2, 
				city, 
				state, 
				country , 
				postalcode
			)VALUES (
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.active#" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="#arguments.fname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.lname#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.opi_un_poip#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#hash(arguments.hjl_pwd_kjljk)#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.homephone#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.mobilephone#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.fax#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.company#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.line1#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.line2#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.city#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.country#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.postalcode#" cfsqltype="cf_sql_varchar">
			)			
		</cfquery>
		<cfreturn id/>
	</cffunction>
	
	<cffunction name="updateuser" output="false">
		
		<cfset var users = "">
		<cfparam name="arguments.active" type="boolean" default="false">
	
		<cfquery name="users" datasource="#variables.request.getvar('dsn')#">
			UPDATE users SET 
				active=<cfqueryparam value="#arguments.active#" cfsqltype="cf_sql_bit">,
				fname=<cfqueryparam value="#arguments.fname#" cfsqltype="cf_sql_varchar">,
				lname=<cfqueryparam value="#arguments.lname#" cfsqltype="cf_sql_varchar">,
				username=<cfqueryparam value="#arguments.opi_un_poip#" cfsqltype="cf_sql_varchar">,
				<cfif arguments.hjl_pwd_kjljk NEQ "">
					password=<cfqueryparam value="#hash(arguments.hjl_pwd_kjljk)#" cfsqltype="cf_sql_varchar">,
				</cfif>
				homephone=<cfqueryparam value="#arguments.homephone#" cfsqltype="cf_sql_varchar">, 
				mobilephone=<cfqueryparam value="#arguments.mobilephone#" cfsqltype="cf_sql_varchar">, 
				fax=<cfqueryparam value="#arguments.fax#" cfsqltype="cf_sql_varchar">, 
				company=<cfqueryparam value="#arguments.company#" cfsqltype="cf_sql_varchar">, 
				line1=<cfqueryparam value="#arguments.line1#" cfsqltype="cf_sql_varchar">, 
				line2=<cfqueryparam value="#arguments.line2#" cfsqltype="cf_sql_varchar">, 
				city=<cfqueryparam value="#arguments.city#" cfsqltype="cf_sql_varchar">, 
				state=<cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar">, 
				country=<cfqueryparam value="#arguments.country#" cfsqltype="cf_sql_varchar">, 
				postalcode=<cfqueryparam value="#arguments.postalcode#" cfsqltype="cf_sql_varchar">
			WHERE 
				id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
	
	</cffunction>
	
	<cffunction name="deleteUser" output="false">
		<cfargument name="id" required="true">
		<cfset var users = "">
		
		<cfset load(arguments.id)>		
		<cfset variables.observeEvent('delete user', variables.itemData)>
		
		<cfquery name="users" datasource="#variables.request.getvar('dsn')#">
			UPDATE users SET deleted=1
			WHERE id= <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
		</cfquery>

	</cffunction>

	<cffunction name="validateDelete" output="false">
		<cfargument name="id" required="true">
		
        <cfset var mylocal = structnew()>
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		
		<!--- users set as inactive must get checked to make sure not page owners --->
        <cfquery name="mylocal.pageowners" datasource="#variables.request.getvar('dsn')#">
            SELECT DISTINCT p.pagename, s.name 
            FROM sitepages p
            INNER JOIN sites s ON left(p.siteid,35) = s.id
            WHERE p.ownerid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
        </cfquery>
                
        <cfif mylocal.pageowners.recordcount>
            <cfset vdtr.addError('username','This user is the page owner for page "#mylocal.pageowners.pagename#" of site "#mylocal.pageowners.name#" and therefore may not be deleted.')>
        </cfif>
        
		<cfreturn vdtr>
	</cffunction>
</cfcomponent>