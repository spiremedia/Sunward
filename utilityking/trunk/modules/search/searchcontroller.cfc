<cfcomponent extends="resources.abstractController" ouput="false">

	<cffunction name="init" output="false">
		<cfargument name="requestObject" required="yes">
        <cfargument name="collectionName" required="yes">
		<cfset var searchinfo = structnew()>
        
		<cfset variables.requestObject = arguments.requestObject>
        <cfset variables.collectionName = arguments.collectionname>		
        <cfset variables.searchresults = "">		

		<cfif NOT variables.requestObject.isformurlvarset('search')>
        	<cfreturn this>
        </cfif>
        
		<cfset variables.criteria = variables.requestObject.getformurlvar('search')>
        <cfset variables.rowCount = 10>
        
        <cfif variables.requestObject.isFormUrlVarSet('page')>
            <cfset variables.page = variables.requestObject.getFormUrlVar('page')>
            <cfparam name="variables.page" type="integer">
            <cfset variables.startrow = variables.page * variables.rowCount - variables.rowCount + 1>
        <cfelse>
            <cfset variables.page = 1>
            <cfset variables.startrow = 1>
        </cfif>
        
        <cfset searchSite()>
        
		<cfreturn this>
	</cffunction>
    
	<cffunction name="searchSite" output="false">
		<cfset var result = "">
		<cfset var machineroot = requestObject.getVar('machineRoot')>
		
		<cfset checkCollectionExists()>
		
		<cfsearch name="result"
			collection="#variables.collectionName#" 
				criteria="#lcase(variables.criteria)#">

		<cfset variables.totalSearchRecords = result.recordcount>

		<cfquery name="result" dbtype="query" maxrows="#variables.rowcount#">
			SELECT *
			FROM result
			WHERE CAST(rank as INTEGER) >= <cfqueryparam cfsqltype="cf_sql_integer" value="#variables.startrow#">
		</cfquery>
		
		<cfloop query="result">
			<!--- <cfset result.url[currentrow] = replace(result.key, machineroot, "")> --->
			<cfset result.url[currentrow] = replace(result.url, "\", "/", "all")>
		</cfloop>
							
		<cfset saveSearchCriteria()>
		<cfset variables.searchResults = result>
        
	</cffunction>
	
	<cffunction name="checkCollectionExists" outpout="false">
		<cfset var qryCollections = "">
		<cfset var collectionList = "">
		
		<cfcollection action="list" name="qryCollections">
		<cfset collectionList = ValueList(qryCollections.name)>

		<cfif not ListFindNoCase(collectionList,variables.collectionName)>
			<cfcollection action="create" collection="#variables.collectionName#" path="#variables.requestObject.getVar('collectionPath')#">
		</cfif>

		<cfreturn>
	</cffunction>
	
	<cffunction name="saveSearchCriteria">
		<cfset var id = createuuid()>
		<cfset var criteria = variables.criteria>
		
		<cfif len(criteria) gt 100>
			<cfset criteria = left(criteria,100)>
		</cfif>
		
		<cfquery name="currentpages" datasource="#variables.requestObject.getVar('dsn')#">
			INSERT INTO siteSearches (
				id,
				criteria,
				recordsfound,
				siteid
			) VALUES (
				<cfqueryparam value="#id#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#criteria#" cfsqltype="cf_sql_varchar" maxlength="100">,
				<cfqueryparam value="#variables.totalSearchRecords#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.requestObject.getVar('siteid')#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
	</cffunction>
	
	<cffunction name="renderPaging" output="false">
		<cfset var lcl = structnew()>
	
		<cfsavecontent variable="lcl.html">
			<cfoutput>
			<div class="srchpaging">
			<cfif variables.page NEQ 1 AND variables.totalSearchRecords GTE variables.rowcount>
				<a href="?page=#variables.page-1#&search=#variables.criteria#">Previous</a>
			<cfelse>
				Previous
			</cfif>
			
			<cfif variables.totalSearchRecords GTE variables.rowcount>
				<cfset lcl.startLoop = 1>
				<cfset lcl.endLoop = ceiling(variables.totalSearchRecords / variables.rowcount)>
				<cfloop from="#lcl.startLoop#" to="#lcl.endLoop#" index="lcl.indx">
					<cfif variables.page EQ lcl.indx>
						<cfif lcl.endLoop gt 7 AND lcl.indx eq 3>
							..
						</cfif>
						<b>#lcl.indx#</b>
						<cfif lcl.endLoop gt 7 AND lcl.indx gte 7 AND lcl.indx neq lcl.endLoop AND lcl.indx neq (lcl.endLoop - 1)>
							..
						</cfif>
					<cfelse>
						<!--- if lte 7 pages, show all page numbers --->
						<cfif lcl.endLoop lte 7>
							<a href="?page=#lcl.indx#&search=#variables.criteria#">#lcl.indx#</a>
						<!--- if gt 7 pages, show certain page numbers --->
						<cfelseif listfind("1,4,5,6,#lcl.endLoop#",lcl.indx)>
							<a href="?page=#lcl.indx#&search=#variables.criteria#">#lcl.indx#</a>
						<cfelseif listfind("3,7",lcl.indx)>
							..
						</cfif>
					</cfif>
				</cfloop>
			</cfif>
	
			<cfif variables.page NEQ ceiling(variables.totalSearchRecords / variables.rowcount)>
				<a href="?page=#variables.page+1#&search=#variables.criteria#">Next</a>
			<cfelse>
				Next
			</cfif>
			</div>
			</cfoutput>
		</cfsavecontent>

		<cfreturn lcl.html>
	</cffunction>
	
	<cffunction name="renderTopPaging" output="false">
		<cfset var lcl = structnew()>
	
		<cfsavecontent variable="lcl.html">
			<cfoutput>
				<div>
					<cfif requestObject.isFormUrlVarSet('search')>Results For: #requestObject.getFormUrlVar('search')#</cfif>
				</div>
				<br class="clear"/>
				<div>
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
					of #variables.totalSearchRecords# Results <br />
				</div>
				<cfif variables.totalSearchRecords GT variables.rowcount>
					#variables.renderPaging()#
				</cfif>
				<br class="clear"/>
			</cfoutput>
		</cfsavecontent>
		<cfreturn lcl.html>
	</cffunction>
	
	<cffunction name="showHTML" output="false">
		<cfset var lcl = structnew()>
	
		<cfsavecontent variable="lcl.html">
			<cfif isQuery(variables.searchResults)>
				<cfinclude template="templates/searchresults.cfm">
			<cfelse>
				Please use the search box on every page to search the site.
			</cfif>
		</cfsavecontent>
		<cfreturn lcl.html>
	</cffunction>
	
	<cffunction name="getCacheLength">
		<cfreturn 0>
	</cffunction>
</cfcomponent>