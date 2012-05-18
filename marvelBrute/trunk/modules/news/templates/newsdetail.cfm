<cfoutput>
<div class="insideNews">
    <p>
        <cfif StructKeyExists(variables.data,"newsinfo")>
			#dateformat(variables.data.newsinfo.itemdate,"mmmm d, yyyy")# #variables.data.newsinfo.title#</a><br />
			#variables.data.newsinfo.html# 
        <cfelse>
           There are currently no items to show.
        </cfif>
    </p>
</div>
</cfoutput>