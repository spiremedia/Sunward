<cfcomponent name="tablecreator" output="false">
	<cffunction name="init" output="false">
		<cfset variables.cols = arraynew(1)>
		<cfset variables.data = "">
		<cfset variables.pagecnt = 25>
		<cfset variables.cntnt = arraynew(1)>
		<cfset variables.sortdir = "desc">
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="addcolumn" output="false">
		<cfargument name="label" required="true">
		<cfargument name="field" required="true">
		<cfargument name="sorttype" required="true">
		<cfargument name="customize">
		<cfset arrayappend(variables.cols, arguments)>
	</cffunction>
		
	<cffunction name="setRequestObj" output="false">
		<cfargument name="ro" required="true">
		<cfset variables.requestObj = arguments.ro>
		
		<cfif variables.requestObj.isformurlvarset('page')>
			<cfset variables.cpage = variables.requestObj.getformurlvar('page')>
		<cfelse>
			<cfset variables.cpage = 1>
		</cfif>
		
	</cffunction>
	
	<cffunction name="setQuery" output="false">
		<cfargument name="data" required="true">
		<cfset variables.data = arguments.data>
		<!--- <cfquery dbtype="query" name="variables.data">
			SELECT * FROM variables.data ORDER BY #variables.data#
		</cfquery> --->
	</cffunction>

	<cffunction name="setPage" output="false">
		<cfargument name="pagecnt" required="true">
		<cfset variables.pagecnt = arguments.pagecnt>
	</cffunction>
	
	<cffunction name="setInfo" output="false">
		what does this do
	</cffunction>
	
	<cffunction name="setpaging" access="private" output="false">
		<cfset var addtlinfo = variables.requestObj.getAllFormUrlVars()>
		<cfset var itm = "">
		<cfset var addtlsearch = arraynew(1)>
		<cfset var i = "">
		<cfset var pageinginfo = structnew()>
		
		<cfset pageinginfo.totalpages = ceiling(variables.data.recordcount / variables.pagecnt)>
		
		<cfif pageinginfo.totalpages LTE 1>
			<cfreturn>
		</cfif>
					
		<cfset structdelete(addtlinfo, 'page')>
		<cfset structdelete(addtlinfo, 'action')>
		<cfset structdelete(addtlinfo, 'module')>
		<!-- prep the sort url to keep any other variables in form or url -->
		<!--->
		<cfset structdelete(addtlinfo, 'sortkey')>
		<cfset structdelete(addtlinfo, 'sortdir')>
		--->
		
		
		<cfloop collection="#addtlinfo#" item="itm"> 
			<cfset arrayappend(addtlsearch, itm & '=' & urlencodedformat(addtlinfo[itm]))>
		</cfloop>
		
		<cfif not structkeyexists(variables,'requestObj')>
			<cfthrow message="request Object is required by tablecreator">
		</cfif>
		
		<!--->
		<cfif structkeyexists(addtlinfo, "sortkey")>
			<cfset pageinginfo.sortkeytxt = '&sortkey=' & addtlinfo.sortkey>
		<cfelse>
			<cfset pageinginfo.sortkeytxt = "">
		</cfif>
		
		<cfif structkeyexists(addtlinfo, "sortdir")>
			<cfset pageinginfo.sortdirtxt = '&sortdir=' & addtlinfo.sortdir>
		<cfelse>
			<cfset pageinginfo.sortdirtxt = "">
		</cfif>
		--->

		<cfif variables.cpage EQ 1>
			<cfset pageinginfo.prev = "Prev">
		<cfelse>
			<cfset pageinginfo.prev = "<a href='?page=#variables.cpage-1#">
			<!---><cfset pageinginfo.prev = pageinginfo.prev & pageinginfo.sortkeytxt>
			<cfset pageinginfo.prev = pageinginfo.prev & pageinginfo.sortdirtxt>--->
			<cfset pageinginfo.prev = pageinginfo.prev & "&#arraytolist(addtlsearch,'&')#'>Prev</a>">
		</cfif>
		
		<cfif variables.cpage EQ pageinginfo.totalpages>
			<cfset pageinginfo.next = "Next">
		<cfelse>
			<cfset pageinginfo.next = "<a href='?page=#variables.cpage+1#">
		<!--->	<cfset pageinginfo.next = pageinginfo.next & pageinginfo.sortkeytxt>
			<cfset pageinginfo.next = pageinginfo.next & pageinginfo.sortdirtxt>--->
			<cfset pageinginfo.next = pageinginfo.next & "&#arraytolist(addtlsearch,'&')#'>Next</a>">
		</cfif>
		
		<cfset pageinginfo.between = "">
		<cfif pageinginfo.totalpages NEQ 1>
			<cfloop from="1" to="#pageinginfo.totalpages#" index="i">
				<cfif i NEQ variables.cpage>
					<cfset pageinginfo.between = pageinginfo.between & " <a href='?page=#i#">
					<!---><cfset pageinginfo.between = pageinginfo.between & pageinginfo.sortkeytxt>
					<cfset pageinginfo.between = pageinginfo.between & pageinginfo.sortdirtxt>--->
					<cfset pageinginfo.between = pageinginfo.between & "&#arraytolist(addtlsearch,'&')#'>#i#</a> ">
				<cfelse>
					<cfset pageinginfo.between = pageinginfo.between & " #i# ">
				</cfif>
				
			</cfloop>
		</cfif>
		
		<cfset add('Currently on page #variables.cpage# of #pageinginfo.totalpages#')>
		<cfset add(pageinginfo.prev)>
		<cfset add(pageinginfo.between)>
		<cfset add(pageinginfo.next)>

	</cffunction>
	
	<cffunction name="sethead" access="private" output="false">
		<cfset var addtlinfo = variables.requestObj.getAllFormUrlVars()>
		<cfset var addtlsearch = arraynew(1)>
		<cfset var itm = "">
		
		<!-- prep the sort url to keep any other variables in form or url -->
		<cfset structdelete(addtlinfo, 'action')>
		<cfset structdelete(addtlinfo, 'module')>
		<cfset structdelete(addtlinfo, 'sortkey')>
		<cfset structdelete(addtlinfo, 'sortdir')>
	
		<cfloop collection="#addtlinfo#" item="itm"> 
			<cfset arrayappend(addtlsearch, itm & '=' & urlencodedformat(addtlinfo[itm]))>
		</cfloop>
		
		<cfif not structkeyexists(variables,'requestObj')>
			<cfthrow message="request Object is required by tablecreator">
		</cfif>
		
		<cfset add('<table class="list">')>
		<cfset add("<thead><tr>")>
		<cfloop from="1" to="#arraylen(variables.cols)#" index="colindx">
			<cfset add("<th>")>
			<cfset add("<a href='?sortkey=#cols[colindx].field#&sortdir=#variables.sortdir#&#arraytolist(addtlsearch,'&')#'>")>
			<cfset add(cols[colindx].label)>
			<cfset add('</a>')>
			<cfset add("</th>")>
		</cfloop>
		<cfset add('</tr></thead>')>
	</cffunction>
	
	<cffunction name="setFooter" access="private" output="false">
		<cfset add('</table>')>
	</cffunction>
	
	<cffunction name="setgrid" access="private">
		<cfset var start = variables.cpage*pagecnt - pagecnt + 1>
		<cfset var end = start + pagecnt>
		<cfset var cstm = "">
		<cfset var ccstmcolindx = "">
		<cfset var row = "">
		<cfset var colitm = "">
		
		
		<cfif end GT variables.data.recordcount>
			<cfset end = variables.data.recordcount>
		</cfif>
		
		<cfif variables.data.recordcount EQ 0>
			<cfset add("<tr><td colspan='#arraylen(variables.cols)#'>No records were found</td></tr>")>
			<cfreturn>
		</cfif>

		<cfloop from="#start#" to="#end#" index="row">
		<cfset add("<tr>")>
		<cfloop from="1" to="#arraylen(variables.cols)#" index="colindx">
			<cfset add("<td>")>
			<cfif structkeyexists(variables.cols[colindx],'customize')>
				<cfset cstm = variables.cols[colindx].customize>
				<cfloop list="#variables.data.columnlist#" index="colitm">
					<cfset cstm = replacenocase(cstm,"[#colitm#]", variables.data[colitm][row],"all")>
				</cfloop>
				<cfset add(cstm)>
			<cfelseif variables.cols[colindx].sorttype EQ 'date'>
				<cfset add(dateformat(variables.data[variables.cols[colindx].field][row], 'mm/dd/yyyy'))>
			<cfelseif variables.cols[colindx].sorttype EQ 'datetime'>
				<cfset add(dateformat(variables.data[variables.cols[colindx].field][row], 'mm/dd/yyyy') & ' ' & timeformat(variables.data[variables.cols[colindx].field][row], "hh:mm tt"))>
			<cfelse>
				<cfset add(variables.data[variables.cols[colindx].field][row])>
			</cfif>
			<cfset add("</td>")>
		</cfloop>
		<cfset add("</tr>")>
		</cfloop>
	
	</cffunction>
	
	<cffunction name="sortdata" output="false">
		<cfquery dbtype="query" name="variables.data">
			SELECT * FROM variables.data ORDER BY #variables.sortkey# #variables.sortdir#
		</cfquery>
	</cffunction>
	
	<cffunction name="showHtml" output="false">
		
		<cfif variables.requestObj.isformurlvarset('sortkey')>
			<cfset variables.sortkey = variables.requestObj.getformurlvar('sortkey')>
			<cfset variables.sortdir = variables.requestObj.getformurlvar('sortdir')>
			<cfset sortdata()>
			<cfif variables.sortdir EQ 'desc'>
				<cfset variables.sortdir = 'asc'>
			<cfelse>
				<cfset variables.sortdir = 'desc'>
			</cfif>
		</cfif>
		
		<cfif arraylen(variables.cols) EQ 0>
			<cfthrow message="a table must have some columns">
		</cfif>
		
		<cfif not isquery(variables.data)>
			<cfthrow message="Please set some data">
		</cfif>
		
		<cfset setpaging()>
		
		<cfset sethead()>
		
		<cfset setgrid()>
		
		<cfset setfooter()>

		<cfreturn arraytolist(variables.cntnt,"#chr(13)##chr(10)#")>
	</cffunction>
	
	<cffunction name="add" output="false">
		<cfargument name="s" required="true">
		<cfset arrayappend(variables.cntnt, s)>		
	</cffunction>
</cfcomponent>