<cfcomponent name="model" output="false" extends="resources.abstractContentObjectEditorModel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		
		<cfset loadItem(variables.request.getFormUrlVar('id'))>
		
		<cfparam name="variables.assetids" default="">
		<cfparam name="variables.assetgroupid" default="">

		<cfreturn this>
	</cffunction>
	
	<cffunction name="getinfo">
		<cfset var r = structnew()>
		<cfset r.id = variables.id>
		<cfset r.assetgroupid = variables.assetgroupid>
		<cfset r.assetids = variables.assetids>
		<cfreturn r>
	</cffunction>
	<!--- TODO setup this model to be inheritance based to save duplicaating load item --->
			
	<cffunction name="setvalues">
		<cfargument name="itemdata">
		<cfset variables.id = arguments.itemdata.id>
		<cfset variables.assetgroupid = arguments.itemdata.assetgroupid>
		<cfset variables.assetids = arguments.itemdata.assetids>
	</cffunction>
	
	<cffunction name="validate">		
		<cfset var local = structnew()>
		
		<cfset var vdtr = createObject('component','utilities.datavalidator').init()>
		<cfset var mylcl = structnew()>
		
		<cfif variables.assetgroupid NEQ "" AND variables.assetids NEQ "">
			<cfset vdtr.addError('assetGroupName', 'Please choose only one - an Asset Group, or an individual asset.')>
		</cfif>
		
		<cfif variables.assetgroupid EQ "" AND variables.assetids EQ "">
			<cfset vdtr.addError('assetGroupName', 'Please choose one - an Asset Group, or an individual asset.')>
		</cfif>
		
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="save">
		<cfset var mydata = structnew()>

		<cfset mydata.assetgroupid = variables.assetgroupid>
		<cfset mydata.assetids = variables.assetids>

		<cfset saveData(mydata)>
	</cffunction>

</cfcomponent>
	