<cfcomponent name="test" output="False" >
	
	<cffunction name="init" output="False" access="remote">
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="importDealers" output="False" access="remote">
		<cfset var lcl = structNew()>
		<cfset lcl.requestObject = application.settings.makeRequestObject()>
		<cfset lcl.fileName = lcl.requestObject.getMachineRoot()&'../test/SCGGRPUserList.txt'>
		
		<cfif fileExists(lcl.fileName)>
			<cffile action="read" file="#lcl.fileName#" variable="fileRow" >
			<cfloop list="#fileRow#" delimiters="#chr(13)##chr(10)#" index="curRecord">
				<cfset lcl.dealer = structNew()>
				<cfset lcl.dealer.username = ''>
				<cfset lcl.dealer.password = ''>
				<cfset lcl.dealer.name = ''>
				<cfset lcl.dealer.email = ''> 
				<cfif listlen(curRecord,chr(9))>
					<cfset lcl.dealer.username = trim(listGetAt(curRecord,1,chr(9)))>
				</cfif>
				<cfif listlen(curRecord,chr(9)) gte 2>
					<cfset lcl.dealer.password = trim(listGetAt(curRecord,2,chr(9)))>
				</cfif>
				<cfif listlen(curRecord,chr(9)) gte 3>
					<cfset lcl.dealer.name = trim(listGetAt(curRecord,3,chr(9)))>
				</cfif>
				<cfif listlen(curRecord,chr(9)) gte 4>
					<cfset lcl.dealer.email = trim(listGetAt(curRecord,4,chr(9)))>
				</cfif>
				<cfif lcl.dealer.username neq ''>
					<cfquery name="lcl.qryGetDealers" datasource="#lcl.requestObject.getvar('dsn')#">  
						SELECT * FROM members
						WHERE username = <cfqueryparam value="#lcl.dealer.username#" cfsqltype="cf_sql_varchar">
					</cfquery> 
					<cfif NOT lcl.qryGetDealers.recordcount>
					   <!---	
					<cfdump var="#lcl.dealer#"><br>--->
						<cfquery name="qryUpdateDealers" datasource="#lcl.requestObject.getvar('dsn')#">  
						INSERT INTO members (id, username, name, email, password)
						values (
							<cfqueryparam value="#CreateUUID()#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#lcl.dealer.username#" cfsqltype="cf_sql_varchar" null="#(lcl.dealer.username eq '')#">,
							<cfqueryparam value="#lcl.dealer.name#" cfsqltype="cf_sql_varchar" null="#(lcl.dealer.name eq '')#">,
							<cfqueryparam value="#lcl.dealer.email#" cfsqltype="cf_sql_varchar" null="#(lcl.dealer.email eq '')#">,
							<cfqueryparam value="#hash(lcl.dealer.password)#" cfsqltype="cf_sql_varchar" null="#(lcl.dealer.password eq '')#">
							)
						</cfquery> 		
					</cfif>
				</cfif>
				 		
			</cfloop>
		</cfif>
	<cfabort>
	</cffunction>
	
</cfcomponent>