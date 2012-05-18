<cfcomponent displayname="MyCFCTest" extends="mxunit.framework.TestCase">
		
	<cffunction name="setUp" returntype="void" access="public">
		<cfset variables.requestObject = request.requestObject>
		<cfset variables.wordparser = createObject("component","utilities.wordparser").init()>
	</cffunction>

    <cffunction name="teststringload">
    	<cfset var s = "">
        <cfset var q = "">
        
		<cfset variables.wordparser.loadString("fred,tk83*om,fred,jerrey,dre the dreaded")>
      
		<cfset s = variables.wordparser.getWords()>
        
		<cfquery name="q" dbtype="query">
        	SELECT word FROM s WHERE word IN ('fred','dreaded','jerrey','dre','tk83om')
        </cfquery>
               
        <cfset assertequals(expected=5,actual=s.recordcount)>
        <cfset assertequals(expected=5,actual=q.recordcount)>
    </cffunction>
    
    <cffunction name="testlistload">
    	<cfset var s = "">
        <cfset var q = "">
         
		<cfset variables.wordparser.loadlist("fred flintstone,tk83*om,fred,jerrey,dre the dreaded")>
        
		<cfset s = variables.wordparser.getWords()>
        
		<cfquery name="q" dbtype="query">
        	SELECT word FROM s WHERE word IN ('fred', 'fred flintstone','jerrey','dre the dreaded','tk83om')
        </cfquery>
    
        <cfset assertequals(expected=q.recordcount,actual=s.recordcount)>
        <cfset assertequals(expected=5,actual=s.recordcount)>

    </cffunction>
    
    <cffunction name="testboundaries">
    	<cfset var s = "">
        <cfset var q = "">
        <cftry> 
			<cfset variables.wordparser.loadlist("")>
            <cfset s = variables.wordparser.getWords()>
            <cfcatch>
                <cfset fail("error in boundaries #cfcatch.message#")>
            </cfcatch>
       	</cftry>
  
    </cffunction>
    
 </cfcomponent>