<cfoutput>

    <link rel="stylesheet" type="text/css" href="/ui/css/news.css">
    
    <div id="newsItem">
        <cfif variables.newslist.recordcount>
            <cfloop query="variables.newslist">
                <li>
                    #dateformat(itemdate,"mmmm dd, yyyy")#&nbsp;|&nbsp;
                    <a href="/NewsandEvents/News/View/#id#/">#title#</a>
                </li>
            </cfloop>
        <cfelse>
            <p>There are currently no items to show.</p>
        </cfif>
    </div>
    
    <br clear="all" />

</cfoutput>