<cfcomponent name="model" output="false" extends="resources.abstractmodel">

	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getFormData" output="false">
		<cfset var sg = "">
	
		<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
			SELECT Distinct fs.formid, fs.name, 
				 (
					(SELECT TOP 1 CONVERT(varchar, submissiondate) FROM formsubmission WHERE formid = fs.formid ORDER BY submissiondate ASC)  
					+ ' - ' + 
					(SELECT TOP 1 CONVERT(varchar, submissiondate) FROM formsubmission WHERE formid = fs.formid ORDER BY submissiondate DESC)
				)  AS submissiondate 
			FROM formSubmission fs
			WHERE fs.siteid = <cfqueryparam value="#userobj.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
			ORDER BY fs.name
		</cfquery>

		<cfreturn sg/>
	</cffunction>
	
	<cffunction name="getFormSubmission" output="false">
		<cfargument name="id" required="true">
		<cfset var sg = "">
	
		<cfquery name="sg" datasource="#variables.request.getvar('dsn')#">
			SELECT fs.submissiondate, fse.formsubmissionid, fse.formfield, fse.answer, fs.name, fs.formid
			FROM formSubmission fs, formSubmissionEntry fse
			WHERE fs.formid = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
			AND  fs.id = fse.formsubmissionid
			ORDER BY fs.submissiondate DESC
		</cfquery>
		
		<cfreturn sg/>
	</cffunction>
	
	<cffunction name="setFormDataXML" output="false">
		<cfargument name="qryFormSubmission" required="true">
		
		<cfset var lcl = structNew()>		
		<cfset lcl.stFormSubmission = structNew()>
		<cfset lcl.MyDoc = XmlNew(false)>
		<cfset lcl.formid = "">
		<cfset lcl.formname = "">
		<cfset lcl.formIDList = ''>
		<cfset lcl.headers = ''>
		<cfset lcl.arrFormFieds = arrayNew(1)>
		
		<cfif qryFormSubmission.recordcount>
			<!--- get current form fields in order --->
			<cfset lcl.arrFormFieds = getFormFields(qryFormSubmission.formid)>
			<!--- make field labels xml-safe --->
			<cfloop from="1" to="#arrayLen(lcl.arrFormFieds)#" index="i">
				<cfset lcl.arrFormFieds[i] = REReplace(ucase(lcl.arrFormFieds[i]),"[^A-Z0-9_]","","ALL")>
				<cfset lcl.arrFormFieds[i] = REReplace(lcl.arrFormFieds[i],"^[0-9_]","","ALL")>
			</cfloop>
			<cfset lcl.headers = arrayToList(lcl.arrFormFieds)>
			<cfoutput query="qryFormSubmission" group="formsubmissionid">
				<cfset lcl.formid = formid>
				<cfset lcl.formname = name>
				<cfset lcl.stFormSubmission[formsubmissionid] = structNew()>
				<cfset lcl.stFormSubmission[formsubmissionid]['submissiondate'] = submissiondate>
				<cfset lcl.formIDList = listAppend(lcl.formIDList,formsubmissionid)>
				<cfoutput>
					<cfset lcl.tempColName = REReplace(ucase(formfield),"[^A-Z0-9_]","","ALL")>
					<cfset lcl.tempColName = REReplace(lcl.tempColName,"^[0-9_]","","ALL")>
					<cfset lcl.stFormSubmission[formsubmissionid][lcl.tempColName] = answer>
					<cfif NOT listFind(lcl.headers,lcl.tempColName)>
						<cfset lcl.headers = listAppend(lcl.headers,lcl.tempColName)>
					</cfif>
				</cfoutput>
			</cfoutput>
		</cfif>

		<cfxml variable="lcl.MyDoc">
			<cfoutput>
				<formdata id="#lcl.formid#" name="#lcl.formname#">
					<!--- looping through each form submission  --->
					<cfloop list="#lcl.formIDList#" index="lcl.i">
						<submission date="#lcl.stFormSubmission[lcl.i]['submissiondate']#">
							<!--- looping through each form field entry/answer --->
							<cfloop list="#lcl.headers#" index="lcl.j">
								<field label="#lcl.j#">
									<cfif structKeyExists(lcl.stFormSubmission[lcl.i], lcl.j)>
										#lcl.stFormSubmission[lcl.i][lcl.j]#
									</cfif>
								</field>
							</cfloop>
						</submission>
					</cfloop>
				</formdata>
			</cfoutput>
		</cfxml>
		
		<cfreturn lcl.MyDoc>
	</cffunction>
	
	<cffunction name="setFormDataXLS" output="false">
		<cfargument name="qryFormSubmission" required="true">
		
		<cfset var lcl = structNew()>
		<cfset var xlsStruct = structNew()>
		
		<cfset lcl.stFormSubmission = structNew()>
		<cfset lcl.formIDList = ''>
		<cfset lcl.counter = 1>
		<cfset lcl.arrFormFieds = arrayNew(1)>
		
		<!--- list of form field columns, need this to keep the form field order --->
		<cfset xlsStruct.headers = ''>
		<!--- reformatted query of form submissions, each row contains a form submission --->
		<cfset xlsStruct.qry = queryNew("")>
		
		<cfif qryFormSubmission.recordcount>
			<!--- get current form fields in order --->
			<cfset lcl.arrFormFieds = getFormFields(qryFormSubmission.formid)>
			<!--- make field labels xls-safe --->
			<cfloop from="1" to="#arrayLen(lcl.arrFormFieds)#" index="i">
				<cfset lcl.arrFormFieds[i] = REReplace(ucase(lcl.arrFormFieds[i]),"[^A-Z0-9_]","","ALL")>
				<cfset lcl.arrFormFieds[i] = REReplace(lcl.arrFormFieds[i],"^[0-9_]","","ALL")>
			</cfloop>
			<cfset xlsStruct.headers = arrayToList(lcl.arrFormFieds)>
			<cfoutput query="qryFormSubmission" group="formsubmissionid">
				<cfset lcl.stFormSubmission[formsubmissionid] = structNew()>
				<cfset lcl.stFormSubmission[formsubmissionid]['SUBMISSIONDATE'] = dateFormat(submissiondate, "mm/dd/yyyy")>
				<cfset lcl.formIDList = listAppend(lcl.formIDList,formsubmissionid)>
				<cfoutput>
					<cfset lcl.tempColName = REReplace(ucase(formfield),"[^A-Z0-9_]","","ALL")>
					<cfset lcl.tempColName = REReplace(lcl.tempColName,"^[0-9_]","","ALL")>
					<cfset lcl.stFormSubmission[formsubmissionid][lcl.tempColName] = answer>
					<cfif NOT listFind(xlsStruct.headers,lcl.tempColName)>
						<cfset xlsStruct.headers = listAppend(xlsStruct.headers,lcl.tempColName)>
					</cfif>
				</cfoutput>
			</cfoutput>  
			<cfset xlsStruct.headers = listAppend(xlsStruct.headers,"SUBMISSIONDATE")>
		</cfif>
		
		<!--- reformatting query of form submissions, each record now contains a form submission --->
		<cfset xlsStruct.qry = QueryNew(xlsStruct.headers)>		
		<cfset QueryAddRow(xlsStruct.qry, listLen(lcl.formIDList))>
		<!--- looping through each form submission --->
		<cfloop list="#lcl.formIDList#" index="lcl.i">
			<!--- looping through each form field entry/answer --->
			<cfloop list="#xlsStruct.headers#" index="lcl.j">
				<cfif structKeyExists(lcl.stFormSubmission[lcl.i], lcl.j)>
					<cfset QuerySetCell(xlsStruct.qry, lcl.j, lcl.stFormSubmission[lcl.i][lcl.j], lcl.counter)>
				<cfelse>
					<cfset QuerySetCell(xlsStruct.qry, lcl.j, '', lcl.counter)>
				</cfif>
			</cfloop>
			<cfset lcl.counter = lcl.counter + 1>
		</cfloop>
		
		<cfreturn xlsStruct>
	</cffunction>
	
	<cffunction name="getFormFields" output="false">
		<cfargument name="id" required="true">
		
		<cfset var lcl = structNew()>
		<cfset var arrFormFields = arrayNew(1)>
	
		<cfquery name="lcl.me" datasource="#variables.request.getvar('dsn')#">
			SELECT id, definition
			FROM forms
			WHERE id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<cfif lcl.me.recordcount>
    		<cfset lcl.myxml = XmlParse(lcl.me.definition)>
    		<cfset lcl.selectedElements = XmlSearch(lcl.myxml, "/ul/li/dl/dt/span")>
			<cfloop from="1" to="#arrayLen(lcl.selectedElements)#" index="i">
				<cfset arrayAppend(arrFormFields, lcl.selectedElements[i].XmlText)>		
			</cfloop>
		</cfif>
		
		<cfreturn arrFormFields>
	</cffunction>
	
</cfcomponent>
	