<cfoutput>
<cfsavecontent variable="lcl.cntnts"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html><!-- home -->
<cfinclude template="../headtag.cfm"/>

<body class="home">
	<div id="outercontainer">
		<div id="container">
        	<cfinclude template="../header.cfm">
			<div class="navWrap">
            <div class="nav">
				<div class="innerNav">
					<table class="navTable">
                    <tr>
                    <td>
						#showContentObject('dhtmlNav', 'Navigation', 'dhtmlnav')#
                    </td>
                    </tr>
                    </table>
				</div>
                </div>
			</div>
			<div id="bodyContent">
</cfsavecontent>

<cfset lcl.cntnts = replacenocase(lcl.cntnts, 'href="/', 'href="#requestObject.getVar('siteurl')#',"all")>
<cfset lcl.cntnts = replacenocase(lcl.cntnts, 'src="/', 'src="#requestObject.getVar('siteurl')#',"all")>
<cfset lcl.cntnts = replacenocase(lcl.cntnts, 'action="/', 'action="#requestObject.getVar('siteurl')#',"all")>

<cfcontent reset="yes">#lcl.cntnts#
</cfoutput>
