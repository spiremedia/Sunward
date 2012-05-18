<cfcomponent name="cloudView">
	
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="data">
		<cfargument name="name">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.data = arguments.data>
		<cfset variables.name = arguments.name>
		<cfset variables.itemsinrow = 3>
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
            <div class="galleries">
				<link rel="stylesheet" href="/ui/css/JQprettyPhoto.css" type="text/css" media="screen" title="prettyPhoto main stylesheet" charset="utf-8" />
				<script src="/ui/js/jquery.prettyPhoto.js" type="text/javascript" charset="utf-8"></script>
				<cfoutput>
            	<table class="#variables.name#">
					<cfloop query="lcl.qry">
						<cfif currentrow mod variables.itemsinrow EQ 1><tr></cfif>
						<td>
							<div>
								<a href="/docs/imagegalleries/#id#/#rereplace(filename,"\.(jpg|png)$", "_img.\1")#" rel="prettyPhoto">
									<img src="/docs/imagegalleries/#id#/#rereplace(filename,"\.(jpg|png)$", "_thmb.\1")#" alt="#title#"/>
								</a>
								<h5 style="text-align:center">#title#</h5>
							</div>
						</td>
						<cfif currentrow mod variables.itemsinrow EQ 0 OR currentrow EQ recordcount></tr></cfif>
					</cfloop>
				</table>
				<script type="text/javascript" charset="utf-8">
					$(document).ready(function(){
						$(".#variables.name# a[rel^='prettyPhoto']").prettyPhoto();
					});
				</script>
				</cfoutput>
            </div>
        </cfsavecontent>
        <cfreturn lcl.html>
    </cffunction>
	
</cfcomponent>