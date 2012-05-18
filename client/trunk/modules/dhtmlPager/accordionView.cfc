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
	
		<cfif isdefined("variables.data.startsopen") AND isnumeric(variables.data.startsopen)>
			<cfset lcl.startsopen = variables.data.startsopen -1>
		</cfif>
		
        <cfoutput>
        <cfsavecontent variable="lcl.html">
        	<cfif arraylen(variables.data.items)>
            	<ul id="#variables.data.name#_#variables.data.dhtmltype#">
                    <cfloop from="1" to="#arraylen(variables.data.items)#" index="lcl.cntr">
                        <li <cfif isdefined("lcl.startsopen") AND lcl.startsopen EQ lcl.cntr>class="active"</cfif>>
                            <a>#variables.data.items[lcl.cntr].title#</a>
                            <div>
                                #variables.data.items[lcl.cntr].content#
                            </div>
                        </li>
                    </cfloop>
                </ul>
                <script type="text/javascript">
					$(function(){$("###variables.data.name#_#variables.data.dhtmltype#").accordion({autoHeight: false<cfif isdefined("lcl.startsopen")>, active:#lcl.startsopen#</cfif>});})
				</script>
            </cfif>
        </cfsavecontent>
        </cfoutput>
        <cfreturn lcl.html/>
    </cffunction>
    
</cfcomponent>