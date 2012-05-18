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
			for(i = 1; i lte ArrayLen(arrKey); i = i + 1)
			{
				stMatch = ReFind('^FIELD_LABEL_(\d+)$', arrKey[i], 1, true);
				if
				(
					stMatch.len[1] is not 0 
					and
					stMatch.pos[1] is not 0
				)
				{
					if (structKeyExists(info, 'FIELD_' & Mid(arrKey[i], stMatch.pos[2], stMatch.len[2])))
					{
						arrayAppend(formsubmission.formfield, XmlFormat(info[arrKey[i]]));
						arrayAppend(formsubmission.answer, XmlFormat(info['FIELD_' & Mid(arrKey[i], stMatch.pos[2], stMatch.len[2])]));
						// save form submission answers
						saveFormSubmissionEntry(
							id = formsubmission.id,
							formfield = formsubmission.formfield[arraylen(formsubmission.formfield)],
							answer = formsubmission.answer[arraylen(formsubmission.answer)]
						);
					}
				}
			}
			
			return formsubmission;
		</cfscript>			
		
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
	
</cfcomponent>