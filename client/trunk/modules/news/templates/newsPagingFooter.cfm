
	<div class="newsCrumbs">
	<ul>
	<cfoutput>
	<cfif variables.totalSearchRecords GT variables.rowcount>
		<cfif variables.page NEQ 1 AND variables.totalSearchRecords GTE variables.rowcount>
			<li><a href="?page=#variables.page-1#">Previous</a></li>
		<cfelse>
			<li>Previous</li>
		</cfif>
		<cfif variables.totalSearchRecords GTE variables.rowcount>
			<cfset lcl.startLoop = 1>
			<cfset lcl.endLoop = ceiling(variables.totalSearchRecords / variables.rowcount)>
			<cfloop from="#lcl.startLoop#" to="#lcl.endLoop#" index="lcl.indx">
				|
				<cfif variables.page EQ lcl.indx>
					<li>#lcl.indx#</li>
				<cfelse>
					<li><a href="?page=#lcl.indx#">#lcl.indx#</a></li>
				</cfif>
			</cfloop>
		</cfif>
        |
		<cfif variables.page NEQ ceiling(variables.totalSearchRecords / variables.rowcount)>
			<li><a href="?page=#variables.page+1#">Next</a></li>
		<cfelse>
			<li>Next</li>
		</cfif>
	</cfif>

	</cfoutput>
	</ul>
	</div>

