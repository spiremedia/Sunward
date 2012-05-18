<cfcomponent name="filesystem" output="false">
	<cffunction name="iniparser" returntype="struct" output="false">
		
		<cfargument name="path" required="true">
		
		<cfset var iniString = "">
		<cfset var iniList = "">
		<cfset var iniStruct = structnew()>
        <cfset var iniItem = ""><!--- counter for cfloop collection--->
		<cfset var jsonObj = createObject('component', 'utilities.json')>
		<cfif not fileexists(arguments.path)>
			<cfthrow message="file for ini not found (#arguments.path#)">
		</cfif>
		
		<cffile action="read" file="#arguments.path#" variable="iniString">
		
		<cfset iniString = trim(iniString)>
		
		<cfset iniList = listtoarray(iniString, '#chr(13)##chr(10)#')>
		
		<cftry>
			<cfloop from="1" to="#arraylen(iniList)#" index="i">
				<cfset iniList[i] = trim(iniList[i])>
				<cfset iniStruct[trim(getToken(iniList[i],1, '='))] = trim(getToken(iniList[i],2, '='))>
			</cfloop>
			
            <!--- parse any json objects --->
            <cfloop collection="#inistruct#" item="iniItem">
            	<cfif left(inistruct[iniitem],1) EQ '{'>
                	<cfset inistruct[iniitem] = jsonObj.decode(inistruct[iniitem])>
                </cfif>
            </cfloop>
            
			<cfcatch>
				<cfthrow message="Failed parsing ini file">
			</cfcatch>
		</cftry>

		<cfreturn iniStruct>
		
	</cffunction>
	
	<cffunction name="getDirectoryListing" output="false">
		<cfargument name="dir">
		<cfset var mydir = "">
		<cfdirectory action="list" directory="#arguments.dir#" name="mydir">
		<cfreturn mydir>
	</cffunction>
</cfcomponent>