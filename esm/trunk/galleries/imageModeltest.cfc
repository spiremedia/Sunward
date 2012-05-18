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
			FROM galleryImages
			WHERE name = 'imtestingname'
		</cfquery>
		<cfquery name="lcl.q" datasource="#requestObj.getVar("dsn")#">
			DELETE
			FROM galleryImages_log
			WHERE description LIKE '%imtestingname%'
		</cfquery>
	</cffunction>
	
    <cffunction name="testImageModel">
    	<cfset var lcl = structnew()>
		<cfset var grpdata = "">
		<cfset var mdl = createObject('component', 'galleries.controller').init(requestObj, userObj).getModel(requestObj, userObj)>
		
		<cfset data = structnew()>
		<cfset data.id = "0">
		<cfset data.name ="">
		<cfset data.active ="1">
        <cfset data.title ="my title">
        <cfset data.sortdate ="02/03/2001">
		<cfset data.gallerygroupids = "test,test2">
		<cfset data.description = "imtestingdescription">
		
		<cfset mdl.setValues(data)>
		<cfset lcl.vdtr = mdl.validate()>

		<cfset assertfalse(condition=lcl.vdtr.passValidation(),message="should not pass validation with name blank")>

		<cfset data.name = "imtestingname">
		
		<cfset lcl.vdtr = mdl.validate()>

		<cfset asserttrue(condition=lcl.vdtr.passValidation(),message="should pass validation with ok dataset")>
		
		<cfset lcl.newid = mdl.save()>
		
		<!--- check database to see if its there --->
		<cfset lcl.fieldlist = "id,name,description,active,changeddate,changedby">
		<cfquery name="lcl.q" datasource="#requestObj.getVar("dsn")#">
			SELECT #lcl.fieldlist# 
			FROM galleryImages
			WHERE name = <cfqueryparam value="#data.name#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset asserttrue(condition=lcl.q.recordcount EQ 1, message="No records found after insert")>
		
		<cfquery name="lcl.q" datasource="#requestObj.getVar("dsn")#">
			SELECT count(*) cnt
			FROM galleryImagesToGroup
			WHERE galleryimageid = <cfqueryparam value="#lcl.newid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset asserttrue(condition=lcl.q.cnt EQ 2, message="After insert, incorrect number of linking records in galleryimagestogrup")>

		<cfquery name="lcl.q" datasource="#requestObj.getVar("dsn")#">
			SELECT count(*) cnt
			FROM galleryImages_log
			WHERE description LIKE <cfqueryparam value="%#data.name#%" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfset asserttrue(condition=lcl.q.cnt EQ 1, message="query did not trigger observer to log log is blank.")>
		
		<cfset mdl = createObject('component', 'galleries.controller').init(requestObj, userObj).getModel(requestObj, userObj)>
		
		<cfset mdl.load(lcl.newid)>
		
		<cfset asserttrue(condition=mdl.load(lcl.newid), message="Load was unsuccessful")>
		
		<cfset asserttrue(condition=(mdl.getField('name') EQ data.name), message="didnt get right name")>
		<cfset asserttrue(condition=(mdl.getField('description') EQ data.description), message="didnt get right description")>
		
		<cfset data.description = "hello">
		<cfset mdl.setValues(data)>
		<cfset lcl.vdtr = mdl.validate()>
		<cfset asserttrue(condition=lcl.vdtr.passValidation(),message="should pass validation with ok dataset when updating")>
		
		<cfset mdl.save()>

		<cfquery name="lcl.q" datasource="#requestObj.getVar("dsn")#">
			SELECT count(*) cnt
			FROM galleryImages_log
			WHERE description LIKE <cfqueryparam value="%#data.name#%" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset asserttrue(condition=lcl.q.cnt EQ 2, message="query did not trigger observer to log on update.")>

		<cfset lcl.delv = mdl.validateDelete(lcl.newid)>
		
		<cfset asserttrue(condition=lcl.delv.passValidation(), message="validate delete should of passed validation")>
		
        <cftry>
			<cfset mdl.DeleteImage(lcl.newid)>
			<cfcatch>
            	<cfif NOT findnocase("does not exists", cfcatch.message)>
                	<cfset fail(message="Issue deleting image")>
                </cfif>
            </cfcatch>
         </cftry>
         
		<cfquery name="lcl.q" datasource="#requestObj.getVar("dsn")#">
			SELECT count(*) cnt
			FROM galleryImages_view
			WHERE name = <cfqueryparam value="#data.name#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset asserttrue(condition=lcl.q.cnt EQ 0, message="delete action did not remove record.")>
	
		<cfquery name="lcl.q" datasource="#requestObj.getVar("dsn")#">
			SELECT count(*) cnt
			FROM galleryImagesToGroup
			WHERE galleryimageid = <cfqueryparam value="#lcl.newid#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset assertfalse(condition=lcl.q.cnt, message="Did not delete records in linking table")>

		<cfquery name="lcl.q" datasource="#requestObj.getVar("dsn")#">
			SELECT count(*) cnt
			FROM galleryImages_log
			WHERE description LIKE <cfqueryparam value="%#data.name#%" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset asserttrue(condition=lcl.q.cnt EQ 3, message="delete action did not trigger observer to log log is blank on delete.")>

    </cffunction>
	
	<cffunction name="testGetAssets">
    	<cfset var lcl = structnew()>
		<cfset var grpdata = "">
		<cfset var mdl = createObject('component', 'galleries.controller').init(requestObj, userObj).getModel(requestObj, userObj)>
		<cfset mdl.getImages()>
	</cffunction>
    
</cfcomponent>