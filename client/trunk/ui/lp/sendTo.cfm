<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>

<cfdump var="#form#">
SUBJECT,REDIRECT,NAME,EMAIL,PHONE NUMBER,QUESTION

<cfif cgi.HTTP_REFERER is "http://sunwardsteel.com/ui/lp/steel-farm-buildings.html" or cgi.HTTP_REFERER is "http://www.sunwardsteel.com/ui/lp/steel-farm-buildings.html">
	<cfmail to="bking@fusiondevelopers.com" subject="#form.subject#" from="#form.email#" type="html"  server="mail.spiremedia.com">
		<table>
			<tr>
				<td><strong>Name:</strong></td><td>#form.name#</td>
			</tr>
			<tr>
				<td><strong>Email:</strong></td><td>#form.email#</td>
			</tr>
			<tr>
				<td><strong>Phone:</strong></td><td>#form["PHONE NUMBER"]#</td>
			</tr>
			<tr>
				<td ></td>
			</tr>
		</table>		
		<strong>Question:</strong><br />#form.QUESTION#
	</cfmail>
	<cflocation url="#form.REDIRECT#">
<cfelse>
	<strong>INVALID SUBMISSION.</strong>
</cfif>



</body>
</html>
