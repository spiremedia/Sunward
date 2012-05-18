<cfoutput>
<div class="srchleft">
    &nbsp;
</div>
<!--#variables.collectionName#-->
<form action="/SearchResults/" method="get">
<div class="srchright srchnobar" style="padding-bottom: 0;">
    Results For:&nbsp;
    <input type="text" id="txtSearchResults" name="search" <cfif requestObject.isFormUrlVarSet('search')>value="#requestObject.getFormUrlVar('search')#"</cfif>/>
    <input type="image" src="/ui/images/searchButton.gif"  style="border:0; vertical-align: bottom; padding: 0;"/>
    <!---<input name="collection" type="hidden" value="#iif(variables.requestobject.isvarset('collection'),'variables.requestobject.getvar("collection")',DE(""))#">--->
</div>
</form>
<br class="clear"/>
<div class="srchleft">
    &nbsp;
</div>
<div class="srchright srchnobar">
	Displaying  
	<cfif variables.totalSearchRecords>
		#variables.page * variables.rowcount - variables.rowcount + 1#
	<cfelse>
		0
	</cfif>
	thru 
	<cfif variables.page * variables.rowcount GT variables.totalSearchRecords>
		#variables.totalSearchRecords#
	<cfelse>
		#variables.page * variables.rowcount#
	</cfif>
	of 
	#variables.totalSearchRecords# Results <cfif NOT structisempty(variables.searcheableCollections)>in &nbsp;&nbsp;</cfif>
    <cfif structkeyexists(variables.searcheableCollections, 'member')>
    	<a href="/SearchResults/?collection=member&search=#variables.criteria#">Member Site</a> &nbsp;&nbsp;</cfif>
    <cfif structkeyexists(variables.searcheableCollections, 'journal')>
    	<a href="/SearchResults/?collection=journal&search=#variables.criteria#">Journal Site</a> &nbsp;&nbsp;</cfif>
    <cfif structkeyexists(variables.searcheableCollections, 'consumer')>
    	<a href="/SearchResults/?collection=consumer&search=#variables.criteria#">General Public Site</a></cfif>
    <br />
    (Excluding <a href="">Journal Archives</a>)
</div>
<cfif variables.totalSearchRecords GT variables.rowcount>
	#variables.renderPaging()#
</cfif>
<br class="clear"/>
</cfoutput>
