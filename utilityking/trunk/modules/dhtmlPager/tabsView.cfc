<cfcomponent name="dhtmlPager" extends="resources.abstractcontroller">
	
    <cffunction name="init">
    	<cfargument name="requestObject">
        <cfargument name="data">
    	<cfset variables.requestObject = arguments.requestObject>
        <cfset variables.data = arguments.data>
      	<cfreturn this>
    </cffunction>
    
    <cffunction name="showHTML">
    	<cfset var lcl = structnew()>
 		<cfoutput>
	
		<cfif isdefined("variables.data.startsopen") AND isnumeric(variables.data.startsopen)>
			<cfset lcl.startsopen = arraylen(variables.data.items) - variables.data.startsopen>
		</cfif>

        <cfsavecontent variable="lcl.html">
        	<cfif arraylen(variables.data.items)>
            	<div id="tabs_#variables.data.name#">
                	<ul>
                    <cfloop from="#arraylen(variables.data.items)#" to="1" index="lcl.i" step="-1">
                        <li><a href="##tabs_#variables.data.name#-#lcl.i#"><span>#variables.data.items[lcl.i].title#</span></a></li>
                    </cfloop>
                    </ul>
                    <cfloop from="1" to="#arraylen(variables.data.items)#" index="lcl.i">
                    <div id="tabs_#variables.data.name#-#lcl.i#">
                        #variables.data.items[lcl.i].content#
                    </div>
                    </cfloop>
                </div>
                <script type="text/javascript">
					$(function(){$("##tabs_#variables.data.name#").tabs({tabdirection:'rl'<cfif isdefined("lcl.startsopen") AND isnumeric(lcl.startsopen)>,selected:#lcl.startsopen#</cfif>});})
				</script>
            </cfif>
        </cfsavecontent>
        </cfoutput>

        <cfreturn lcl.html/>

    </cffunction>
    
</cfcomponent>
<!---
 <cfsavecontent variable="lcl.html">
        	<cfif arraylen(variables.data.items)>
            	<div id="example" class="flora">
                	
                    <ul>
                        <li><a href="#fragment-1"><span>One</span></a></li>
                        <li><a href="#fragment-2"><span>Two</span></a></li>
                        <li><a href="#fragment-3"><span>Three</span></a></li>
                    </ul>
              
                    <div id="fragment-1">
                        <p>First tab is selected by default.</p>
                    </div>
                    <div id="fragment-2">
                        Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.
                        Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.
                    </div>
                    <div id="fragment-3">
                        Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.
                        Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.
                        Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat.
                    </div>
                </div>
                <script>
					$(function(){$("#example").tabs();})
				</script>
            </cfif>
    
        </cfsavecontent>
--->