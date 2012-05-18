<cfcomponent name="dhtmlPager" extends="resources.abstractcontroller">
	
    <cffunction name="init">
    	<cfargument name="requestObject">
        <cfargument name="data">
		
		<cfset var reinfo = structnew()>
		
    	<cfset variables.requestObject = arguments.requestObject>
        <cfset variables.data = arguments.data>
		
		<!--- this loop is for the more info link on home page --->
		<cfloop from="1" to="#arraylen(variables.data.items)#" index="reinfo.i">
			<cfset reinfo.str = variables.data.items[reinfo.i].content>
			<cfset reinfo.re = refindnocase("{{moreinfo:([^}]+)}}", reinfo.str, 1, true)>
			<cfif reinfo.re.len[1]>
				<cfset variables.data.items[reinfo.i].moreinfo = mid(reinfo.str, reinfo.re.pos[2], reinfo.re.len[2])>
				<cfset variables.data.items[reinfo.i].content = rereplace(reinfo.str, "(<p>)?{{moreinfo:([^}]+)}}([ ]+</p>)?", "", "all")>
			</cfif>
		</cfloop>
		
      	<cfreturn this>
    </cffunction>
    
    <cffunction name="showHTML">
    	<cfset var lcl = structnew()>
		
		<cfif isdefined("variables.data.startsopen") AND isnumeric(variables.data.startsopen)>
			<cfset lcl.startsopen = arraylen(variables.data.items) - variables.data.startsopen>
		</cfif>
		
 		<cfoutput>
        <cfsavecontent variable="lcl.html">
        	<cfif arraylen(variables.data.items)>
            	<div id="buttons_#variables.data.name#">
                	<cfloop from="1" to="#arraylen(variables.data.items)#" index="lcl.i">
                    <div class="content" id="tabs_#variables.data.name#-#lcl.i#">
                        #variables.data.items[lcl.i].content#
						<cfif structkeyexists(variables.data.items[lcl.i], "moreinfo")>
							<div class="moreinfolink"><a href="#variables.data.items[lcl.i].moreinfo#">learn more &raquo;</a></div>
						</cfif>
                    </div>
					
                    </cfloop>
                    <ul>
                    <cfloop from="#arraylen(variables.data.items)#" to="1" index="lcl.i" step="-1">
                        <li><a href="##tabs_#variables.data.name#-#lcl.i#"><span>#variables.data.items[lcl.i].title#</span></a></li>
                    </cfloop>
                    </ul>
            	</div>
                <script type="text/javascript">
					$(function(){$("##buttons_#variables.data.name#").tabs({
						navClass: 'ui-btn-nav',
						selectedClass: 'ui-btn-selected',
						unselectClass: 'ui-btn-unselect',
						disabledClass: 'ui-btn-disabled',
						panelClass: 'ui-btn-panel',
						hideClass: 'ui-btn-hide',
						loadingClass: 'ui-btn-loading',
						tabdirection:'rl',
						<cfif isdefined("lcl.startsopen")>selected:#lcl.startsopen#,</cfif>
						fx: { opacity: 'toggle',duration: 'fast' }});})
						
				</script>
           </cfif>
        </cfsavecontent>
        </cfoutput>

        <cfreturn lcl.html/>

    </cffunction>
    
</cfcomponent>
