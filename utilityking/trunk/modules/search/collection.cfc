<cfcomponent>
	<cffunction name="init">
    	<cfargument name="requestObject" required="yes">
        <cfargument name="collectionName" required="yes">
        
        <cfset variables.requestObject = arguments.requestObject>
        <cfset variables.collectionname = arguments.collectionName>
        
        <cfset checkCollectionExists()>
        <cfset clearCollection()>
            
		<cfreturn this>
	</cffunction>
    
    <cffunction name="checkCollectionExists" outpout="false">
		<cfset var qryCollections = "">
		
		<cfset var collectionList = "">
		
		<cfcollection action="list" name="qryCollections">
		<cfset collectionList = ValueList(qryCollections.name)>

		<cfif not ListFindNoCase(collectionList,variables.collectionName)>
            <cfcollection action="create" collection="#variables.collectionname#" path="#variables.requestObject.getVar('collectionPath')#">
        </cfif>

		<cfreturn>
	</cffunction>
    
    <cffunction name="loadIndexables" output="true">
		<cfargument name="aggregator" required="yes">
		
		<cfset loadPageIndexables(aggregator)>
		<cfset loadFileIndexables(aggregator)>
		
		<cfabort>
	</cffunction> 	
	
	<cffunction name="loadPageIndexables" output="true">
		<cfargument name="aggregator" required="yes">
		<cfset var lcl = structnew()>
		
		<cfset lcl.q = querynew("key,urlpath,title,custom1,custom2,custom3,custom4,body")>
		
		<cfset items="#aggregator.getPageIndexables()#">	
		<!--- <cfdump var="#items#"><cfabort> --->

		<cfloop from="1" to="#arrayLen(items)#" index="x">
			<cfset queryaddrow(lcl.q)>
			<cfset querysetcell(lcl.q, 'key', 	items[x].getKey())>
			<cfset querysetcell(lcl.q, 'urlpath',	"/" & items[x].getPath() )>
			<cfset querysetcell(lcl.q, 'title',	items[x].getTitle() )>
			<cfset querysetcell(lcl.q, 'custom1',	items[x].getDescription() )>
			<cfset querysetcell(lcl.q, 'custom2',	'')>
			<cfset querysetcell(lcl.q, 'custom3',	'')>
			<cfset querysetcell(lcl.q, 'custom4',	'')>
			<cfset querysetcell(lcl.q, 'body', 	items[x].getPageHtml(requestObject.getVar('siteurl')) )>
		</cfloop>

		<cfif lcl.q.recordcount>
			<cfindex action="update" 
				status="r"
				collection="#variables.collectionName#" 
				query="lcl.q"
				key="key"
				type="custom"
				urlpath = "urlpath"
				title="title"
				custom1="custom1"
				custom2="custom2"
				custom3="custom3"
				custom4="custom4"
				body="custom1,custom2,custom3,custom4,body">
				
			Pages indexed
			<ul>
			<cfoutput query="lcl.q">
				<li>#title# #urlpath#</li>
			</cfoutput>
			</ul>
			<cfdump var="#r#">
		<cfelse>
			<div>No pages indexed.</div>
		</cfif>
	
	</cffunction>
	
	<cffunction name="loadFileIndexables" output="true">
		<cfargument name="aggregator" required="yes">
		<cfset var lcl = structnew()>
		
		<cfset lcl.q = querynew("key,urlpath,title,custom1,custom2,custom3,custom4")>

		<cfset items="#aggregator.getFileIndexables()#">	
		<cfloop from="1" to="#arrayLen(items)#" index="x">
			<cfset queryaddrow(lcl.q)>
			<cfset querysetcell(lcl.q, 'key', 	items[x].getPath(requestObject.getVar('cmsmachineroot')) )>
			<!--- <cfset querysetcell(lcl.q, 'urlpath',	> --->
			<cfset querysetcell(lcl.q, 'title',	items[x].getTitle() )>
			<cfset querysetcell(lcl.q, 'custom1',	items[x].getDescription() )>
			<cfset querysetcell(lcl.q, 'custom2',	'')>
			<cfset querysetcell(lcl.q, 'custom3',	'')>
			<cfset querysetcell(lcl.q, 'custom4',	'')>
			x <cfdump var="#x#"> <br>
			key <cfdump var="#items[x].getPath(requestObject.getVar('cmsmachineroot'))#"><br>
			title <cfdump var="#items[x].getTitle()#"><br>
			custom1 <cfdump var="#items[x].getDescription()#"><br><br>
		</cfloop>

		<cfif lcl.q.recordcount>
			<cfindex action="update" 
				status="r"
				collection="#variables.collectionName#" 
				query="lcl.q"
				key="key"
				type="file"
				urlpath = "urlpath"
				title="title"
				custom1="custom1"
				custom2="custom2"
				custom3="custom3"
				custom4="custom4"
				extensions="extensions">
			Files Indexed
			<ul>
			<cfoutput query="lcl.q">
				<li>#key#</li>
			</cfoutput>
			</ul>
			<cfdump var="#r#">
		<cfelse>
			<div>No files indexed.</div>
		</cfif>
	</cffunction>	
		    
    <cffunction name="clearCollection">
    	<cftry>
			<cfindex action="purge" collection="#variables.collectionName#">
			<cfcatch></cfcatch>
		</cftry>
    </cffunction>
    
    <cffunction name="optimizeCollection">
		<cfcollection action="optimize"  collection="#variables.collectionName#"> 
	</cffunction> 
    
</cfcomponent>