<cftry>
<cfmail to="#form.friends_email#" from="#form.your_email#" subject="#form.client_name# Photo Gallery" type="HTML" server="mail.spiremedia.com">

Hi #form.your_name#,

#form.friends_name# &lt;#form.friends_email#&gt; invited you to check out a photo gallery at #form.client_name#: #form.photo_link#

<cfif (isdefined("form.message") and len(form.message) gt 0)>
#form.message#
</cfif>

</cfmail>
<cfoutput>
Your message has been sent!
</cfoutput>
<cfcatch>
There was a problem sending your email. Please ensure all form fields have been filled out correctly.</cfcatch>
</cftry>
