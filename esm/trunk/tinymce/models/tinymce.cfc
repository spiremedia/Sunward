<cfcomponent name="model" output="false" extends="resources.abstractModel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getJSPageList" output="false">
		<cfargument name="sitepages" required="true">
	
		<cfset var jslist = "">

		<cfsavecontent variable="jslist">
			<cfoutput>
			var tinyMCELinkList = new Array(
			<cfloop query="sitepages">
				["#replace(pagename,'"','', 'ALL')#", "#urlpath#"]#iif((sitepages.recordcount neq sitepages.currentrow),DE(","),DE(""))#
			</cfloop>
			);
			</cfoutput>
		</cfsavecontent>

		<cfreturn jslist/>
	</cffunction>
	
	<cffunction name="getJSImageList" output="false">
		<cfargument name="siteimages" required="true">
	
		<cfset var jslist = "">
		
		<cfquery name="assetList" dbtype="query">
			SELECT	name, filename, id
			FROM		siteimages
			ORDER BY	name
		</cfquery>

		<cfsavecontent variable="jslist">
			<cfoutput>
				var tinyMCEImageList = new Array(
					<cfloop query="assetList">
						<cfif listfindnocase(".jpg,.png,.gif,.jpeg", right(filename,4))>
							["#name#", "/assets/viewImage/?id=#id#"]#iif((assetList.recordcount neq assetList.currentrow),DE(","),DE(""))#
						</cfif>
					</cfloop>
				);
			</cfoutput>
		</cfsavecontent>		

		<cfreturn jslist/>
	</cffunction>
	
</cfcomponent>