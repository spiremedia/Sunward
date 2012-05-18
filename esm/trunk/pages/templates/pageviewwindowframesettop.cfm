
<cfset lcl.memberTypes = getDataItem('memberTypes')>


<cfoutput>
<cfcontent reset="true"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />

	<title>Site View</title>

	<style type="text/css" media="all">
		@import "/ui/css/c.css";
		@import "/ui/css/n.css";
		@import "/ui/css/f.css";
		@import "/ui/css/datepickercontrol.css";
	</style>
	<style type="text/css" media="screen">@import "/ui/css/l.css";</style>
	<script>
		function reloadframe (name,view) {
			name = name=='same'?'#variables.requestObj.getFormUrlVar('showmembertype')#':name;
			view = view=='same'?'#variables.requestObj.getFormUrlVar('preview')#':view;
			tgt = '/pages/pageviewframeset/?preview=' + view + '&id=#variables.requestObj.getFormUrlVar('id')#&showmembertype=' + name;
			parent.location.href = tgt;
		}
	</script>
</head>
<body id="popup">
	<div style="margin-top:14px;">
		<cfif variables.requestObj.getFormUrlVar('preview') EQ 'edit'>
			<input type="button" value="Switch to Preview" onClick="reloadframe('same','view')">
		<cfelse>
			<input type="button" value="Switch to Edit View" onClick="reloadframe('same','edit')">
		</cfif>
		<!--- Switch Member Type
		<select name="me" onchange="reloadframe(this.value, 'same')">
			<option value="">Default</option>
			<cfloop query="lcl.memberTypes">
				<option value="#URLEncodedFormat(trim(name))#" <cfif variables.requestObj.getFormUrlVar('showMemberType') EQ name>selected</cfif>>#name#</option>
			</cfloop>
		</select> --->
	</div>
    <div style="position:absolute;right:20px;top:14px;"><input type="button" value="Close" onclick="parent.closeme()" />
</body>
</html>
</cfoutput>