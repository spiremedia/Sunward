<cfcomponent name="email">

	<cffunction name="init">
		<cfargument name="requestObject">
		<cfset var itm = "">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.messageinfo = structnew()>
		<cfloop list="recipient,subject,body" index="itm">
			<cfset variables.messageinfo[itm] = "">
		</cfloop>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setRecipient">
		<cfargument name="recipient">
		<cfset variables.messageinfo.recipient = arguments.recipient>
	</cffunction>
	
	<cffunction name="setTemplate">
		<cfargument name="template">
		<cfset variables.template = arguments.template>
	</cffunction>
	
	<cffunction name="setData">
		<cfargument name="data">
		<cfset variables.data = arguments.data>
	</cffunction>
	
	<cffunction name="setBody">
		<cfargument name="body">
		<cfset variables.messageinfo.body = arguments.body>
	</cffunction>
	
	<cffunction name="setSender">
		<cfargument name="sender">
		<cfset variables.messageinfo.sender = arguments.sender>
	</cffunction>
	
	<cffunction name="setSubject">
		<cfargument name="subject">
		<cfset variables.messageinfo.subject = arguments.subject>
	</cffunction>
	
	<cffunction name="setMailServer">
		<cfargument name="mailserver">
		<cfset variables.mailserver = arguments.mailserver>
	</cffunction>
	
	<cffunction name="checkMailServerSet" access="private">
		<cfif structkeyexists(variables, 'mailserver')>
			<cfreturn true>
		</cfif>
		<cfif variables.requestObject.isvarset('mailsmtp')>
			<cfset variables.mailserver = variables.requestObject.getVar('mailsmtp')>
			<cfreturn true>
		</cfif>
		<cfthrow message="Mailserver not set in settings and setmailserver method not used.  A mail server is required to use the email class.">
    </cffunction>
    
	<cffunction name="checkAllFieldsFilled" access="private">
    	<cfif structkeyexists(variables.messageinfo, 'sender')>
			<cfreturn true>
		</cfif>
		<cfif variables.requestObject.isvarset('systememailfrom')>
			<cfset variables.messageinfo.sender = variables.requestObject.getVar('systememailfrom')>
			<cfreturn true>
		</cfif>
		<cfthrow message="systememailfrom not set in settings and setsender method not used.  A sender is required to use the email class.">
		<cfloop list="recipient,subject,body" index="itm">
			<cfif variables.messageinfo[itm] EQ "">
				<cfthrow message="Email Field '#itm#' not set.  Please call method 'set#itm#()' or use a setTemplate() and setData() before sendMessage()">
			</cfif>
		</cfloop>
	</cffunction>
	
	<cffunction name="sendMessage">
		<cfset checkMailServerSet()>
		<cfif structkeyexists(variables, 'data') AND structkeyexists(variables, 'template')>
			<cfset processTemplate()>
		</cfif>
		<cfset checkAllFieldsFilled()>
		
		<cfmail
			to="#variables.messageinfo.recipient#"
			from="#variables.messageinfo.sender#" 
			subject="#variables.messageinfo.subject#" 
			server="#variables.mailserver#">
			<cfmailpart charset="utf-8" type="text" wraptext="72">#REReplaceNoCase(variables.messageinfo.body, '<[^>]+>', '', 'all')#</cfmailpart>
			<cfmailpart charset="utf-8" type="html">
				<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
				<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
					<head>
						<meta http-equiv="content-type" content="text/html; charset=utf-8" />
						<title>ESM Email Notification</title>
						<style type="text/css" media="all">
						    body {
								padding: 0;
								font-size: 18px;
								font-weight: bold;
								font-family: Arial, Helvetica, sans-serif;
								}
							.emailTemplateHead {
								width: 601px;
								height: 138px;
								margin: 0;
								}
							.emailTemplateBody {
								width: 601px;
								padding: 10px;
								}
							.emailTemplateBody img {
								width: 601px;								
								}
							.emailTemplateFoot {
								width: 601px;
								height: 138px;
								margin: 0;
								}
						</style>
					</head>
					<body>
						<div class="emailTemplateHead">
							<img src="<cfoutput>#variables.requestObject.getVar('siteurl')#</cfoutput>ui/css/img/emailTemplateHeader.jpg" />
						</div>
						<div class="emailTemplateBody">
							<cfoutput>#variables.messageinfo.body#</cfoutput>
						</div>
					</body>
<!-- InstanceEnd --></html>
			</cfmailpart>
		</cfmail>
	</cffunction>
	
	<!--- added 05.06.2009 - brian --->
	<cffunction name="sendMessageCustom">
		<cfset checkMailServerSet()>
		<cfif structkeyexists(variables, 'data') AND structkeyexists(variables, 'template')>
			<cfset processTemplate()>
		</cfif>
		<cfset checkAllFieldsFilled()>
		<cfmail
			to="#variables.messageinfo.recipient#"
			from="#variables.messageinfo.sender#" 
			subject="#variables.messageinfo.subject#" 
			server="#variables.mailserver#">
			<cfmailpart charset="utf-8" type="text" wraptext="72">
				#REReplaceNoCase(variables.messageinfo.body, '<[^>]+>', '', 'all')#
			</cfmailpart>
			<cfmailpart charset="utf-8" type="html">
				<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
				<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
				<head>
				<meta http-equiv="content-type" content="text/html; charset=utf-8" />
				<title>Website Auto Response</title>
				</head>
				<body>
					<div class="emailTemplateHead">
						<img src="<cfoutput>#variables.requestObject.getVar('siteurl')#</cfoutput>ui/css/img/emailTemplateHeader.jpg" />
					</div>
					<div class="emailTemplateBody">
						<img src="<cfoutput>#variables.requestObject.getVar('siteurl')#</cfoutput>ui/css/img/clientEmailResponse.jpg" />
					</div>
					<div class="emailTemplateFoot">
						<img src="<cfoutput>#variables.requestObject.getVar('siteurl')#</cfoutput>ui/css/img/emailTemplateFooter.jpg" />
					</div>
				</body>
		<!-- InstanceEnd --></html>
		</cfmailpart>
		</cfmail>
	</cffunction>
	
</cfcomponent>