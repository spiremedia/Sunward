<cfcomponent name="cloudView">
	
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="data">
		<cfargument name="name">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.data = arguments.data>
		<cfset variables.name = arguments.name>
		<cfset variables.itemsinrow = 5>
		<cfreturn this>
	</cffunction>
    
    <cffunction name="setModel">
        <cfargument name="Mdl">
        <cfset variables.Mdl = arguments.Mdl>
	</cffunction>
	
	<cffunction name="showHTML">
		<cfset var lcl = structnew()>
        <cfset lcl.qry = mdl.getGalleriesData(data.gallerygroupid)>
        <cfsavecontent variable="lcl.html">
			<cfoutput>
            <div class="galleries">
				<script type="text/javascript" src="/ui/js/galleries/gallerySideScroll.js"></script>
				<link rel="stylesheet" href="/ui/css/galleries/jqGalScroll.css" type="text/css" />
            	<ul id="gal_#variables.name#">
				<cfloop query="lcl.qry">
					<li><img src="/docs/imagegalleries/#id#/#rereplace(filename,"\.(jpg|png)$", "_med.\1")#" alt="#title#"/></li>
				</cfloop>
				</ul>
				<script type="text/javascript">
				    $(document).ready(function(){
				        $("##gal_#variables.name#").jqGalScroll({ease: null,
																speed:0,
																height: 300,
																width: 500,
																titleOpacity : .60,
																direction : 'horizontal'});
				    });
				</script>
            </div>
            <cfif requestObject.isFormUrlVarSet('hi')>
            	#requestObject.getFormUrlVar('hi')#

                <cfdump var=#requestObject.getallformurlvars()#>
            </cfif>
			</cfoutput>
        </cfsavecontent>
        <cfreturn lcl.html>
    </cffunction>
	
</cfcomponent>