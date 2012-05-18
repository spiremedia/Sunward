<cfcomponent name="users">

	<cffunction name="init">		
		<cfargument name="requestObject">
		<cfset variables.requestObject = arguments.requestObject>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="validateLogin">		
		<cfset var lcl = structnew()>		
		<cfset var vdtr = createObject('component', 'resources.abstractController').getUtility('datavalidator').init()>       	
		<cfset var info = requestObject.getAllFormUrlVars()>
		
		<!--- trim all form fields  --->
		<cfset info.usr = lcase(trim(info.usr))>				
		<cfset info.pd = trim(info.pd)>					
		
		<!--- validate user --->	
		<cfset vdtr.notblank('usr', info.usr, 'Please enter a Username.')>
		<cfset vdtr.notblank('pd', info.pd, 'Please enter a Password.')>
		
		<cfif vdtr.passValidation()>
			<cfset lcl.qryUser = getUser(usr = info.usr, password = info.pd)>					
			<cfif lcl.qryUser.recordcount eq 0>
				<cfset vdtr.addError('', 'Please enter a valid username and password. If you are having trouble logging in please call 1-888-898-3091.')>
			</cfif>
	   </cfif>
				
        <cfreturn vdtr>
    </cffunction>			
		
	<cffunction name="loginUser">		 		
		<cfset var lcl = structnew()>		    	
		<cfset var info = requestObject.getAllFormUrlVars()>
		
		<!--- trim all form fields  --->
		<cfset info.usr = lcase(trim(info.usr))>				
		<cfset info.pd = trim(info.pd)>		
				
		<cfset lcl.qryUser = getUser(usr = info.usr, password = info.pd)>		
		<cfif lcl.qryUser.recordcount>
			<cfif lcl.qryUser.firsttimeuser>
				<!--- set session first time user --->
				<cfset requestObject.getUserObject().setFirstTimeUser(1)>
				<cfset sendFirstTimeUserEmail(lcl.qryUser)>
			<cfelse>
				<!--- set session user info --->
				<cfset requestObject.getUserObject().loadCredentials(requestObject=requestObject, user = lcl.qryUser)>
			</cfif>
	   </cfif>
				
        <cfreturn>
    </cffunction>
	 
	<cffunction name="getUser">
		<cfargument name="usr" required="true">
		<cfargument name="password" required="false">
		
		<cfset var me = queryNew("")>		
				
		<cfquery name="me" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT id, username, name, email, memberTypes, firsttimeuser
			FROM members_view
			WHERE lower(username) = <cfqueryparam value="#arguments.usr#" cfsqltype="cf_sql_varchar">
			AND password = <cfqueryparam value="#hash(arguments.password)#" cfsqltype="cf_sql_varchar">
		</cfquery>
		 
       <cfreturn me>
   </cffunction>		
	 
	<cffunction name="getUserByID">
		<cfargument name="id" required="true">
		
		<cfset var me = queryNew("")>		
				
		<cfquery name="me" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT id, username, name, email, memberTypes, firsttimeuser
			FROM members_view
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		 
       <cfreturn me>
   </cffunction>		
	
	<cffunction name="validateChangePassword">		
		<cfset var lcl = structnew()>		
		<cfset var vdtr = createObject('component', 'resources.abstractController').getUtility('datavalidator').init()>       	
		<cfset var info = requestObject.getAllFormUrlVars()>
		
		<!--- trim all form fields  --->
		<cfset info.memberid = trim(info.memberid)>					
		<cfset info.newpd = trim(info.newpd)>					
		<cfset info.verifynewpd = trim(info.verifynewpd)>							
		
		<cfset vdtr.notblank('memberid', info.memberid, 'Member identifier is missing.')>
		<cfset vdtr.lengthbetween('newpd', 5, 15, info.newpd, '"New Password" is required and must be 5 to 15 characters long.')>				
		<cfset vdtr.lengthbetween('verifynewpd', 5, 15, info.verifynewpd, '"Re-enter New Password" is required and must be 5 to 15 characters long.')>					
		<cfset vdtr.sameas('newpd',info.newpd,info.verifynewpd,'The passwords you''ve entered do not match. Please re-enter your new password.')>
		<cfif NOT getUserByID(id=info.memberid ).recordcount>
			<cfset vdtr.adderror('memberid', 'This is an incorrect Member identifier.')>
		</cfif>
	
		<cfreturn vdtr/>
	</cffunction>

	<cffunction name="saveChangePassword">	
		<cfset var lcl = structnew()>		       	
		<cfset var info = requestObject.getAllFormUrlVars()>
		
		<cfset info.memberid = trim(info.memberid)>
		<cfset info.newpd = hash(trim(info.newpd))>
				
		<cfquery name="lcl.me" datasource="#variables.requestObject.getVar('dsn')#" result="lcl.result">
			UPDATE [members]
			SET password = <cfqueryparam value="#info.newpd#" cfsqltype="cf_sql_varchar">,
			firsttimeuser = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
			modified = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
			WHERE id = <cfqueryparam value="#info.memberid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfreturn lcl.result.recordcount>
	</cffunction>
	
	<cffunction name="sendFirstTimeUserEmail">		
		<cfargument name="user" required="true">
		<cfset var lcl = structnew()>	
		<cfset var vdtr = createObject('component', 'resources.abstractController').getUtility('datavalidator').init()>     
		
		<cfset vdtr.validemail('email', arguments.user.email, 'The Email must be valid')>
		<cfif vdtr.passValidation()>
			<cfset lcl.recipient = arguments.user.email>
		<cfelse>
			<!--- !! decision on what email to use, if user email invalid --->
			<cfset lcl.email = arguments.user.email & '@scg-grp.com'>
	   </cfif>
		<cfset lcl.link = requestObject.getVar('siteurl') & "Users/ChangePassword/?mid=" & arguments.user.id>	
		<cfset lcl.name = arguments.user.name>	
		
		<!--- !! when go live, rm this --->
		<cfset lcl.recipient = "brian@spiremedia.com">
		
<!---  set email body (plain/text for Blackberry users!) --->	
<cfsavecontent variable="lcl.body"><cfoutput>
Dear #lcl.name#, <br /><br />

Click <a href="#lcl.link#">here</a> to log in and change your password or copy the link below:<br />
#lcl.link#
</cfoutput></cfsavecontent>
		
		<!---  set email parameters and send mail --->	
		<cfset lcl.email = createObject('component', 'resources.email').init(requestObject = requestObject)> 
		<cfset lcl.email.setRecipient(recipient = lcl.recipient)>
		<cfset lcl.email.setSubject(subject = 'Sunward Account Info')>	
		<cfset lcl.email.setBody(body = lcl.body)>	
		<cfset lcl.email.setSender(sender = requestObject.getVar('systememailfrom'))>	
		<cfset lcl.email.setMailServer(mailserver = requestObject.getVar('mailsmtp'))>	
		<cfset lcl.email.sendMessage()>	

		<cfreturn>
	</cffunction>
</cfcomponent>
