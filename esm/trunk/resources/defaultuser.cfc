<cfcomponent name="defaultuser" output="False">
	
	<cffunction name="init" output="False">
		<cfset this.security = createObject('component','security').init()>
		<cfset variables.flashItems = arraynew(1)>
		
		<cfif isdefined("cookie.currentSiteId")>
			<cfset variables.currentSiteId = cookie.currentSiteId>
		<cfelse>
			<cfset variables.currentSiteId = 0>
		</cfif>
		
		<cfset variables.super = 0>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="isallowed" output="False">
		<cfargument name="module">
		<cfargument name="verb">
		
		<cfif issuper()>
			<cfreturn true>
		</cfif>
		
		<cfif not structkeyexists(variables, 'rights')>
			<cfset relogin()>
		</cfif>
		
		<cfif not structkeyexists(variables.rights, module)>
			<cfreturn 0>
		</cfif>
		
		<cfif not structkeyexists(variables.rights[module], verb)>
			<cfreturn 0>
		</cfif>
		
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="isPathAllowed">
		<cfargument name="path" required="true">
		
		<cfset var allowedpath = "">
		<cfset var pathlen = "">
		
		<cfif issuper()>
			<cfreturn true>
		</cfif>
		
		<cfif path EQ "">
			<cfreturn structkeyexists(variables.locationpaths, "_")>
		</cfif>
		
		<cfset pathlen = len(path)>
		
		<cfloop collection="#variables.locationpaths#" item="allowedpath">
			<cfif left(arguments.path, pathlen) EQ allowedpath>
				<cfreturn true>
			</cfif>
		</cfloop>
		
		<cfreturn false>
	</cffunction>
	
	<cffunction name="isDescendentPathAllowed">
		<cfargument name="path" required="true">
		
		<cfset var allowedpath = "">
		<cfset var pathlen = "">
		
		<cfif issuper()>
			<cfreturn true>
		</cfif>
		
		<cfif path EQ "">
			<cfreturn structkeyexists(variables.locationpaths, "_")>
		</cfif>
		
		<cfloop collection="#variables.locationpaths#" item="allowedpath">
			<cfset pathlen = len(allowedpath)>
			<cfif left(arguments.path, pathlen) EQ allowedpath>
				<cfreturn true>
			</cfif>
		</cfloop>
		
		<cfreturn false>
	</cffunction>
	
	<cffunction name="setUsername" output="False">
		<cfargument name="username">
		<cfset variables.username = arguments.username>
	</cffunction>
	
	<cffunction name="setFirstName" output="False">
		<cfargument name="fname">
		<cfset variables.fname = arguments.fname>
	</cffunction>
	
	<cffunction name="setLastName" output="False">
		<cfargument name="lname">
		<cfset variables.lname = arguments.lname>
	</cffunction>
	
	<cffunction name="setUserID" output="False">
		<cfargument name="id">
		<cfset variables.id = arguments.id>
	</cffunction>
	
	<cffunction name="getUserID" output="False">
		<cfreturn variables.id>
	</cffunction>
	
	<cffunction name="getUsername" output="False">
		<cfreturn variables.username>
	</cffunction>

	<cffunction name="getFirstName" output="False">
		<cfreturn variables.fname>
	</cffunction>
	
	<cffunction name="getLastName" output="False">
		<cfreturn variables.lname>
	</cffunction>
	
	<cffunction name="getFullName" output="False">
		<cfreturn variables.fname & ' ' & variables.lname>
	</cffunction>
	
	<cffunction name="setCurrentSiteUrl" output="False">
		<cfargument name="url">
		<cfset variables.currentsiteurl = arguments.url>
	</cffunction>
	
	<cffunction name="getCurrentSiteUrl" output="False">
		<cfreturn trim(variables.currentsiteurl)>
	</cffunction>
		
	<cffunction name="issuper" output="False">
		<cfreturn variables.super>
	</cffunction>
	
	<cffunction name="setsuper" output="False">
		<cfargument name="super">
		<cfset variables.super = arguments.super>
	</cffunction>
	
	<cffunction name="getCurrentSiteID" output="False">
		<cfset var s = "">
		
		<cfif variables.currentSiteId EQ 0>
			<cfset s = application.sites.getSites()>
			<cfif s.recordcount EQ 1>
				<cfset variables.currentSiteId = s.id>
				<cfset loadUserRightsandLocations()>
			<cfelseif s.recordcount EQ 0>
				<cfthrow message="There must be at least one site to login">
			</cfif>
		</cfif>
		
		<cfreturn variables.currentSiteId>
	</cffunction>
	
	<cffunction name="setCurrentSiteId" output="False">
		<cfargument name="siteid">
		<cfargument name="sites">
		
		<cfset var t = "">
		<cfset var s = sites.getSites()>

		<cfif listfind(valuelist(s.id), arguments.siteid)>
			<cfset variables.currentSiteId = arguments.siteid>
			<cfset loadUserRightsandLocations()>
			<cfset t = sites.getSite(variables.currentsiteid)>
			<cfset setCurrentSiteUrl(t.url)>
		<cfelse>
			<cfthrow message="id '#arguments.siteid#' is not valid">
		</cfif>
		
	</cffunction>
	
	<cffunction name="loadUserRightsandLocations" output="False">
		<cfset var requestObject = application.settings.makeRequestObject()>
		<cfset requestObject.setVar('userid', getUserId())>
		<cfset loadUserRights( createObject('component','permissionLevel.controller').GetUserRights(requestObject, this) )>
		<cfset loadUserLocations( createObject('component','contentGroups.controller').getUserLocations(requestObject, this) )>
		<!--- set top page that user is allowed to access --->
		<cfset loadUserTopAllowedLocation(requestObject)>
	</cffunction>
	
	<cffunction name="loadUserRights" output="False">
		<cfargument name="rights">
		<cfset variables.rights = structnew()>
		<cfoutput query="rights" group="modulename">
			<cfset variables.rights[modulename] = structnew()>
			<cfoutput>
				<cfset variables.rights[modulename][itemname] = 1>
			</cfoutput>
		</cfoutput>
	</cffunction>
	
	<cffunction name="loadUserLocations" output="False">
		<cfargument name="locations">

		<cfset variables.locationids = structnew()>
		<cfset variables.locationpaths = structnew()>
		
		<cfloop query="locations">
			<cfset variables.locationids[pageid] = 1>
			<cfif urlpath EQ "">
				<cfset variables.locationpaths["_"] = 1>
			<cfelse>
				<cfset variables.locationpaths[urlpath] = 1>
			</cfif>
		</cfloop>
		
	</cffunction>	
	
	<cffunction name="loadUserTopAllowedLocation" output="False">
		<cfargument name="requestObject" required="true">
		<cfset var arrAllowedTopPagePath = arrayNew(1)>
		<cfset var stAllowedPaths = getAllowedPaths()>
		<cfset var totalAllowedPaths = StructCount(stAllowedPaths)>
		<cfset var listAllowedPaths = StructKeyList(stAllowedPaths)>
		
		<cfset variables.locationTopAllowedID = ''>
		<cfset variables.locationTopAllowedPath = ''>
		<cfset variables.locationTopAllowedParentID = 'null'>

		<!--- if user is only allowed to access one page, set it as the top allowed page --->
		<cfif totalAllowedPaths eq 1>
			<cfset variables.locationTopAllowedPath = ListGetAt(listAllowedPaths,1)>
		<cfelseif totalAllowedPaths gt 1>
			<!--- loop through each allowed page --->
			<cfloop from="1" to="#totalAllowedPaths#" index="i">
				<cfset tempPath = ListGetAt(listAllowedPaths,i)>
				<cfset arrTempPath = ListToArray(tempPath,"/")>
				<!--- loop through each allowed pages' parents --->
				<cfloop from="1" to="#arrayLen(arrTempPath)#" index="j">
					<cfif (i eq 1)>
						<!--- set up array of common parents --->
						<cfset arrayAppend(arrAllowedTopPagePath,arrTempPath[j])>
					<cfelseif (arrayLen(arrAllowedTopPagePath) gte j) AND (arrAllowedTopPagePath[j] eq arrTempPath[j])>
						<!--- do nothing, continue looping and comparing parents --->
					<cfelseif (arrayLen(arrAllowedTopPagePath) gte j) AND (arrAllowedTopPagePath[j] neq arrTempPath[j])>
						<!--- stop comparing parents for this path --->
						<cfset totalToRemove = arrayLen(arrAllowedTopPagePath) - j + 1>
						<cfloop from="1" to="#totalToRemove#" index="k">
							<!--- delete from array uncommon parents --->
							<cfset ArrayDeleteAt(arrAllowedTopPagePath, j)>
						</cfloop> 
						<cfbreak>
					</cfif>
				</cfloop>
				<cfif (arrayLen(arrAllowedTopPagePath) lt 1)>
					<!--- break if only the root parent is in common --->
					<cfbreak>
				</cfif>
			</cfloop>
			<cfif (arrayLen(arrAllowedTopPagePath) eq 1)>
				<cfset variables.locationTopAllowedPath = arrAllowedTopPagePath[1] & "/">
			<cfelse>
				<cfset variables.locationTopAllowedPath = ArrayToList(arrAllowedTopPagePath,"/")>
			</cfif>
		</cfif>
		<!--- set id of most common parent --->
		<cfset qry = createObject('component','pages.controller').getPageByPath(arguments.requestObject, this, variables.locationTopAllowedPath, "published")>
		<cfif qry.recordcount>
			<cfset variables.locationTopAllowedID = qry.id>
			<cfset variables.locationTopAllowedParentID = iif((qry.parentid neq ''),"qry.parentid",DE("null"))>
		</cfif>

	</cffunction>
	
	<cffunction name="getLocationTopAllowedID" output="False">
		<cfif isdefined("variables.locationTopAllowedID")>
			<cfreturn variables.locationTopAllowedID>
		</cfif>
		
		<cfreturn ''>
	</cffunction>
	
	<cffunction name="getLocationTopAllowedParentID" output="False">
		<cfif isdefined("variables.locationTopAllowedParentID")>
			<cfreturn variables.locationTopAllowedParentID>
		</cfif>
		
		<cfreturn 'null'>
	</cffunction>
	
	<cffunction name="getLocationTopAllowedPath" output="False">
		<cfif isdefined("variables.locationTopAllowedPath")>
			<cfreturn variables.locationTopAllowedPath>
		</cfif>
		
		<cfreturn ''>
	</cffunction>
	
	<cffunction name="getAllowedLocationIds" output="False">
		<cfif isdefined("variables.locationids")>
			<cfreturn variables.locationids>
		</cfif>
		
		<cfreturn structnew()>
	</cffunction>
	
	<cffunction name="getAllowedPaths" output="False">
		<cfif isdefined("variables.locationpaths")>
			<cfreturn variables.locationpaths>
		</cfif>
		
		<cfreturn structnew()>
	</cffunction>
	
	<cffunction name="showflash" output="False">
		<cfargument name="html">
		<cfif arraylen(variables.flashITems)>
			<cfreturn "<ul><li>" & arraytolist(variables.flashItems,"</li><li>") & "</li></ul>">
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>
	
	<cffunction name="dump" output="False">
		<cfdump var=#variables#>
        <cfabort>
	</cffunction>
	
	<cffunction name="relogin" output="False">
		<cfargument name="reason" default="">
		<cfargument name="view" default="normal">
		
		<cfset logout()>
		
		<cfif arguments.view EQ 'normal'>
			<cflocation url="/login/loginForm/?logout&#reason#" addtoken="no">
		<cfelse>
			<cfcontent reset="true">relogin<cfabort>
		</cfif>
	</cffunction>
	
	<cffunction name="logout">
		do something
	</cffunction>
	
	<cffunction name="isloggedin" output="False">
		<cfif structkeyexists(variables, 'id') 
				AND variables.id NEQ "">
			<cfreturn 1>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
	
</cfcomponent>