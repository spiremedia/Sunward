<cfcomponent name="simplecontent" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfset variables.requestObject = arguments.requestObject>
			<cfreturn this>
	</cffunction>

    <cffunction name="getGalleriesData">
		<cfargument name="gallerygroupid" required="true">
       	<cfquery name="sg" datasource="#variables.requestObject.getvar('dsn')#" result="myre">
			SELECT 
				id, title, sortdate, name, filename, description
			FROM galleryimages_view
			WHERE gallerygroupid = <cfqueryparam value="#gallerygroupid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn sg>
    </cffunction>
	
</cfcomponent>