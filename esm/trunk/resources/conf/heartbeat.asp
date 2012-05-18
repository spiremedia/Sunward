<%@ LANGUAGE="VBSCRIPT" %>
<%Response.Buffer = True %>
<%
dim url, strstatus, strhealth
 url = "http://beta.xxxxxx.org/applications/heartbeat.cfm"
	set xmlhttp = server.CreateObject("Microsoft.XMLHTTP")
    xmlhttp.open "GET", url, false
    xmlhttp.send()
strstatus = xmlhttp.Status
if strstatus = "200" then
	strhealth=xmlhttp.responseText
      response.write strhealth
	response.write "<br />" & strstatus
else
dim url2
strhealth = "dead"
url2 = "http://beta.xxxxxx.org/applications/restartcfmx.pl"
    set xmlhttp2 = server.CreateObject("Microsoft.XMLHTTP")
    xmlhttp2.open "GET", url, false
    xmlhttp2.send()

      response.write strstatus
	response.write xmlhttp.responseText
end if
%>
