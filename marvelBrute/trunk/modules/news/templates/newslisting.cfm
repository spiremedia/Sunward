<cfoutput>

    <link rel="stylesheet" type="text/css" href="/ui/css/news.css">
    
    <div id="newsItem">
        <cfif variables.newslist.recordcount>
            <cfloop query="variables.newslist">
                <li>
                    <p>
                    	<a href="/News/View/#id#/">#title#</a> <br />
                        #dateformat(itemdate,"mmmm dd, yyyy")#
                    </p>
                    <p>#description#</p>
                </li>
            </cfloop>
        <cfelse>
            <p>There are currently no items to show.</p>
        </cfif>
    </div>
    
    <br clear="all" />

</cfoutput>