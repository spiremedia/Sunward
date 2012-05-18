<cfcomponent name="filesystem">
	<cffunction name="init">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="iniparser" returntype="struct" output="false">
		
		<cfargument name="path" required="true">
		
		<cfset var iniString = "">
		<cfset var iniList = "">
		<cfset var iniStruct = structnew()>
	
		<cfif not fileexists(arguments.path)>
			<cfthrow message="file for ini not found">
		</cfif>
		
		<cffile action="read" file="#arguments.path#" variable="iniString">
		
		<cfset iniString = trim(iniString)>
		
		<cfset iniList = listtoarray(iniString, '#chr(13)##chr(10)#')>
		
		<cftry>
			<cfloop from="1" to="#arraylen(iniList)#" index="i">
				<cfset iniList[i] = trim(iniList[i])>
				<cfset iniStruct[trim(getToken(iniList[i],1, '='))] = trim(getToken(iniList[i],2, '='))>
			</cfloop>
			
			<cfcatch>
				<cfthrow message="Failed parsing ini file">
			</cfcatch>
		</cftry>
		
		<cfreturn iniStruct>
	</cffunction>
	
	<cffunction name="getDirectoryListing">
		<cfargument name="dir">
		<cfset var mydir = "">
		<cfdirectory action="list" directory="#arguments.dir#" name="mydir">
		<cfreturn mydir>
	</cffunction>
	
	<cffunction name="delete">
		<cfargument name="path">
		<cfif not fileexists(path)>
			<cfthrow message="file #path# does not exists">
		</cfif>
		<cffile action="delete" file="#arguments.path#">
	</cffunction>
</cfcomponent>