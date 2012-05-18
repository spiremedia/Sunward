<cfcomponent displayname="MyCFCTest" extends="mxunit.framework.TestCase">
		
	<cffunction name="setUp" returntype="void" access="public">
		<cfset variables.requestObject = request.requestObject>
		<cfset variables.controller = createObject("component","modules.tagcloud.controller").init(
			data=structnew(),
			requestObject=variables.requestObject
		)>
          
	</cffunction>
    
    <cffunction name="teardown" returntype="void" access="public">
	
	</cffunction>
	
    <!--- model tests --->
    <cffunction name="testAddDatatoModel1x1">
    	<cfset var itm = variables.controller.getModel()>
        <cfset var count = "">
		<cfset itm.addCloudItem("fred")>
        <cfset itm.addCloudItem("fred")>

        <cfset count = int( itm.getyCloudItemCount("fred") )>

        <cfset assertequals(expected=2,actual=count,message="found incorrect count after adding 2")>
    </cffunction>
    
    <cffunction name="testAddDatatoModeladdmult">
    	<cfset var itm = variables.controller.getModel()>
        <cfset var count = "">
		<cfset itm.addCloudItem("Tom",3)>
        <cfset itm.addCloudItem("Tom")>
        <cfset itm.addCloudItem("Tim")>

        <cfset count = itm.getyCloudItemCount("Tom")>
        
        <cfset assertequals(expected=4,actual=count,message="found incorrect count after adding 4")>
    </cffunction>
    
    <cffunction name="testmax">
    	<cfset var itm = variables.controller.getModel()>
        <cfset var max = "">
		<cfset itm.addCloudItem("terry",3)>
        <cfset itm.addCloudItem("terry")>
        <cfset itm.addCloudItem("todd",3)>

        <cfset max = itm.getMax()>
        <cfset assertequals(expected=4,actual=max,message="found incorrect max after adding 4")>
        
        <cfset min = itm.getMin()>
        <cfset assertequals(expected=3,actual=min,message="found incorrect min after adding 4")>
    </cffunction>
    
    <cffunction name="testData">
    	<cfset var itm = variables.controller.getModel()>
        <cfset var data = "">
        <cfset var lcl = structnew()>
		<cfset itm.addCloudItem("terry",3)>
        <cfset itm.addCloudItem("terry")>
        <cfset itm.addCloudItem("tim")>
        <cfset itm.addCloudItem("todd",3)>

        <cfset data = itm.getCloudItems()>
        
        <cfquery name="lcl.terrycount" dbtype="query">
        	SELECT cnt from data where phrase = 'terry'
        </cfquery>
        
         <cfquery name="lcl.toddcount" dbtype="query">
        	SELECT cnt from data where phrase = 'todd'
        </cfquery>
        
        <cfquery name="lcl.timcount" dbtype="query">
        	SELECT cnt from data where phrase = 'tim'
        </cfquery>

        <cfset assertequals(expected=4,actual=lcl.terrycount.cnt,message="found incorrect terry count")>
        <cfset assertequals(expected=1,actual=lcl.terrycount.recordcount,message="found incorrect terry count records")>
        <cfset assertequals(expected=3,actual=lcl.toddcount.cnt,message="found incorrect todd count")>
        <cfset assertequals(expected=1,actual=lcl.toddcount.recordcount,message="found incorrect todd count records")>
        <cfset assertequals(expected=1,actual=lcl.timcount.cnt,message="found incorrect tim count")>
        <cfset assertequals(expected=1,actual=lcl.timcount.recordcount,message="found incorrect tim count records")>
        <cfset assertequals(expected=3,actual=data.recordcount,message="found incorrect amount of records")>
        
    </cffunction>
    
    <!---View test here--->
    <cffunction name="testhtml">
    	<cfset var itm = variables.controller.getModel()>
        <cfset var data = "">
        <cfset var lcl = structnew()>
        <cfset var html = "">
		<cfset itm.addCloudItem("terry",3)>
        <cfset itm.addCloudItem("terry")>
        <cfset itm.addCloudItem("tim")>
        <cfset itm.addCloudItem("todd",3)>

		<cfset html = variables.controller.showHTML()>
        <cfset asserttrue(condition = refind("<style>.*</style>",html),message="did not find matching style elements")>
        <cfset asserttrue(condition = refind('<div class="cloud">.*</div>',html),message="did not find matching style elements")>
        <cfset asserttrue(condition = find('<a class="cld6" href="/search/?criteria=terry">terry</a>',html),message="did not find terry link")>
        <cfset asserttrue(condition = find('<a class="cld1" href="/search/?criteria=tim">tim</a>',html),message="did not find tim link")>
        <cfset asserttrue(condition = find('<a class="cld4" href="/search/?criteria=todd">todd</a>',html),message="did not find todd link")>
    </cffunction>
        
    <!--- ctrlr test --->
    <cffunction name="testshowHTml" returntype="void" access="public">
		<cftry>
        	<cfset variables.controller.showHTML()>
            <cfcatch>
            <cfdump var=#cfcatch#><cfabort>
            	<cfset fail("show html fails : #cfcatch.message# in #cfcatch.template# on ")>
            </cfcatch>
        </cftry>
	</cffunction>
    
    <!---
    <!--- data writer test - should test to see if cloud data is correctly created by scheduled task --->
    <cffunction name="testdatawriter" returntype="void" access="public">
		<cftry>
        	<cfset variables.controller.showHTML()>
            <cfcatch>
            <cfdump var=#cfcatch#><cfabort>
            	<cfset fail("show html fails : #cfcatch.message# in #cfcatch.template# on ")>
            </cfcatch>
        </cftry>
	</cffunction>
	--->
   
</cfcomponent>