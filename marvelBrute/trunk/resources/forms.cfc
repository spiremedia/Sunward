<cfcomponent name="form" extends="resources.abstractModel">

	<cffunction name="init">	
		<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfreturn this>			
	</cffunction>
	
	<cffunction name="saveFormSubmission">
		<cfargument name="id" required="true" type="string">
		<cfargument name="formid" required="true" type="string">
		<cfargument name="submissiondate" required="true" type="string">
		<cfargument name="name" required="true" type="string">
		<cfargument name="type" required="true" type="string">

		<!--- Save form response data to the db --->
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			INSERT INTO formsubmission (id,formid,submissiondate,name,type,siteid)
			VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formid#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.submissiondate#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.requestObject.getvar('siteid')#">
			)
		</cfquery>
		
	</cffunction>
	
	<cffunction name="saveFormSubmissionEntry">
		<cfargument name="id" required="true" type="string">
		<cfargument name="formfield" required="true" type="string">
		<cfargument name="answer" required="true" type="string">
		
		<!--- Save form response data to the db --->
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			INSERT INTO formsubmissionEntry (formsubmissionid,formfield,answer)
			VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.formfield#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.answer#">
			)
		</cfquery>
		
	</cffunction>
	
		 	
	<cffunction name="sendFormSubmissionEmail">
		<cfargument name="recipient" type="string" required="true">
		<cfargument name="formname" type="string" required="true">
		<cfargument name="formsubmission" type="struct" required="true">
	
		<cfscript> 
			var body = '';
			var email = createObject('component', 'resources.email').init(requestObject = variables.requestObject);
			
			// Mail the form if the recipient attribte is present
			if ( arguments.recipient neq '' )
			{
				// Loop through each form question
				for(i = 1; i lte ArrayLen(formsubmission.formfield); i = i + 1)
				{
					if ( formsubmission.formfield[i] neq 'Comments' )
					{
						body = body & '<div style=" float: left; width: 200px; font-weight: normal; ">' & formsubmission.formfield[i] & '</div>';
						body = body & '<div style=" float: left; width: 200px; font-weight: normal; ">' & formsubmission.answer[i] & '</div><br style=" clear: both;" />';
					}
					if  ( formsubmission.formfield[i] eq 'Comments' )
					{
						body = body & '<div style=" width: 400px;font-weight: normal;  ">' & formsubmission.formfield[i] & '</div>';
						body = body & '<div style=" width: 400px; font-weight: normal; ">' & formsubmission.answer[i] & '</div>';
					}
				}
				// set email parameters and send mail
				email.setRecipient(recipient = arguments.recipient);
				email.setSubject(subject = variables.requestObject.getVar('siteurl') & ': ' & arguments.formname);
				email.setBody(body = body);
				email.setSender(sender = variables.requestObject.getVar('systememailfrom'));
				email.setMailServer(mailserver = variables.requestObject.getVar('mailsmtp'));
				email.sendMessage();
			}
		</cfscript>		
	</cffunction> 

	<!--- added 05.06.2009 - brian --->
	<cffunction name="sendFormSubmissionEmailCustom">
		<cfargument name="recipient" type="string" required="true">
		<cfargument name="formname" type="string" required="true">
		<cfargument name="formsubmission" type="struct" required="true">
	
		<cfscript> 
			var body = '';
			var email = createObject('component', 'resources.email').init(requestObject = variables.requestObject);
			
			// Mail the form if the recipient attribte is present
			if ( arguments.recipient neq '' )
			{
				// Loop through each form question
				for(i = 1; i lte ArrayLen(formsubmission.formfield); i = i + 1)
				{
					body = body & formsubmission.formfield[i] & ': <br />';
					body = body & formsubmission.answer[i] & '<br /><br />';
				}
				// set email parameters and send mail
				email.setRecipient(recipient = arguments.recipient);
				email.setSubject(subject = variables.requestObject.getVar('siteurl') & ': ' & arguments.formname);
				email.setBody(body = body);
				email.setSender(sender = variables.requestObject.getVar('systememailfrom'));
				email.setMailServer(mailserver = variables.requestObject.getVar('mailsmtp'));
				email.sendMessageCustom();
			}
		</cfscript>		
	</cffunction> 

	
	
</cfcomponent>