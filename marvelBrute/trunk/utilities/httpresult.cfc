<cfcomponent name="http" output="false">
	<cffunction name="init"  output="false">
		<cfargument name="result">
		<cfset variables.result = arguments.result>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getCookies"  output="false">
		<cfset var l = structnew()>
		<cfset l.cookies = structnew()>
		<cfif isdefined("variables.result.responseheader.set-cookie")>
			<cfset l.resHeadCookies = variables.result.responseheader['set-cookie']>
			<cfloop collection="#l.resHeadCookies#" item="l.cidx">
				<cfset l.cstr = l.resHeadCookies[l.cidx]>
				<cfset l.cstra = listtoarray(l.resHeadCookies[l.cidx],";")>
				<cfset l.tmp = structnew()>
				<cfset l.name = listfirst(l.cstra[1],"=")>
				<cfset l.tmp.name = listfirst(l.cstra[1],"=")>
				<cfset l.tmp.val = listlast(l.cstra[1],"=")>
				<cfloop from="2" to="#arraylen(l.cstra)#" index="l.cstridx">
					<cfset l.tmp[listfirst(l.cstra[l.cstridx],"=")] = listlast(l.cstra[l.cstridx],"=")>
				</cfloop>
				<cfset l.cookies[l.name] = l.tmp>
			</cfloop>
		</cfif>
		<cfreturn l.cookies>
	</cffunction>
	
	<cffunction name="getStatus"  output="false">
		<cfreturn val(variables.result.statusCode)>
	</cffunction>
	
	<cffunction name="getHTML"  output="false">
		<cfreturn variables.result.filecontent>
	</cffunction>
	
	<cffunction name="getESMFormFields"  output="false">
		<cfargument name="formname" default="any">
		<cfset var l = structnew()>
		<cfset l.fields = structnew()>
		<cfset l.html = getHTML()>

		<!--- find all hidden, text, input fields --->
		<cfset l.formA = reMatchNoCase("<input type='(text|password|hidden)' name='[^\']+' id='[^\']+' value=""([^""]+)?""", l.html)>
		
		<cfloop array="#l.formA#" index="l.str">
			<cfset l.nameinfo = refindnocase("name='([^\']+)'", l.str, 1, true)>
			<cfset l.fields[ mid(l.str, l.nameinfo.pos[2], l.nameinfo.len[2] )] = 1>
		</cfloop>
		
		<!--- textarea --->
		<cfset l.formA = reMatchNoCase("<textarea name='[^\']+' id='[^\']+' >([^""]+)?</textarea>", l.html)>
		<cfloop array="#l.formA#" index="l.str">
			<cfset l.nameinfo = refindnocase("name='([^\']+)'", l.str, 1, true)>
			<cfset l.fields[ mid(l.str, l.nameinfo.pos[2], l.nameinfo.len[2] )] = 1>
		</cfloop>
		
		<!--- find all select --->
		<cfset l.formA = reMatchNoCase("<select id=""[^\""]+"" name=""[^\""]+""", l.html)>
		<cfloop array="#l.formA#" index="l.str">
			<cfset l.nameinfo = refindnocase("name=""([^\""]+)""", l.str, 1, true)>
			<cfset l.fields[ mid(l.str, l.nameinfo.pos[2], l.nameinfo.len[2] )] = 1>
		</cfloop>

		<!--- find all radio, checkbox	 --->
		<cfset l.formA = reMatchNoCase("<input type='(checkbox|radio)' id='[^\']+' (checked)?  name='[^\']+' value=""([^""]+)?""", l.html)>
		<cfloop array="#l.formA#" index="l.str">
			<cfset l.nameinfo = refindnocase("name='([^\']+)'", l.str, 1, true)>
			<cfset l.fields[ mid(l.str, l.nameinfo.pos[2], l.nameinfo.len[2] )] = 1>
		</cfloop>
		
		<cfreturn structkeylist(l.fields)>
	</cffunction>
	
	<cffunction name="getESMFormStruct" output="false">
		<cfset var fields = getEsmFormFields()>
		<cfset var items = structnew()>
		<cfset var l = structnew()>
		<cfloop list="#fields#" index="l.idx">
			<cfset items[l.idx] = getEsmFormFieldValue(l.idx)>
		</cfloop>
		<cfreturn items>
	</cffunction>
	
	<cffunction name="getESMFormFieldValue" output="false">
		<cfargument name="field">
		<cfset var l = structnew()>
		<cfset l.html = getHTML()>
		<cfset l.val = "">
		<!--- find all hidden, text, input fields --->
		<cfset l.formA = reMatchNoCase("<input type='(text|password|hidden)' name='#field#' id='[^\']+' value=""([^""]+)?""", l.html)>

		<cfloop array="#l.formA#" index="l.str">
			<cfset l.re = refindnocase("value=""([^\""]+?)?""", l.str, 1, true)>
			<cfif l.re.len[2] NEQ 0>
				<cfset l.val =  listappend(l.val, mid(l.str, l.re.pos[2], l.re.len[2] ))>
			</cfif>
		</cfloop>
		
		<!--- textarea --->
		<cfset l.formA = reMatchNoCase("<textarea name='#field#' id='[^\']+' >([^<]+)?</textarea>", l.html)>
		<cfloop array="#l.formA#" index="l.str">
			<cfset l.re = refindnocase(">([^<]+)<", l.str, 1, true)>
			<cfset l.val = listappend(l.val, mid(l.str, l.re.pos[2], l.re.len[2] ))>
		</cfloop>

		<!--- find all select --->
		<cfset l.start = refindnocase("<select[^>]+name=""#field#""", l.html)>
		<cfif l.start NEQ 0>
			<cfset l.end = refindnocase("</select>", l.html, l.start)>
			<cfset l.formA = reMatchNoCase("<option selected  value=""([^""]+?)""", mid(l.html, l.start, l.end - l.start))>
			<cfloop array="#l.formA#" index="l.str">
				<cfset l.nameinfo = refindnocase("value=""([^\""]+)""", l.str, 1, true)>
				<cfset l.val = listappend(l.val, mid(l.str, l.nameinfo.pos[2], l.nameinfo.len[2] ))>
			</cfloop>
		</cfif>

		<!--- find all radio, checkbox	 --->
		<cfset l.formA = reMatchNoCase("<input type='(checkbox|radio)' id='[^\']+' checked  name='#field#' value=""([^""]+)?""", l.html)>
		<cfloop array="#l.formA#" index="l.str">
			<cfset l.nameinfo = refindnocase("value=""([^\""]+)""", l.str, 1, true)>
			<cfset l.val = mid(l.str, l.nameinfo.pos[2], l.nameinfo.len[2] )>
		</cfloop>
		
		<cfreturn l.val>
	</cffunction>
	
	<cffunction name="getESMSubmitsTo" output="false">
		<cfset var l = structnew()>
		<cfset l.html = getHTML()>
		<!--- maybe text, password, or hidden --->
		<cfset rl.findinfo = refindnocase("ajaxWResponseJsCaller\('([^\']+)',myForm\);", l.html, 1, true)>
		
		<cfif rl.findinfo.len[2] EQ 0>
			<cfreturn "">
		</cfif>
		
		<cfset l.val = mid(l.html, rl.findinfo.pos[2], rl.findinfo.len[2])>
		
		<cfreturn l.val>
	</cffunction>
	
	<cffunction name="existsByPattern"  output="false">
		<cfargument name="re">
		<cfreturn refindnocase(re,getHTML())>
	</cffunction>
	
	<cffunction name="getByPattern" output="false">
		<cfargument name="re">
		
		<cfset var l = structnew()>
		
		<cfset l.html = getHTML()>
		
		<cfset l.findinfo = refindnocase(re, l.html, 1, true)>
		
		<cfif l.findinfo.pos[1] EQ 0>
			<cfreturn "">
		</cfif>
		
		<cfreturn mid(l.html, l.findinfo.pos[1], l.findinfo.len[1])>
	</cffunction>
	
	<cffunction name="getESMErrors"  output="false">
		<cfset var l = structnew()>
		<cfset l.fields = structnew()>
		<!--- do something here --->
		<cfreturn l.fields>
	</cffunction>
	
	<cffunction name="is302relocate"  output="false">
		<cfset var findinfo = "">
		<cfif getstatus() EQ '302'>
			<cfset findinfo = refindnocase("location: ([^ ]+) ", result.header, 1, true)>
			<cfreturn mid(result.header, findinfo.pos[2], findinfo.len[2])>
		</cfif>
		<cfreturn 0>
	</cffunction>
	
	<cffunction name="isESMrelocate"  output="false">
		<cfset var l = structnew()>
		
		<cfif IsJSON(getHTML()) >
			<cfset l.j = deserializeJson(trim(getHTML()))>
			<cfif isdefined("l.j.relocate")>
				<cfreturn 1>
			</cfif>
		</cfif>
		
		<cfreturn 0>
	</cffunction>
	
	<cffunction name="dump">
		<cfdump var=#variables.result#>
		<cfabort>
	</cffunction>
</cfcomponent>