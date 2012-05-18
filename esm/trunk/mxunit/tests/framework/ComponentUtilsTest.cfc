<cfcomponent extends="mxunit.framework.TestCase">
<cfset cu = createObject("component","mxunit.framework.ComponentUtils")>


<cffunction name="testThatGetComponentRootImplementsOverrideOfMxunitConfigXml">
  <cfscript>
   var root = cu.getComponentRoot("override");
   debug("Walking override path :: " & root);
   assertEquals("mxunit",root);
  </cfscript>
</cffunction>


<cffunction name="testGetComponentRootWhenGetMetaDataNameIsDot">
  <cfscript>
   var root = cu.getComponentRoot(".");
   debug(root);
   assertEquals("mxunit",root);
  </cfscript>
</cffunction>

<cffunction name="testGetComponentRootWhenGetMetaDataNameIsComponentUtils">
    <cfscript>
     var root = cu.getComponentRoot("ComponentUtils");
     debug(root);
     assertEquals("mxunit",root);
    </cfscript>
  </cffunction>

  <cffunction name="testGetComponentRootWhenGetMetaDataNameIsNull">
    <cfscript>
     var root = cu.getComponentRoot("");
     debug(root);
     assertEquals("mxunit",root);
    </cfscript>
  </cffunction>

	<cffunction name="testGetSeparator">
		<cfset var sep = cu.getSeparator()>

		<cfif findNoCase("Windows",server.OS.Name)>
			<cfset assertEquals("\",sep)>
		<cfelse>
			<cfset assertEquals("/",sep)>
		</cfif>
	</cffunction>

	<cffunction name="testIsFrameworkTemplate">
		<cfset var sep = cu.getSeparator()>
		<cfset var root = expandPath("/mxunit/")>

		<cfset var template = "#root#framework#sep#SomeFile.cfc">
		<cfset debug("template is #template#")>
		<cfset assertTrue(cu.isFrameworkTemplate(template),"#template# should be framework template")>

		<cfset template = replace(template,".cfc",".cfm","one")>
		<cfset debug("template is #template#")>
		<cfset assertTrue(cu.isFrameworkTemplate(template),"#template# should be framework template")>

		<cfset template = "c:/bluedragon/wwwroot/mxunit/framework/TestCase.cfc">
		<cfset assertTrue(cu.isFrameworkTemplate(template),"blue-dragon style should be framework template")>

		<cfset template = "#root#PluginDemoTests#sep#SomeFile.cfc">
		<cfset assertTrue(NOT cu.isFrameworkTemplate(template),"#template# should not be framework template")>

		<cfset template = "#root#PluginDemoTests#sep#SomeFile.cfc">
		<cfset assertTrue(NOT cu.isFrameworkTemplate(template),"#template# should not be framework template")>


	</cffunction>


	<cffunction name="testSomethingPrivate" access="private">
	</cffunction>
	<cffunction name="testSomethingPackage" access="package">
	</cffunction>



  <!---

  To Do:

  Obviously there is some good refactoring opportunities here in the next two
  methods.

  bill - 3.13.08

  <cffunction name="testGetRoot">
    <cfscript>
     var rootWithDots;
    </cfscript>
  </cffunction>
  --->
  <cffunction name="testGetInstallRoot">
  <cfscript>
    //@pre metadata will always be dot delimitted list
    //     web path separator will always be '/'
    //     method will be used by framework only
    //@post
   var root = cu.getInstallRoot("foo.bar.nanoo.mxunit.framework.TestResult");
   debug(root);
   assertEquals("#getContextRootPath()#/foo/bar/nanoo/mxunit/", root);

   root = cu.getInstallRoot();
   debug(root);
   assertEquals("#getContextRootPath()#/mxunit/",root);

   root = cu.getInstallRoot("mxunit.mxunit.framework.TestCase");
   debug(root);
   assertEquals("#getContextRootPath()#/mxunit/mxunit/",root);

   root = cu.getInstallRoot("mxunit.framework.TestCase");
   debug(root);
   assertEquals("#getContextRootPath()#/mxunit/",root);

   root = cu.getInstallRoot("mxunit.foo.bar.mxunit.framework.TestCase");
   debug(root);
   assertEquals("#getContextRootPath()#/mxunit/foo/bar/mxunit/",root);

  </cfscript>
</cffunction>


<cffunction name="testGetComponentRoot">
  <cfscript>
  //@pre metadata will always be dot delimitted list
  //     web path separator will always be '/'
  //     method will be used by framework only
  //@post
   var root = cu.getComponentRoot("foo.bar.nanoo.mxunit.framework.TestResult");
   debug(root);
   assertEquals("foo.bar.nanoo.mxunit", root);


   root = cu.getComponentRoot("mxunit.framework.TestResult");
   debug(root);
   assertEquals("mxunit", root);


   root = cu.getComponentRoot("");
   debug(root);
   assertEquals("mxunit", root);

   root = cu.getComponentRoot("mxunit.framework.Assert");
   debug(root);
   assertEquals("mxunit", root);

   root = cu.getComponentRoot("mxunit.framework.ComponentUtils");
   debug(root & ".MXunitInstallTest");
   assertEquals("mxunit.MXunitInstallTest", root & ".MXunitInstallTest");

  </cfscript>
</cffunction>


<cffunction name="testHasJ2EEContext">
 <cfscript>
  ctx = getPageContext().getRequest().getContextPath();
  try{
   assertTrue(cu.hasJ2EEContext() ,"Expect a failure on non-j2ee server configs.");
  }
  catch (any e){
   if(cu.hasJ2EEContext()){
     throwwrapper(e);
   }
  }

  debug(cu.hasJ2EEContext());
 </cfscript>
</cffunction>


<cffunction name="testGetContextRootComponent">
<cfset var ctx = "" />
<cfoutput>
 <cfset ctx = getPageContext().getRequest().getContextPath() />
 <cfset addtrace(cu.getContextRootComponent()) />
</cfoutput>
</cffunction>

<cffunction name="testGetContextRootPath">
<cfset var ctx = "" />
<cfoutput>
 <cfset ctx = getPageContext().getRequest().getContextPath() />
 <cfset addtrace(cu.getContextRootPath()) />
</cfoutput>
</cffunction>


<cffunction name="hasJ2EEContext" access="private">
 <cfscript>
  return(getContextRootPath() is not "");
 </cfscript>
</cffunction>


<cffunction name="getContextRootComponent" access="private">
 <cfset var ctx = getPageContext().getRequest().getContextPath() />
 <cfset var rootComponent = "" />
 <cfif hasJ2EEContext()>
   <!--- This last  "." worries me. Under what circumstance will this not be true? --->
   <cfset rootComponent = right(ctx,len(ctx)-1) &  "."/>
 </cfif>
 <cfreturn  rootComponent />
</cffunction>


<cffunction name="getContextRootPath" access="private">
 <cfset var ctx = getPageContext().getRequest().getContextPath() />
 <cfreturn ctx />
</cffunction>

	<cffunction name="setUp">

	</cffunction>

	<cffunction name="tearDown">

	</cffunction>
</cfcomponent>