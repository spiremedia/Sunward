<cfcomponent name="form" extends="resources.forms">

	<cffunction name="init">	
		<cfargument name="requestObject" required="true">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset super.init(requestObject = arguments.requestObject)>
		<cfreturn this>			
	</cffunction>
	
	<cffunction name="getForm">
		<cfargument name="id" type="string" required="true">
		<cfset var me = "">
		<cfquery name="me" datasource="#variables.requestObject.getVar('dsn')#">
			SELECT id, name, recipient, definition, reply
			FROM forms_view
			WHERE id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#">
		</cfquery>
		<cfreturn me>
	</cffunction>
	
	<cffunction name="formValidate">
		<cfargument name="vdtr" required="true">
		
		<cfscript> 
			var info = variables.requestObject.getAllFormUrlVars();
			var arrKey = '';
			var stMatch = '';
			var xmlFormData = '';			
		
			arrKey = StructKeyArray(info);
			ArraySort(arrKey, 'textnocase');	
		 	
			count = 1;
			while(isdefined("info.field_label_#count#"))
			{
				if (not isdefined("info.field_#count#"))
				{
			 		info['field_#count#'] = "";
				}
				 count= count + 1;
			}
				
			// Loop through each form field required
			for(i = 1; i lte ArrayLen(arrKey); i = i + 1)
			{
				stMatch = ReFind('^FIELD_REQUIRED_(\d+)$', arrKey[i], 1, true);
				if
				(
					stMatch.len[1] is not 0 
					and
					stMatch.pos[1] is not 0
				)
				{
					if (structKeyExists(info, 'FIELD_' & Mid(arrKey[i], stMatch.pos[2], stMatch.len[2]))
						and  (info['FIELD_' & Mid(arrKey[i], stMatch.pos[2], stMatch.len[2])] eq ''))
					{
						// validate field
						vdtr.notBlank('FIELD_' & Mid(arrKey[i], stMatch.pos[2], stMatch.len[2]), info['FIELD_' & Mid(arrKey[i], stMatch.pos[2], stMatch.len[2])], info['FIELD_LABEL_' & Mid(arrKey[i], stMatch.pos[2], stMatch.len[2])] & ' is required');
					}
				}
			}
		</cfscript>			

	</cffunction>
	
	<cffunction name="processFormSubmission" returntype="struct">		
		<cfargument name="formname" required="no" type="string" default="Form">		
		<cfscript> 
			var info = variables.requestObject.getAllFormUrlVars();
			var arrKey = '';
			var stMatch = '';
			var formsubmission = structNew();
			var xmlFormData = '';	
				 
			formsubmission.id = createuuid();
			formsubmission.formid = info.formid;
			formsubmission.submissiondate = createODBCTime(Now());
			formsubmission.formfield = arrayNew(1);
			formsubmission.answer = arrayNew(1);
			
			arrKey = StructKeyArray(info);
			ArraySort(arrKey, 'textnocase');			
			
			// save form submission
			saveFormSubmission(
				id = formsubmission.id,
				formid = formsubmission.formid,
				submissiondate = formsubmission.submissiondate,
				name = formname,
				type =  'forms'
			);

			// Loop through each form question
			i = 1;
			while(structkeyexists(info, "field_#i#") )
			{
			
				arrayAppend(formsubmission.formfield, XmlFormat(info["field_label_#i#"]));
				arrayAppend(formsubmission.answer, XmlFormat(info["field_#i#"]));
				// save form submission answers
				saveFormSubmissionEntry(
					id = formsubmission.id,
					formfield = formsubmission.formfield[arraylen(formsubmission.formfield)],
					answer = formsubmission.answer[arraylen(formsubmission.answer)]
				);
				i = i + 1;
			}
			
			return formsubmission;
		</cfscript>			
		
	</cffunction>
    <cffunction name="die">
    	<cfargument name="m">
        <cfdump var=#m#>
        <cfabort>
    </cffunction>

	<cffunction 
		name="transformFormContent" 
		access="public" 
		output=false 
		returntype="string" 
		hint='<fusedoc fuse="" language="ColdFusion" version="2.0">
				<responsibilities>
					Transforms the FormWizard Content into an xhtml form.
				</responsibilities>
				<properties>
					<history date="2006-04-12" author="Matthew Gaddis" email="matthew@spiremedia.com" type="create" role="architect" />
				</properties>
				<io>
					<in>
						<string name="fileSystem" optional="false" />
					</in>
					<out>
						<string />
					</out>
				</io>
			</fusedoc>'>
		<!--- function code --->
		<cfargument name="formContent" type="string" required=true>
		<cfargument name="formID" type="string" required=true>
		
		
		<cfset var objString = CreateObject('component', 'utilities.string').init()>
		<cfset var strFormHtml = ''>
		<cfset var strFormWizardXslFilePath = variables.requestObject.getVar('machineroot') & '/modules/forms/xsl/FormWizard.xsl'>
		<cfset var strFormWizardXsl = ''>
		<cfset var stFormWizardTransformOptions = StructNew()>

		<cfset StructInsert(stFormWizardTransformOptions, 'action', '')>
		<cfset StructInsert(stFormWizardTransformOptions, 'formId', arguments.formID)>
		
		<cfif FileExists(strFormWizardXslFilePath)>
			<cffile action="read" file="#strFormWizardXslFilePath#" variable="strFormWizardXsl">
			
			<cfset strFormHtml = objString.parseHtml
			(
				strHtml = XmlTransform
				(
					arguments.formContent,
					strFormWizardXsl,
					stFormWizardTransformOptions
				),
				asXhtml = true
			)>
		</cfif>
		
		<cfreturn strFormHtml>
	</cffunction>
	
	<cffunction name="insertsubmittedvalues">
			<cfargument name="html" required="true">
			<cfargument name="values" required="true">
			
			<cfset var l = structnew()>
			<cfset html = xmlparse(html)>
				
			<!--- text inputs --->
			<cfset l.m = xmlsearch(html,"//input[@type='text']")>
			<cfloop from="1" to="#arraylen(l.m)#" index="l.idx">
				<cfset l.itm = l.m[l.idx]>
				<cfif structkeyexists(values, l.itm.xmlattributes.name)>
					<cfset l.itm.xmlattributes.value= values[l.itm.xmlattributes.name]>
				</cfif>
			</cfloop>
			
			<!--- textareas --->
			<cfset l.m = xmlsearch(html,"//textarea")>
			<cfloop from="1" to="#arraylen(l.m)#" index="l.idx">
				<cfset l.itm = l.m[l.idx]>
				<cfif structkeyexists(values, l.itm.xmlattributes.name)>
					<cfset l.itm.XmlText = values[l.itm.xmlattributes.name]>
				</cfif>
			</cfloop>
			
			<!--- checkbox radios --->
			<cfset l.m = xmlsearch(html,"//input[@type='checkbox' or @type='radio']")>
			
			<cfloop from="1" to="#arraylen(l.m)#" index="l.idx">
				<cfset l.itm = l.m[l.idx]>
				<cfset l.name = l.itm.xmlattributes.name>
				<cfset l.val = xmlformat(l.itm.xmlattributes.value)>
				<cfif structkeyexists(values, l.name) AND find(l.val, values[l.name])>
					<cfset l.itm.xmlattributes.checked = "checked">
				</cfif>
			</cfloop>
			
			<!--- selects --->
			<cfset l.m = xmlsearch(html,"//select")>
			<cfloop from="1" to="#arraylen(l.m)#" index="l.idx">
				<cfset l.itm = l.m[l.idx]>
				<cfset l.name = l.itm.xmlattributes.name>
				
				<cfif structkeyexists(values, l.name)>
					<cfset l.val = values[l.name]>
					<cfset l.options = l.itm.xmlchildren>
					<cfloop from="1" to="#arraylen(l.options)#" index="l.idx2">
						<cfset l.option = l.options[l.idx2]>
						<cfif xmlformat(l.option.XmlText) EQ l.val>
							<cfset l.option.XmlAttributes.selected = "selected">
						</cfif>
					</cfloop>
				</cfif>
			</cfloop>		
	
			<cfset html = tostring(html)>
			<cfset html = replace(html, '<?xml version="1.0" encoding="UTF-8"?>',"")>
			
			 <cfreturn html>
	</cffunction>
	
</cfcomponent>