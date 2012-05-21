<cfcomponent displayname="MyCFCTest" extends="mxunit.framework.TestCase">
		
	<cffunction name="setUp" returntype="void" access="public">
		<cfset variables.requestObject = request.requestObject>         
	</cffunction>
    
    <cffunction name="loadController" access="private">
    	<cfargument name="str">
        <cfset var data = structnew()>
        <cfset data.content = arguments.str>
    	<cfset variables.controller = createObject("component","modules.simplecontent.controller").init(
			data=data,
			requestObject=variables.requestObject
		)>
    </cffunction>
    
    <cffunction name="teardown" returntype="void" access="public">
	
	</cffunction>
	
    <cffunction name="testinout">
    	<cfset var str = "hello">
        <cfset var out = "">
    	<cfset loadController(str)>
		<cfset out = variables.controller.showHTML()>
        <cfset assertequals(expected=str,actual=out)>
    </cffunction>
    
    <cffunction name="testassetwinvalid">
    	<cfset var str = "hello{{asset[3B95EE8D-E0B8-ABF4-77DBCFB167CB415a]}}654654">
        <cfset var out = "hello/404/?asset=3B95EE8D-E0B8-ABF4-77DBCFB167CB4155654654">
    	<cfset loadController(str)>
		<cfset out = variables.controller.showHTML()>
        <cfset assertequals(expected=str,actual=out)>
    </cffunction>
    
    <cffunction name="testassetwvalid">
        <cfset var lcl = structnew()>
        <cfquery name="lcl.info" datasource="#requestObject.GetVar("dsn")#">
        	SELECT id, filename FROM assets_view WHERE filename is not null
        </cfquery>
        <cfset lcl.str = "hello{{asset[#lcl.info.id#]}}654654">
        <cfset lcl.shouldbe = "hello/docs/assets/#lcl.info.id#/#lcl.info.filename#654654">
    	<cfset loadController(lcl.str)>
		<cfset lcl.out = variables.controller.showHTML()>
		<cfset asserttrue(condition = findnocase(lcl.shouldbe,lcl.out), message="link not formatted correctly. This maybe due to the ESM not having any assets uploaded to test. Upload an asset and retest.")>
    </cffunction>	
    
    <cffunction name="testlinkwinvalid">
    	<cfset var str = "hello{{link[3B95EE8D-E0B8-ABF4-77DBCFB167CB415a]}}654654">
        <cfset var out = "hello/404/?link=3B95EE8D-E0B8-ABF4-77DBCFB167CB4155654654">
    	<cfset loadController(str)>
		<cfset out = variables.controller.showHTML()>
        <cfset assertequals(expected=str,actual=out)>
    </cffunction>
    
    <cffunction name="testlinkwvalid">
        <cfset var lcl = structnew()>
        
        <cfquery name="lcl.info" datasource="#requestObject.GetVar("dsn")#">
        	SELECT id, siteid, urlpath FROM publishedpages WHERE urlpath <> ''
        </cfquery>
        
        <cfset lcl.str = "hello{{link[#left(lcl.info.siteid,35)#][#lcl.info.id#]}}654654">
        <cfset lcl.shouldbe = "hello/#lcl.info.urlpath#654654">
    	<cfset loadController(lcl.str)>
		<cfset lcl.out = variables.controller.showHTML()>
        
        <cfset assertequals(expected=lcl.out,actual=lcl.shouldbe)>
    </cffunction>
       
</cfcomponent>