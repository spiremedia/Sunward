<cfcomponent name="simplecontent" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="hirange" default="6">
        <cfargument name="lowrange" default="1">
		
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.hirange = arguments.hirange>
        <cfset variables.lowrange = arguments.lowrange>
		<cfset variables.cloudItems = structnew()>
        
		<cfreturn this>
	</cffunction>
    
    <cffunction name="addCloudItem">
    	<cfargument name="phrase" required="true">
        <cfargument name="count" default="1">
        
        <cfif NOT(isnumeric(arguments.count) AND arguments.count EQ int(arguments.count))>
        	<cfthrow message="error adding cloud item ""#phrase#"" with count ""#count#"" - not numeric">
        </cfif>
        
        <cfif structkeyexists(variables.cloudItems, phrase)>
        	<cfset variables.cloudItems[arguments.phrase] = variables.cloudItems[arguments.phrase] + count>
        <cfelse>
        	<cfset variables.cloudItems[arguments.phrase] = count>
        </cfif>
    </cffunction>
    
    <cffunction name="getyCloudItemCount">
    	<cfargument name="phrase" required="true">
             
        <cfif structkeyexists(variables.cloudItems, phrase)>
        	<cfreturn variables.cloudItems[arguments.phrase]>
        <cfelse>
        	<cfreturn 0>
        </cfif>
    </cffunction>
    
	<cffunction name="getCloudItems">
		<cfset var lcl = structnew()>
		<cfset tempitems = structnew()>
		<cfset lcl.max = getMax()>
        <cfset lcl.min = getMin()>
        <cfset lcl.returnquery = querynew("phrase,cnt,range")>
        <cfset lcl.delta = (lcl.max - lcl.min)>
       
		<cfif lcl.delta EQ 0>
        	<cfloop collection="#variables.cloudItems#" item="lcl.itm">
				<cfset tempItems[lcl.itm] = 4>
            </cfloop>
        <cfelse>
            <cfloop collection="#variables.cloudItems#" item="lcl.itm">
				<cfset tempItems[lcl.itm] = (variables.cloudItems[lcl.itm] - lcl.min) / lcl.delta * (variables.hirange - variables.lowrange) + variables.lowrange>
            </cfloop>
		</cfif>
        
		<cfset lcl.keylist = listtoarray(structkeylist(variables.cloudItems))>
		<cfset arraysort(lcl.keylist, "textnocase")>
        <cfset lcl.keylist = arraytolist(lcl.keylist)>
       
        <cfloop list="#lcl.keylist#" index="lcl.itm">
        	<cfset queryaddrow(lcl.returnquery)>
            <cfset querysetcell(lcl.returnquery, "phrase", lcl.itm)>
            <cfset querysetcell(lcl.returnquery, "cnt", variables.cloudItems[lcl.itm])>
            <cfset querysetcell(lcl.returnquery, "range", round(tempItems[lcl.itm]))>
        </cfloop>
        
        <cfreturn lcl.returnquery>
	</cffunction>
    
    <cffunction name="getMax">
    	<cfset var lcl = structnew()>
        <cfset lcl.num = 0>
    	<cfloop collection="#variables.cloudItems#" item="lcl.itm">
        	<cfif variables.cloudItems[lcl.itm] GT lcl.num>
        		<cfset lcl.num = variables.cloudItems[lcl.itm]>
            </cfif>
        </cfloop>
        <cfreturn lcl.num/>
    </cffunction>
    
    <cffunction name="getMin">
    	<cfset var lcl = structnew()>
        <cfset lcl.keylist = structkeylist(variables.cloudItems)>
        
        <!--- cloud is empty return 0 --->
		<cfif structisempty(variables.cloudItems)>
			<cfreturn 0>
        </cfif>
        
        <!--- loop and return lowest --->
		<cfset lcl.num = variables.cloudItems[listgetat(lcl.keylist,1)]>
    	<cfloop collection="#variables.cloudItems#" item="lcl.itm">
        	<cfif variables.cloudItems[lcl.itm] LT lcl.num>
        		<cfset lcl.num = variables.cloudItems[lcl.itm]>
            </cfif>
        </cfloop>
        
        <cfreturn lcl.num/>
    </cffunction>
    
    <cffunction name="loaded">
    	<cfreturn NOT structisempty(variables.cloudItems)>
    </cffunction>
	
</cfcomponent>