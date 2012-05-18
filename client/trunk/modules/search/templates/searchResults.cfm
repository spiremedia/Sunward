<!--- <cfdump var="#variables.searchResults#">  --->
<!--- Top Paging --->
<cfoutput>#variables.renderTopPaging()#</cfoutput>	
	
<!--- No Search Results --->
<cfif NOT variables.searchResults.recordcount>
	<p><b>No records were found. Please try again!</b></p>
</cfif>

<!--- Search Results --->
<cfoutput query="variables.searchResults">
	<cfsilent>
		<cfset relevance = round(SCORE * 100) & '% Relevance'>
		<cfset href = url>
		<cfset description = custom1>
		
		<cfif variables.criteria neq ''>
			<cfset description = replaceNoCase(description, variables.criteria, '<b>' & variables.criteria & '</b>','ALL')>
		</cfif>
        <cfset st = REFindNoCase('docs/assets/(.+)', url, 1, true)>
		<cfif st.pos[1] gt 0>
            <cfset href = variables.requestObject.getVar('cmslocation') & Mid(url,st.pos[1],st.len[1])>	
        </cfif> 
	</cfsilent>
	
	<div>
		<a href="#href#" 
			<cfif refind("\....$", url)>
				target="_blank"
			</cfif>
		>#title#</a>  (#relevance#) 
		<cfif size gt 1024000>
			[ #Numberformat(size/1024000, '____._')#MB ]
		<cfelseif size gt 0>
			[ #Numberformat(size/1024, '___')#KB ]
		</cfif>
		<br />
		#description#
	</div>
	<br class="clear"/>
</cfoutput>

<!--- Bottom Paging --->
<cfif variables.totalSearchRecords GT variables.rowcount>
	<cfoutput>#variables.renderPaging()#</cfoutput>
</cfif>

