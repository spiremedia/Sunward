<cfcomponent displayname="galleryGroupModelTest" extends="mxunit.framework.TestCase">
	
	<cffunction name="setup">
		<cfset variables.requestObj = request.requestObject>
		<cfset variables.userObj = createObject('component','resources.defaultuser').init()>
		<cfset variables.userObj.setSuper(true)>
		<cfset variables.userObj.setCurrentSiteUrl("testing.com")>
		<cfset variables.userObj.setUserID("8C8DD7E6-EA08-57D6-6556D3BB74048D54")>
	</cffunction>
	
	<cffunction name="teardown">
		<cfset var lcl = structnew()>
		<cfquery name="lcl.q" datasource="#requestObj.getVar("dsn")#">
			DELETE
			FROM galleryGroups
			WHERE name = 'imtestinggroupname'
		</cfquery>
		<cfquery name="lcl.q" datasource="#requestObj.getVar("dsn")#">
			DELETE
			FROM galleryGroups_log
			WHERE description LIKE '%imtestinggroupname%'
		</cfquery>
	</cffunction>
	
    <cffunction name="testGroupModel">
    	<cfset var lcl = structnew()>
		<cfset var grpdata = "">
		<cfset var mdl = createObject('component', 'galleries.controller').init(requestObj, userObj).getGroupModel(requestObj, userObj)>
		
		<cfset grpdata = structnew()>
		<cfset grpdata.id = "">
		<cfset grpdata.name ="">
		<cfset grpdata.description = "imtestinggroupdescription">
		
		<cfset mdl.setValues(grpdata)>
		<cfset lcl.vdtr = mdl.validate()>

		<cfset assertfalse(condition=lcl.vdtr.passValidation(),message="should not pass validation with name blank")>

		<cfset grpdata.name = "imtestinggroupname">
		
		<cfset lcl.vdtr = mdl.validate()>

		<cfset asserttrue(condition=lcl.vdtr.passValidation(),message="should pass validation with ok dataset")>
		
		<cfset lcl.newid = mdl.save()>
		
		<!--- check database to see if its there --->
		<cfset lcl.fieldlist = "id,name,description,modified,deleted">
		<cfquery name="lcl.q" datasource="#requestObj.getVar("dsn")#">
			SELECT #lcl.fieldlist# 
			FROM galleryGroups
			WHERE name = <cfqueryparam value="#grpdata.name#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset asserttrue(condition=lcl.q.recordcount EQ 1, message="No records found after insert")>
		
		<cfloop list="#lcl.fieldlist#" index="lcl.idx">
			<cfif lcl.idx NEQ "id">
				<cfset asserttrue(condition=(lcl.q[lcl.idx][1] NEQ ""), message="query did not enter all data ""#lcl.idx#"" is blank.")>
			</cfif>
		</cfloop>
		
		<cfquery name="lcl.q" datasource="#requestObj.getVar("dsn")#">
			SELECT count(*) cnt
			FROM galleryGroups_log
			WHERE description LIKE <cfqueryparam value="%#grpdata.name#%" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset asserttrue(condition=lcl.q.cnt EQ 1, message="query did not trigger observer to log log is blank.")>
		
		<cfset mdl = createObject('component', 'galleries.controller').init(requestObj, userObj).getGroupModel(requestObj, userObj)>
		
		<cfset lcl.grp = mdl.getGalleryGroup(lcl.newid)>
		
		<cfset asserttrue(condition=lcl.grp.recordcount EQ 1, message="No records found in getGaleryGroup")>
		
		<cfloop list="#lcl.grp.columnlist#" index="lcl.idx">
			<cfset asserttrue(condition=(lcl.grp[lcl.idx][1] NEQ ""), message="getgallery group result not fuly populated all data ""#lcl.idx#"" is blank.")>
			<cfset grpdata[lcl.idx] = lcl.grp[lcl.idx][1]>
		</cfloop>
		
		<cfset grpdata.description = "hello">
		<cfset mdl.setValues(grpdata)>
		<cfset lcl.vdtr = mdl.validate()>
		<cfset asserttrue(condition=lcl.vdtr.passValidation(),message="should pass validation with ok dataset when updating")>
		
		<cfset mdl.save()>
		
		<cfquery name="lcl.q" datasource="#requestObj.getVar("dsn")#">
			SELECT count(*) cnt
			FROM galleryGroups_log
			WHERE description LIKE <cfqueryparam value="%#grpdata.name#%" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset asserttrue(condition=lcl.q.cnt EQ 2, message="query did not trigger observer to log on update.")>

		<cfset lcl.delv = mdl.validateDelete(lcl.newid)>
		
		<cfset asserttrue(condition=lcl.delv.passValidation(), message="validate delete should of passed validation")>
		
		<cfset mdl.DeleteGroup(lcl.newid)>
		
		<cfquery name="lcl.q" datasource="#requestObj.getVar("dsn")#">
			SELECT count(*) cnt
			FROM galleryGroups_log
			WHERE description LIKE <cfqueryparam value="%#grpdata.name#%" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset asserttrue(condition=lcl.q.cnt EQ 3, message="delete action did not trigger observer to log log is blank on delete.")>

    </cffunction>
    
</cfcomponent>