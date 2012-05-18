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
        <cfsavecontent variable="lcl.html">
        	<cfif arraylen(variables.data.items)>
            	<ul>
                    <cfloop from="1" to="#arraylen(variables.data.items)#" index="lcl.cntr">
                        <li>
                            <b>#variables.data.items[lcl.cntr].title#</b>
                            <div>
                                #variables.data.items[lcl.cntr].content#
                            </div>
                        </li>
                    </cfloop>
                </ul>

            </cfif>
        </cfsavecontent>
        </cfoutput>
        <cfreturn lcl.html/>
    </cffunction>
    
</cfcomponent>