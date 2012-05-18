<cfcomponent displayname="MyCFCTest" extends="mxunit.framework.TestCase">
		
	<cffunction name="setUp" returntype="void" access="public">		
		<cfset variables.requestObject = request.requestObject>
    	<cfset loadController(pageref=application.site.getPage(request=variables.requestObject))>
          
	</cffunction>
    
    <cffunction name="teardown" returntype="void" access="public">
		
	</cffunction>
    
    <cffunction name="loadController" access="private">
    	<cfargument name="data" default="#structnew()#">
    	<cfargument name="requestObject" default="#variables.requestObject#">
    	<cfargument name="pageref" default="#structnew()#">
    	<cfset variables.controller = createObject("component","modules.breadcrumbs.controller").init(
			data=arguments.data,
			requestObject=arguments.requestObject,
			pageref=arguments.pageref
		)>
    </cffunction>
	
    
    <!--- ctrlr tests --->
    <cffunction name="testAddLink">		
		<cftry>
        	<cfset variables.controller.addLink(link='/unittest/',label='Unit Test',id='UNITTEST-TEST-TEST-UNITTESTUUIDTEST')>
            <cfcatch>
            	<cfset fail("breadcrumb addlink fails : #cfcatch.message#")>
            </cfcatch>
        </cftry>
    </cffunction>
	
  <cffunction name="testShowHTML">
        <cfset var html = "">
		
		<cfset variables.controller.addLink(link='/',label='Home',id='UNITTEST-TEST-TEST-UNITTESTUUIDTEST')>
		<cfset variables.controller.addLink(link='/unittest/',label='Unit Test',id='UNITTEST-TEST-TEST-UNITTESTUUIDTEST')>
		<cfset html = variables.controller.showHTML()>
        <cfset asserttrue(condition = refind('<ul>.*</ul>',html),message="did not find matching ul elements")>
        <cfset asserttrue(condition = refind('<li>.*</li>',html),message="did not find matching li elements #html# ")>
        <cfset asserttrue(condition = refind('<a href=".*</a>',html),message="did not find breadcrumb link")>

    </cffunction> 
   
</cfcomponent>