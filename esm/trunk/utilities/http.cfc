<cfcomponent name="http" output="false">
	<cffunction name="init">
		
		<cfset variables.cookies = structnew()>
		<cfset variables.formfields = structnew()>
		<cfset variables.urlfields = structnew()>
		<cfset variables.headerItems = structnew()>
		<cfset variables.xml = "">
		<cfset variables.url = "">
		<cfset variables.results = "">
		
		<cfreturn this>
	</cffunction>

	<cffunction name="getPage">
		<cfargument name="page">
		<cfset var r = "">
		<cfset var i = structnew()>
		
		<cfset i.idx = refindnocase("\.[a-zA-Z0-9]{2,3}/", page, 1, true)>
		
		<cfif i.idx.len[1] NEQ 0>
			<cfset i.host = left(page, i.idx.pos[1] + i.idx.len[1] -2)>
			<cfset i.path = mid(page, i.idx.pos[1] + i.idx.len[1] -1 , len(page))>
		<cfelse>
			<cfset i.host = page>
			<cfset i.path = "">
		</cfif>

		<cfset setHost(i.host)>
		<cfset setPath(i.path)>
		
		<cfset r = load()>

		<cfreturn r.getHTML()>
	</cffunction>
	

	<cffunction name="addCookie">
		<cfargument name="c" required="true">
		<cfargument name="v" required="true">
		
		<cfset variables.cookies[c] = v>
	</cffunction>
	
	<cffunction name="addHeaderItem">
		<cfargument name="c" required="true">
		<cfargument name="v" required="true">
		
		<cfset variables.headerItems[c] = v>
	</cffunction>
	
	<cffunction name="addUrlField">
		<cfargument name="f" required="true">
		<cfargument name="v" required="true">
		
		<cfset variables.urlfields[f] = v>
	</cffunction>
	
	<cffunction name="addFormField">
		<cfargument name="f" required="true">
		<cfargument name="v" required="true">
		
		<cfset variables.formfields[f] = v>
	</cffunction>
	
	<cffunction name="setXML">
		<cfargument name="f" required="true">
		<cfargument name="v" required="true">
		
		<cfset variables.formfields[f] = v>
	</cffunction>
	
	<cffunction name="setPath">
		<cfargument name="v" required="true">
		<cfset variables.path = arguments.v>
	</cffunction>
	
	<cffunction name="setHost">
		<cfargument name="v" required="true">
		<cfset variables.host = arguments.v>
	</cffunction>
	
	<cffunction name="clear">
		<cfargument name="f">
		<cfset var s = structnew()>
		<cfif NOT structkeyexists(arguments,'f')>
			<cfset init()>
		</cfif>
		<cfloop list="#f#" index="s.itm">
			<cfswitch expression="#s.itm#">
				<cfcase value="cookies,formfields,urlfields,headeritems">
					<cfset variables[s.itm] = structnew()>
				</cfcase>
				<cfdefaultcase>
					<cfset variables[f] = "">
				</cfdefaultcase>
			</cfswitch>
		</cfloop>
	</cffunction>

	<cffunction name="load">
		<cfargument name="dump" default="false">
		<cfset var l = structnew()>
		<cfset l.path = variables.path>
		
		<cfloop collection="#variables.urlfields#" item="l.idx">
			<cfif NOT find("?", l.path)>
				<cfset l.path = l.path & "?">
			<cfelse>
				<cfset l.url = l.path & "&">
			</cfif>
			<cfset l.path = l.path & l.idx & "=" & variables.urlfields[l.idx]>
		</cfloop>

		<!--- errro checking : if xml then no form fields allowed --->
		<cfif dump>
			<cfdump var=#l.path#>
			<cfdump var=#VARIABLES.FORMFIELDS#>
		</cfif>
		<cfhttp method="#iif(structisempty(variables.formfields), DE("GET"), DE("POST"))#" result="l.results" url="#variables.host##l.path#" redirect="false">
			<cfloop collection="#variables.cookies#" item="l.idx">
				<cfhttpparam type="cookie" name="#l.idx#" value="#variables.cookies[l.idx]#">
			</cfloop>
			<cfloop collection="#variables.headerItems#" item="l.idx">
				<cfhttpparam type="header" name="#l.idx#" value="#variables.headerItems[l.idx]#">
			</cfloop>
			<cfloop collection="#variables.formfields#" item="l.idx">
				<cfhttpparam type="formfield" name="#l.idx#" value="#variables.formfields[l.idx]#">
			</cfloop>
			<cfif variables.xml NEQ "">
				<cfhttpparam type="xml" value="#variables.xml#">
			</cfif>
		</cfhttp>
		<cfif dump><CFDUMP VAR=#L.RESULTS#><CFABORT></CFIF>
		<cfreturn createObject('component','utilities.httpresult').init(l.results)>
	</cffunction>
	

</cfcomponent>