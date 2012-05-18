<cfcomponent name="esmmoduleinstaller">
	<cffunction name="init">
    	<cfset itms = arraynew(1)>
    	<cfreturn this>
    </cffunction>
    
    <cffunction name="note">
    	<cfargument name="noteitem" required="true">
        <cfset arrayappend(itms, noteitem)>
    </cffunction>
    
    <cffunction name="show">
    	<cfset itmcntr = "">
    	<cfloop from="1" to="#arraylen(itms)#" index="itmcntr">
        	<cfset itms[itmcntr] = "<li>" & itms[itmcntr] & "</li>">
        </cfloop>
        <cfif arraylen(itms)>
    		<cfreturn "<ul>" & arraytolist(itms, "#chr(13)##chr(10)#") & "</ul>">
        <cfelse>
        	<cfreturn "">
        </cfif>
    </cffunction>
</cfcomponent>