<cfcomponent name="querytotable" output="false">
	<cffunction name="init" output="false">
		<cfargument name="data">
		<cfset var headers = data.columnlist>
		<cfset var itm = "">
		<cfset var lines = arraynew(1)>
		<cfset var line = ''>
		<cfset arrayappend(lines, replace(headers,",","#chr(9)#","all")) >
		<cfoutput query="data">
			<cfset line = arraynew(1)>
			<cfloop list="#headers#" index="itm">
				<cfset arrayappend(line, trim(data[itm][data.currentrow]))>
			</cfloop>
			<cfset arrayappend(lines, arraytolist(line, "#chr(9)#"))>
		</cfoutput>
		<cfreturn arraytolist(lines,"#chr(13)##chr(10)#")>
	</cffunction>
</cfcomponent>