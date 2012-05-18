<cfcomponent extends="resources.abstractController" ouput="false">
	<cffunction name="init" output="false">
		<cfargument name="requestObject">
		<cfargument name="parameterList">
		<cfargument name="pageref">
		<cfargument name="possibleModules">
		<cfargument name="data">
        
        <cfset structappend(variables, arguments)>
        
		<cfreturn this>
    </cffunction>
    
    <cffunction name="loadMessaging" output="false">
		<cfargument name="msgr">
		
		<cfset setExpiringPages(msgr, 7)>
       	<cfset setExpiringPages(msgr, 1)>
        
        <cfset setAppearingPages(msgr, 7)>
       	<cfset setAppearingPages(msgr, 1)>
        
        <!---<cfset var appearingpages = getAppearingPages(days=daysoutwarning)>--->
    
        <cfreturn>
    </cffunction>
    
    <cffunction name="setExpiringPages">
    	<cfargument name="msgr">
    	<cfargument name="daysoutwarning">
        
		<cfset var doq = "">
        <cfset var expiringpages = "">
        <cfset var ownera = arraynew(1)>
        <cfset var tmpusername = "">
        <cfset var getowner = "">
        <cfset var msg = "">
        <cfset var msgbody = "">
        
        <cfquery name="doq" datasource="#requestObject.getVar('dsn')#" result="m">
        	SELECT spv.id, spv.urlpath, spv.ownerid, spv.pagename, spv.parentid, uv.username
            FROM sitepages_view spv
			LEFT OUTER JOIN users_view uv ON spv.ownerid = uv.id
            WHERE spv.hidedate = <cfqueryparam value="#dateadd('d', daysoutwarning, createdate(year(now()),month(now()), day(now())))#" cfsqltype="cf_sql_date">
            	AND spv.siteid = '#requestObject.getVar('siteid')#:published'
        </cfquery>
        
        <cfset expiringpages = processForOwnerEmail(doq)>

        <!--- order by owneremail for grouping purpose --->
        <cfquery name="expiringpages" dbtype="query">
			SELECT * FROM expiringpages
            ORDER BY owneremail
        </cfquery>
        
        <cfoutput query="expiringpages" group="owneremail">
        	<cfsavecontent variable="msgbody">
        	<p>You are the page owner for the following pages which will expire from the ESM managed site #requestObject.getVar('siteurl')# <cfif daysoutwarning EQ 1>tomorrow<cfelse>in #daysoutwarning# days</cfif>.</p>
			<ul>
			<cfoutput>
            	<li>#pagename# <a href="#requestObject.getVar('siteurl')##urlpath#">#requestObject.getVar('siteurl')##urlpath#</a></li>
            </cfoutput>
            </ul>
            
            <p>To update any pages in this list, log into the esm <a href="#requestObject.getVar('cmslocation')#">#requestObject.getVar('cmslocation')#</a> use the pages tab, find the page, and then update the date in the Page Expiration accordion. Publish the page to enable your change on the site.</p>
      
       	 	<p>The system.</p>
            </cfsavecontent>
        	
			<cfset msg = msgr.createMessage()>
            <cfset msg.setRecipient(expiringpages.owneremail)>
            <cfset msg.setSubject('ESM Notification : Pages Expiring in #daysoutwarning# days')>
            <cfset msg.setBody(msgbody)>
        </cfoutput>
     </cffunction>
     
     <cffunction name="setAppearingPages">
    	<cfargument name="msgr">
    	<cfargument name="daysoutwarning">
        
		<cfset var doq = "">
        <cfset var showingpages = "">
        <cfset var ownera = arraynew(1)>
        <cfset var tmpusername = "">
        <cfset var getowner = "">
        <cfset var msg = "">
        <cfset var msgbody = "">
        
        <cfquery name="doq" datasource="#requestObject.getVar('dsn')#" result="m">
        	SELECT spv.id, spv.urlpath, spv.ownerid, spv.pagename, spv.parentid, uv.username
            FROM sitepages_view spv
			LEFT OUTER JOIN users_view uv ON spv.ownerid = uv.id
            WHERE spv.showdate = <cfqueryparam value="#dateadd('d', daysoutwarning, createdate(year(now()),month(now()), day(now())))#" cfsqltype="cf_sql_date">
            	AND spv.siteid = '#requestObject.getVar('siteid')#:published'
        </cfquery>
        
        <cfset showingpages = processForOwnerEmail(doq)>

        <!--- order by owneremail for grouping purpose --->
        <cfquery name="showingpages" dbtype="query">
			SELECT * FROM showingpages
            ORDER BY owneremail
        </cfquery>
        
        <cfoutput query="showingpages" group="owneremail">
        	<cfsavecontent variable="msgbody">
        	<p>You are the page owner for the following pages which will appear on the ESM managed site #requestObject.getVar('siteurl')# <cfif daysoutwarning EQ 1>tomorrow<cfelse>in #daysoutwarning# days</cfif>.</p>
			<ul>
			<cfoutput>
            	<li>#pagename# <a href="#requestObject.getVar('siteurl')##urlpath#">#requestObject.getVar('siteurl')##urlpath#</a></li>
            </cfoutput>
            </ul>
            
            <p>To update any pages in this list, log into the esm <a href="#requestObject.getVar('cmslocation')#">#requestObject.getVar('cmslocation')#</a> use the pages tab, find the page, and then update the date in the Page Expiration accordion. Publish the page to enable your change on the site.</p>
      
       	 	<p>The system.</p>
            </cfsavecontent>
        	
			<cfset msg = msgr.createMessage()>
            <cfset msg.setRecipient(showingpages.owneremail)>
            <cfset msg.setSubject('ESM Notification : Pages Appearing in #daysoutwarning# days')>
            <cfset msg.setBody(msgbody)>
        </cfoutput>
     </cffunction>
     
     <cffunction name="processForOwnerEmail">
        <cfargument name="doq">
        
        <cfset var ownera = arraynew(1)>
        <cfset var tmpusername = "">
        <cfset var getowner = "">
        
        <!--- climb up sitemap tree till find an owner --->
        <cfloop query="doq">
			<cfset getowner = structnew()>
            <cfset getowner.parentid = doq.parentid>
            <cfset getowner.username = doq.username>
            <cfloop condition="getOwner.parentid NEQ '' AND getOwner.username EQ ''">
                <cfquery name="getowner" datasource="#requestObject.getVar('dsn')#" result="m">
                    SELECT spv.parentid, uv.username
                    FROM sitepages_view spv
                    LEFT OUTER JOIN users_view uv ON spv.ownerid = uv.id
                    WHERE spv.id = <cfqueryparam value="#getowner.parentid#" cfsqltype="cf_sql_varchar">
                    	AND spv.siteid = '#requestObject.getVar('siteid')#:published'
                </cfquery>
            </cfloop>
            
            <cfif getowner.username NEQ "">
            	<cfset arrayappend(ownera, getowner.username)>
			<cfelse>
            	<cfthrow message="page #doq.id# has no owner">
            </cfif>
        </cfloop>
        
        <cfset queryaddcolumn(doq, 'owneremail', ownera)>
        
        <cfreturn doq>
    </cffunction>
    
</cfcomponent>