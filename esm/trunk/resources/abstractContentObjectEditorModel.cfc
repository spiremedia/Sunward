<cfcomponent name="contentObjectEditor" output="false">
	
	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		
		<cfset loadItem(variables.request.getFormUrlVar('id'))>
		
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getinfo">
		<cfset var r = structnew()>
		<cfset r.id = variables.id>
		<cfreturn r>
	</cffunction>
	
	<cffunction name="loadItem" output="false">
		<cfargument name="id" required="true">
		
		<cfset var tempdata = "">
		
		<cfquery name="variables.item" datasource="#variables.request.getVar('dsn')#">
			SELECT id, name, module, data, pageid
			FROM pageObjects
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
				AND status = 'staged' 
		</cfquery>
				
		<cfif variables.item.recordcount EQ 0>
			<cfthrow message="Pageobject id = #variables.request.getformurlvar('id')# not found">
		</cfif>
	
		<cfset tempdata = createObject('component','utilities.json').decode(variables.item.data)>
		
		<cfset structappend(variables,tempdata)>
		
		<cfset variables.id = variables.item.id>
		<cfset variables.name = variables.item.name>
		<cfset variables.module = variables.item.module>
		<cfset variables.pageid = variables.item.pageid>
	</cffunction>

	<cffunction name="getID" output="false">
		<cfreturn variables.id>
	</cffunction>
	
	<cffunction name="validate">		
		<cfset var lcl = structnew()>
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>	
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var mydata = structnew()>
		<cfset saveData(mydata)>
	</cffunction>

	<cffunction name="deleteItem" output="false">
		<cfargument name="id" required="true">
		
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			DELETE FROM pageObjects
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar"> 
			AND  siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset description = "Removed module ""#variables.module#"" from location ""#variables.name#"".">
		
		<cfquery name="g2" datasource="#variables.request.getvar('dsn')#">
			INSERT INTO  sitepages_log (
				id,
				userid,
				pageid,
				description,
				siteid
			) VALUES (
				<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.pageid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#description#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>
		
	</cffunction>

	<cffunction name="saveData" output="false">
		<cfargument name="data" required="true">
		<cfset var json = createObject('component','utilities.json')>
		<cfset var localdata = json.encode(data)>
		<cfset var description = "">
		<cfquery name="g" datasource="#variables.request.getvar('dsn')#">
			UPDATE pageObjects SET data = <cfqueryparam value="#localdata#" cfsqltype="cf_sql_longvarchar">
			WHERE id = <cfqueryparam value="#variables.id#" cfsqltype="cf_sql_varchar"> 
				AND status = 'staged'
		</cfquery>
		
		<cfset description = "Updated module ""#variables.module#"" in location ""#variables.name#"".">
		
		<cfquery name="g2" datasource="#variables.request.getvar('dsn')#">
			INSERT INTO  sitepages_log (
				id,
				userid,
				pageid,
				description,
				siteid
			) VALUES (
				<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.userObj.getUserId()#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.pageid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#description#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.userObj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
			)
		</cfquery>

	</cffunction>
    
    <cffunction name="getParsedParameterList" output="false">
    	<!--- thsi function parses the formurl var parameterlist isn --->
		<cfset var lcl = structnew()>
		
		<cfif NOT variables.request.isFormUrlVarSet('parameterlist')>
        	<cfreturn lcl>
        </cfif>
        
        <cfset lcl.items = structnew()>
        <cfset lcl.pa = listtoarray(variables.request.getFormUrlVar('parameterlist'),",")>
        <cfloop from="1" to="#arraylen(lcl.pa)#" index="lcl.idx">
			<cfset lcl.itm = lcl.pa[lcl.idx]>
        	<cfif find('=', lcl.itm)>
            	<cfset lcl.items[gettoken(lcl.itm, 1,"=")] = gettoken(lcl.itm, 2,"=")>
            <cfelse>
            	<cfset lcl.items[lcl.itm] = 1>
            </cfif>
        </cfloop>
        
        <cfreturn lcl.items>
	</cffunction>

</cfcomponent>