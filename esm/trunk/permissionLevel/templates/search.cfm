<cfif requestObj.isformurlvarset('searchkeyword')>
	<cfset setselected(2)>
	<cfset lcl.searchkeyword = requestObj.getformurlvar('searchkeyword')>
<cfelse>
	<cfset lcl.searchkeyword = "">
</cfif>
<dl class="accordion">
<dt class="selected">Keyword Search</dt>
<dd>
	<form action="/permissionLevel/search/" method="post">
	
	<div style="text-align: right;">
	<input type="text" name="searchkeyword" id="searchkeyword" maxlength="255" value="<cfif isdefined("form.search")><cfoutput>#lcl.searchkeyword#</cfoutput></cfif>" />
	<input type="submit" name="Search" value="Search" />
	</div>
	</form>
</dd>
</dl>