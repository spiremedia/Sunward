<!---
  @file TestResult.cfc
  @author bill
  @description Data representation of test results - array of test result structs.
               Any exception info is stored in an error element.
  @history
  bill - 09.19.07 Refactored to use "native" data structure instead of orginal XML.
         XML representation is available as a sublcass XMLTestResult.cfc

 --->


 <cfcomponent displayname="mxunit.framework.TestResult" output="no" hint="Represents the results generated by TestCases. Data is stored as a ColdFusion structure and component has methods for transforming that data to HTML and XML. In General, you will not need to call most methods in this component. The primary ones you will use are: getResults(), getHtmlResults(), getJunitXmlResults(), getXmlResults()">

   <cfparam name="this.testRuns" type="numeric" default="0" />
   <cfparam name="this.testFailures" type="numeric" default="0" />
   <cfparam name="this.testErrors" type="numeric" default="0" />
   <cfparam name="this.testSuccesses" type="numeric" default="0" />
   <cfparam name="this.totalExecutionTime" type="numeric" default="0" />
   <cfparam name="this.package" type="string" default="mxunit.testresults" />


   <cfparam name="tempTestCase" type="any" default="" />
   <cfparam name="tempTestComponent" type="any" default="" />
   <cfparam name="this.results" type="array" default="#arrayNew(1)#" />
   <cfparam name="this.resultItem" type="struct" default="#structNew()#" />
   <cfparam name="this.resultItem.debug" type="array" default="#arrayNew(1)#" />
   <cfset this.resultItem.debug = arrayNew(1) />



 <cffunction name="TestResult" hint="Constructor" access="public" returntype="TestResult">
   <cfset this.totalExecutionTime = getTickcount() />
   <cfreturn this />
 </cffunction>

<!--- May not be required if using an array --->
 <cffunction name="closeResults"
             hint="Simply closes the resultsXML root element. Needs to be called!"
             access="public" returntype="void" output="false">
   <cfset this.totalExecutionTime = getTickcount() - this.totalExecutionTime />
 </cffunction>



 <cffunction name="getResults" access="public" returntype="array" output="false">
   <cfinvoke method="closeResults" />
   <cfreturn this.results />
 </cffunction>



<!---
  Initialize the test result item struct each time and populate it with meta data
 --->
 <cffunction name="startTest" access="public" returntype="void" >
   <cfargument name="testCase" type="any" required="yes" />
   <cfargument name="componentName" type="any" required="yes" />
    <cfscript>
	 var tempTestCase = "";
	 var tempTestComponent = "";
     this.resultItem = structNew();
     this.resultItem.trace = "" ;
     this.testRuns = this.testRuns + 1;
     tempTestCase = arguments.testCase ;
     tempTestComponent = arguments.componentName ;
     this.resultItem.number = this.testRuns;
     this.resultItem.component = tempTestComponent;
     this.resultItem.testname = tempTestCase;
     this.resultItem.dateTime = dateFormat(now(),"mm/dd/yyyy") & " " &  timeFormat(now(),"medium");
     this.debug = arrayNew(1);
   </cfscript>
 </cffunction>


<!---
  Add the test result item to the test results array
 --->
 <cffunction name="endTest" access="public" returntype="any">
   <cfargument name="testCase" type="any" required="yes" />
    <cfscript>
      arrayAppend(this.results,this.resultItem);
    </cfscript>
 </cffunction>


<!---
 If anything goes wrong, capture the entire exception.
 --->
<cffunction name="addError" access="public" returntype="void">
  <cfargument name="exception" type="any" required="yes" />
  <!--- TestResult.addError() <br /> --->
  <cfscript>
    this.resultItem.error = arguments.exception;
    this.resultItem.testStatus = 'Error';
    //this.testFailures = this.testFailures + 1;
    this.testErrors = this.testErrors + 1;
    this.resultItem.content = "";
  </cfscript>
</cffunction>

<cffunction name="addFailure" access="public" returntype="void">
  <cfargument name="exception" type="any" required="yes" />
  <!--- TestResult.addError() <br /> --->
  <cfscript>
    this.resultItem.error = arguments.exception;
    this.resultItem.testStatus = 'Failed';
    this.testFailures = this.testFailures + 1;
    this.resultItem.content = "";
  </cfscript>
</cffunction>


<!---
  If the item beiong tested OR the test case itself generates any content,
  capture that.
 --->
<cffunction name="addContent" access="public" returntype="void">
  <cfargument name="content" type="any" required="yes" />
  <cfscript>
     this.resultItem.content = arguments.content;
  </cfscript>
</cffunction>

<!---
 // 10-18-07
 // bill: should only be called once by TestSuite in order to add the debug array
    generated by TestCase.
 --->
<cffunction name="setDebug" access="public" returntype="void">
  <cfargument name="debugData" type="Any" required="true" hint="Data to add to debug array">
  <!--- TestResult.setDebug() --->
  <cfset this.resultItem.debug = duplicate(arguments.debugData) />
</cffunction>

<cffunction name="getDebug" access="public" returntype="array">
  <cfreturn this.resultItem.debug />
</cffunction>

<!---
  If the test passes, store that.
 --->
<cffunction name="addSuccess" access="public" returntype="void">
  <cfargument name="message" type="string" required="yes" />
 <cfscript>
    this.resultItem.testStatus = arguments.message;
    this.resultItem.error = "";
    this.testSuccesses = this.testSuccesses + 1;
  </cfscript>
</cffunction>


<!---
 Store how long the test took.
 --->
 <cffunction name="addProcessingTime" access="public" returntype="void">
    <cfargument name="milliseconds" required="true" type="numeric" default="-1" />
    <cfscript>
      this.resultItem.time = arguments.milliseconds;
    </cfscript>
  </cffunction>



 <!---
  Add any user defined trace messages to the results.
  To Do: Allow for multiple trace messages per test. Currently only one is allowed.
  --->
 <cffunction name="addTrace" access="public" returntype="void">
  <cfargument name="message" type="any" required="no" default="" />
  <cfscript>
    this.resultItem.trace =  this.resultItem.trace & message.toString();
  </cfscript>
</cffunction>

<cffunction name="mergeErrorsIntoTestResult" access="public" returntype="void" output="false" hint="merges any catastrophic errors (parse errors, etc) into the TestResults object">
		<cfargument name="ErrorStruct" type="struct" required="true"/>
		
		<cfset var key = "">
		<cfset var a_debug = ArrayNew(1)>
		<cfloop collection="#ErrorStruct#" item="key">
			<cfset startTest(ListLast(key,"."),key)>
			<cfset a_debug[1] = ErrorStruct[key]>
			<cfset addError(ErrorStruct[key])>
			<cfset addProcessingTime(0)>
			<cfset setDebug(a_debug)>
			<cfset endTest("")>
		</cfloop>
		
		
	</cffunction>



<cffunction name="getFailures" returntype="Numeric" access="public">
  <cfreturn this.testFailures />
</cffunction>

<cffunction name="getSuccesses" returntype="Numeric" access="public">
  <cfreturn this.testSuccesses />
</cffunction>

<cffunction name="getErrors" returntype="numeric" access="public">
	<cfreturn this.testErrors>
</cffunction>

<!---

  If we store the entire exception in the data structure, we might not need this below.

 --->

<cffunction name="constructTagContextElements" output="false" access="public" returntype="string" hint="returns the error's tagcontext formatted as xml">
	<cfargument name="exception" type="any">
	<cfset var tc = exception.tagcontext>
	<cfset var i = 1>
	<cfset var xmlReturn = "">
	<cfset var sep = createObject("java","java.lang.System").getProperty("file.separator")>
	<cfset var mxunitpath = "mxunit#sep#framework">
	<cfoutput>
	<cfsavecontent variable="xmlReturn">
	<cfloop from="1" to="#ArrayLen(tc)#" index="i">
		<cfif tc[i].template neq "<generated>"
			AND not findNoCase("Assert.cfc",tc[i].template)
			AND tc[i].line GT 0>
			<trace>
				<file>#xmlFormat(tc[i].template)#</file>
				<line>#tc[i].line#</line>
			</trace>
		</cfif>
	</cfloop>
	</cfsavecontent>
	</cfoutput>
	<cfreturn xmlReturn>
</cffunction>

<cffunction name="getResultsOutput" returntype="any" hint="convenience for getting the various output modes" access="public">
	<cfargument name="mode" required="true" hint="html,extjs,xml,junitxml,query,struct">
	<cfset arguments.mode = listLast(arguments.mode)>
	<cfswitch expression="#arguments.mode#">
		<cfcase value="extjs,ext" delimiters=",">
			<cfreturn getEXTResults()>
		</cfcase>
		<cfcase value="xml">
			<cfreturn getXMLResults()>
		</cfcase>
		<cfcase value="junitxml">
			<cfreturn getJUnitXMLResults()>
		</cfcase>
    <cfcase value="query">
			<cfreturn getQueryResults()>
		</cfcase>
    <cfcase value="array">
			<cfreturn getResults()>
		</cfcase>
		<cfdefaultcase>
			<cfreturn getHTMLResults()>
		</cfdefaultcase>
	</cfswitch>
</cffunction>

<cffunction name="getHTMLResults" returnType="string" hint="Call this method to return preformatted HTML.">
 	<cfset var htmlresult = createObject("component", "XMLTestResult").XMLTestResult(this)>
  	<cfreturn htmlresult.getHtmlresults()>
</cffunction>

<cffunction name="getEXTResults" returntype="string" hint="returns the appropriate HTML for showing results in an EXT js Grid">
	<cfargument name="DirName" type="string" required="false" default="" hint="Directory under test, if this TestResult is part of a directory test suite"/>
	<cfargument name="EXTRoot" type="string" required="false" default="#getInstallRoot()#resources/ext2" hint="where EXT lives"/>
	<cfset var extresult = createObject("component","EXTTestResult").EXTTestResult(this,ExtRoot)>
	<cfreturn extresult.getHTMLResults(DirName)>
</cffunction>

<cffunction name="getXMLResults"  returnType="string" hint="Call this method to return raw XML. You can then apply your own xsl.">
 	<cfset var xml = createObject("component", "XMLTestResult").XMLTestResult(this)>
  	<cfreturn xml.getXMLresults()>
</cffunction>

<cffunction name="getQueryResults"  returnType="query" hint="Call this method to return raw XML. You can then apply your own xsl.">
 	<cfset var q = createObject("component", "QueryTestResult").QueryTestResult(this)>
  	<cfreturn q.getQueryResults() />
</cffunction>

<cffunction name="getJUnitXMLResults" returnType="string"  hint="Call this method to return JUnit style XML for Ant junitreport task.">
 	<cfset var xml = createObject("component", "JUnitXMLTestResult").JUnitXMLTestResult(this)>
  <cfreturn xml.getXMLresults()>
</cffunction>

<cffunction name="getResultsAsStruct" returntype="struct" hint="returns results as a struct keyed on Component" output="false">
	<cfset var s_results = StructNew()>
	<cfset var thisComponent = "">
	<cfset var test = 1>

	<cfloop from="1" to="#ArrayLen(this.results)#" index="test">
		<cfset thisComponent = this.results[test].Component>
		<cfif not StructKeyExists(s_results,thisComponent)>
			<cfset s_results[thisComponent] = ArrayNew(1)>
		</cfif>
		<cfset ArrayAppend(s_results[thisComponent],this.results[test])>
	</cfloop>

	<cfreturn s_results>
</cffunction>

<cffunction name="setPackage" access="public" returntype="void">
  <cfargument name="package" type="string" required="true" />
  <cfset this.package = arguments.package />
</cffunction>

<cffunction name="getPackage" access="public" returntype="string">
   <cfreturn this.package />
</cffunction>

<cffunction name="normalizeQueryString" returntype="string" hint="" output="false">
	<cfargument name="URLScope" required="true" type="struct" hint="the URL scope">
	<cfargument name="outputMode" required="true" type="string" hint="the output mode to append to the query string">
	<cfset var qs = "">
	<cfset var key = "">
	<cfloop collection="#URLScope#" item="key">
		<cfif key neq "output">
			<cfset qs = listAppend(qs,"#lcase(key)#=#URLScope[key]#","&")>
		</cfif>
	</cfloop>
	<cfset qs = ListAppend(qs,"output=#outputMode#","&")>
	<cfreturn qs>
</cffunction>


<!--- Refactor to ComponentUtils and wrap this up --->
<cffunction name="getInstallRoot" returnType="string" access="public" hint="Attempts to discover the webroot installation of mxunit.">
 <cfargument name="fullPath" type="string" required="false" default="" hint="Used for testing, really." />
 <cfscript>
    var cUtil = createObject("component","ComponentUtils");
    return cUtil.getInstallRoot(arguments.fullPath);
  </cfscript>
</cffunction>

</cfcomponent>