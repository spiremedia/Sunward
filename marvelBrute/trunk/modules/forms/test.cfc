<cfcomponent displayname="MyCFCTest" extends="mxunit.framework.TestCase">
		
	<cffunction name="setUp" returntype="void" access="public">		
		<cfset var lcl = structNew()>
		
		<cfset variables.requestObject = request.requestObject>
    	<cfset loadController()>
		
		<cfquery name="lcl.qry" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT id FROM users
			WHERE username = 'sa@spiremedia.com'
		</cfquery>
		
		<cfset lcl.userid = lcl.qry.id>
		<cfset variables.formid = createuuid()>
		
		<cfsavecontent variable="variables.definition">
		<ul style="position: relative;" id="palette">
			<li style="position: relative; z-index: 0; top: 0pt; left: 0pt; opacity: 0.999999;">
				<h5>Text Box</h5>
				<p class="handle">
					Make Required: 
					<input checked="checked" name="required" value="true" title="Is this field required?" type="checkbox" /><br /><br /> 
					<a href="#" class="remove" title="Remove?"><img src="/ui/images/button/delete.gif" alt="" /></a>
				</p>
				<dl>
					<dt><span class="" style="background-color: transparent; background-image: none;" title="Click to edit">Name</span></dt>
					<dd><img src="/ui/images/formwizard/text.gif" alt="" /></dd>
				</dl>
				<div class="clear">&#160;</div>
			</li>
		</ul>
		</cfsavecontent>
		
		<!--- insert form --->
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			INSERT INTO forms (id,siteid,name,recipient,definition,changedby,deleted,active,created,modified)
			VALUES (
				<cfqueryparam value="#variables.formid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.requestObject.getVar('siteid')#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="Form - Unit Test" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.requestObject.getVar('systememailfrom')#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#variables.definition#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam value="#lcl.userid#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="1" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="#CreateODBCdate(Now())#" cfsqltype="cf_sql_date">,
				<cfqueryparam value="#CreateODBCdate(Now())#" cfsqltype="cf_sql_date">
			)
		</cfquery>
	</cffunction>
    
    <cffunction name="teardown" returntype="void" access="public">
		<!--- remove form, formsubmissions --->
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			DELETE FROM forms WHERE id = <cfqueryparam value="#variables.formid#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfquery datasource="#variables.requestObject.getVar('dsn')#">
			DELETE FROM formSubmission WHERE formid = <cfqueryparam value="#variables.formid#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>
    
    <cffunction name="loadController" access="private">
    	<cfargument name="data" default="#structnew()#">
    	<cfargument name="requestObject" default="#variables.requestObject#">
    	<cfargument name="pageref" default="#structnew()#">
    	<cfset variables.controller = createObject("component","modules.forms.controller").init(
			data=arguments.data,
			requestObject=arguments.requestObject,
			pageref=arguments.pageref
		)>
    </cffunction>
	
    <!--- model tests --->
    <cffunction name="testGetForm">
    	<cfset var itm = variables.controller.getModel(requestObject=variables.requestObject)>
        <cfset var count = "">
		<cfset count = itm.getForm( id = variables.formid ).recordcount>

        <cfset assertequals(expected=1,actual=count,message="did not find correct form")>
    </cffunction>
	
    <cffunction name="testFormValidate">
		<cfset var lcl = structNew()>
        <cfset var vdtr = createObject('component', 'utilities.datavalidator').init()>
		
		<!--- mock form --->
		<cfset url.field_label_1 = 'Name'>
		<cfset url.field_1 = ''>
		<cfset url.field_required_1 = 1>
		<cfset lcl.requestObject = createobject('component', 'resources.request').init()>
		<cfset lcl.itm = variables.controller.getModel(requestObject=lcl.requestObject)>
		<cfset lcl.itm.formValidate(vdtr=vdtr)>
		
        <cfset assertequals(expected=1,actual=vdtr.fieldHasError('field_1'),message="form did not validate correctly")>
    </cffunction>
    
    <!--- ctrlr tests --->
    <cffunction name="testSubmitandDisplayForm">
		<cfset var lcl = structNew()>
        <cfset var data = structnew()>
        <cfset var html = "">
		
		<!--- mock form --->
		<cfset furl.field_label_1 = 'Name'>
		<cfset furl.field_1 = 'Unit Test'>
		<cfset furl.field_required_1 = 1>
		<cfset furl.formid = variables.formid>
		<cfset lcl.decRequestObject = createobject('component', 'resources.altformurlRequestDecorator').init(requestObject)>
		<cfset lcl.decRequestObject.setRequestFields(furl)> 		
		
		<!--- tests ShowHTML() and model transformFormContent() --->
		<cfset data.formid = variables.formid> 
    	<cfset loadController(data = data, requestObject=lcl.decRequestObject)>
		<cfset html = variables.controller.showHTML()>
        <cfset asserttrue(condition = refind('<form .*</form>',html),message="did not find matching form elements")>
        <cfset asserttrue(condition = refind('name="field_1"',html),message="did not find form element field_1")>
        <cfset asserttrue(condition = refind('name="field_label_1"',html),message="did not find form element field_label_1")>
        <cfset asserttrue(condition = refind('name="field_required_1"',html),message="did not find form element field_required_1")>
        <cfset asserttrue(condition = refind('name="submit"',html),message="did not find form element submit")>
        <cfset asserttrue(condition = refind('name="formid"',html),message="did not find form element formid")>
		
		<!--- tests ProcessFormSubmission() --->
		<cfquery name="lcl.me" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT * FROM formSubmission WHERE formid = <cfqueryparam value="#variables.formid#" cfsqltype="cf_sql_varchar">
		</cfquery>		
        <cfset assertequals(expected=1,actual=lcl.me.recordcount,message="did not save form submission properly")>
    </cffunction>
   
</cfcomponent>