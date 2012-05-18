
<cfset localRequest = application.settings.makeRequestObject()>
<cfset response = application.modules.dispatchEvent(localRequest, session.user)>
<cfset response.process()>