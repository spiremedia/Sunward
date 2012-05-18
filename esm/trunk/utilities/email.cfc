<cfcomponent name="email">
	<cffunction name="init">
		<cfargument name="requestObj">
		<cfset var itm = "">
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.messageinfo = structnew()>
		<cfloop list="sender,recipient,subject,body" index="itm">
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
		<cfif variables.requestObj.isvarset('mailsmtp')>
			<cfset variables.mailserver = variables.requestObj.getVar('mailsmtp')>
			<cfreturn true>
		</cfif>
		<cfthrow message="Mailserver not set in settings and setmailserver method not used.  A mail server is required to use the email class.">
	</cffunction>
	<cffunction name="checkAllFieldsFilled" access="private">
		<cfloop list="sender,recipient,subject,body" index="itm">
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
			<cfmailpart charset="utf-8" type="html"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<title>ESM Email Notification</title>
	<style type="text/css" media="all">
	    body { margin: 0;}
		div##page
		{
		 font: 65%/1.1 Verdana, Arial, sans-serif;
		 color: ##333;
		 padding: 0 28px 55px 28px;
		 background: url("<cfoutput>#variables.requestObj.getVar('esmurl')#</cfoutput>ui/css/images/email/page-bkgd.jpg") repeat-x 0 0;
		}
		div##head { height: 130px; }
		div##head h1 { margin: 0; }
		div##middle
		{
		 background: url("<cfoutput>#variables.requestObj.getVar('esmurl')#</cfoutput>ui/css/images/email/middle-bkgd.jpg") repeat-x 0 0;
		 border: solid 1px ##cfcfcf;
		 padding: 31px 27px;
		}
		div##middle p{line-height: 1.2em;margin: 23px 0;	}
		a { color:##369; }
	</style>
</head>
<body>
	<div id="page">
		<div id="head">
			<h1><img src="<cfoutput>#variables.requestObj.getVar('esmurl')#</cfoutput>ui/images/logo.jpg" alt="Spiremedia ESM" /></h1>
		</div>
		<div id="middle">
		  <cfoutput>#variables.messageinfo.body#</cfoutput>
	    </div>
		<div id="foot">
		</div>
	</div>
</body>
<!-- InstanceEnd --></html>
			</cfmailpart>
		</cfmail>
	</cffunction>
</cfcomponent>