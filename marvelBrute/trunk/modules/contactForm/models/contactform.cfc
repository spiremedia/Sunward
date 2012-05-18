<cfcomponent name="contactform" extends="resources.forms">

	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="data">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.data = arguments.data>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="validateContactForm">		
		
		<cfset var lcl = structnew()>		
		<cfset var vdtr = createObject('component', 'resources.abstractController').getUtility('datavalidator').init()>       	
		<cfset var info = requestObject.getAllFormUrlVars()>
		
		<cfparam name="info.contactFormID" default="">
		<!---<cfparam name="info.InquiryType" default="">--->
		<cfparam name="info.FirstName" default="">
		<cfparam name="info.LastName" default="">
		<cfparam name="info.EmailAddress" default="">
		<cfparam name="info.PhoneNumber" default="">
		<cfparam name="info.Address" default="">
		<cfparam name="info.City" default="">
		<cfparam name="info.StateProv" default="">
		<cfparam name="info.ZipPostal" default="">
		<cfparam name="info.Country" default="">
		<cfparam name="info.BuildingUse" default="">
		<cfparam name="info.DateNeeded" default="">
		<cfparam name="info.SiteLocation" default="">
		<cfparam name="info.SizeInFtWidth" default="">
		<cfparam name="info.Length" default="">
		<cfparam name="info.SizeInFtHeight" default="">
		<cfparam name="info.ReferralType" default="">
		<cfparam name="info.ReferralSpecific" default="">
		<cfparam name="info.Comments" default="">
		
		<!--- trim all form fields  --->
		<cfset info.contactFormID = trim(info.contactFormID)>
		<!---<cfset info.InquiryType = trim(info.InquiryType)>--->
		<cfset info.FirstName = trim(info.FirstName)>
		<cfset info.LastName = trim(info.LastName)>
		<cfset info.EmailAddress = trim(info.EmailAddress)>
		<cfset info.PhoneNumber = trim(info.PhoneNumber)>
		<cfset info.Address = trim(info.Address)>
		<cfset info.City = trim(info.City)>
		<cfset info.StateProv = trim(info.StateProv)>
		<cfset info.ZipPostal = trim(info.ZipPostal)>
		<cfset info.Country = trim(info.Country)>
		<cfset info.BuildingUse = trim(info.BuildingUse)>
		<cfset info.DateNeeded = trim(info.DateNeeded)>
		<cfset info.SiteLocation = trim(info.SiteLocation)>
		<cfset info.SizeInFtWidth = trim(info.SizeInFtWidth)>
		<cfset info.SizeInFtLength = trim(info.SizeInFtLength)>
		<cfset info.SizeInFtHeight = trim(info.SizeInFtHeight)>
		<cfset info.ReferralType = trim(info.ReferralType)>
		<cfset info.ReferralSpecific = trim(info.ReferralSpecific)>
		<cfset info.Comments = trim(info.Comments)>
		
		<cfset vdtr.notblank('FirstName', info.FirstName, 'Please enter a First Name.')>
		<cfset vdtr.notblank('LastName', info.LastName, 'Please enter a Last Name.')>
		<cfset vdtr.validemail('EmailAddress', info.EmailAddress, 'The Email Address must be a valid email.')>
		<cfset vdtr.validphone('PhoneNumber', info.PhoneNumber, 'Please Enter a Valid Phone Number. Format:(xxx)xxx-xxxx')>
		
		<!---<cfif findnocase("New Building Inquiry",info.InquiryType)>--->
			<cfif info.SizeInFtWidth NEQ "">
				<cfset vdtr.isinteger('SizeInFtWidth', info.SizeInFtWidth, "Please enter a number for Size (in ft) W.")>
			</cfif>
			<cfif info.SizeInFtLength NEQ "">
				<cfset vdtr.isinteger('SizeInFtLength', info.SizeInFtLength, "Please enter a number for Size (in ft) L.")>
			</cfif>
			<cfif info.SizeInFtHeight NEQ "">
				<cfset vdtr.isinteger('SizeInFtHeight', info.SizeInFtHeight, "Please enter a number for Size (in ft) H.")>
			</cfif>
		<!---</cfif>--->
	
		<cfreturn vdtr/>
	</cffunction>
	
	<cffunction name="processContactForm">
		<cfset var info = variables.requestObject.getAllFormUrlVars()>
		<cfset var lcl = structNew()>

		<cfparam name="info.contactFormID" default="">
		<!--- added 06.22.2009 by Brian M Falls (info.site)--->
		<cfparam name="info.site" default="MarvelBrute">
		<cfparam name="info.FirstName" default="">
		<cfparam name="info.LastName" default="">
		<cfparam name="info.EmailAddress" default="">
		<cfparam name="info.PhoneNumber" default="">
		<cfparam name="info.Address" default="">
		<cfparam name="info.City" default="">
		<cfparam name="info.StateProv" default="">
		<cfparam name="info.ZipPostal" default="">
		<cfparam name="info.Country" default="">
		<cfparam name="info.BuildingUse" default="">
		<cfparam name="info.DateNeeded" default="">
		<cfparam name="info.SiteLocation" default="">
		<cfparam name="info.SizeInFtWidth" default="">
		<cfparam name="info.Length" default="">
		<cfparam name="info.SizeInFtHeight" default="">
		<cfparam name="info.ReferralType" default="">
		<cfparam name="info.ReferralSpecific" default="">
		<cfparam name="info.Comments" default="">
		
		<!--- trim all form fields  --->
		<cfset info.contactFormID = trim(info.contactFormID)>
		<!--- added 06.22.2009 by Brian M Falls (info.site)--->
		<cfset info.site = trim(info.site)>
		<cfset info.FirstName = trim(info.FirstName)>
		<cfset info.LastName = trim(info.LastName)>
		<cfset info.EmailAddress = trim(info.EmailAddress)>
		<cfset info.PhoneNumber = trim(info.PhoneNumber)>
		<cfset info.Address = trim(info.Address)>
		<cfset info.City = trim(info.City)>
		<cfset info.StateProv = trim(info.StateProv)>
		<cfset info.ZipPostal = trim(info.ZipPostal)>
		<cfset info.Country = trim(info.Country)>
		<cfset info.BuildingUse = trim(info.BuildingUse)>
		<cfset info.DateNeeded = trim(info.DateNeeded)>
		<cfset info.SiteLocation = trim(info.SiteLocation)>
		<cfset info.SizeInFtWidth = trim(info.SizeInFtWidth)>
		<cfset info.SizeInFtLength = trim(info.SizeInFtLength)>
		<cfset info.SizeInFtHeight = trim(info.SizeInFtHeight)>
		<cfset info.ReferralType = trim(info.ReferralType)>
		<cfset info.ReferralSpecific = trim(info.ReferralSpecific)>
		<cfset info.Comments = trim(info.Comments)>
		
		<cfset lcl.formname = 'Contact Form'>
		<cfset lcl.formsubmission = structNew()>
		<cfset lcl.formsubmission.id = createuuid()>
		<cfset lcl.formsubmission.formid = info.contactFormID>
		<cfset lcl.formsubmission.submissiondate = createODBCTime(Now())>
		<cfset lcl.formsubmission.formfield = arrayNew(1)>
		<cfset lcl.formsubmission.answer = arrayNew(1)>
		<!--- updated 06.22.2009 by Brian M Falls (added hidden field for site)--->
		<cfset lcl.listFormFields = "Site,FirstName,LastName,EmailAddress,PhoneNumber,Address,City,StateProv,ZipPostal,Country,BuildingUse,DateNeeded,SiteLocation,SizeInFtWidth,SizeInFtLength,SizeInFtHeight,ReferralType,ReferralSpecific,Comments">

		<cfset lcl.recipient = variables.data.recipient_general>

		<!---  save form submission --->
		<cfset saveFormSubmission(
			id = lcl.formsubmission.id,
			formid = lcl.formsubmission.formid,
			submissiondate = lcl.formsubmission.submissiondate,
			name = lcl.formname,
			type =  'contactForm'
		)>
		
		<!--- looping through and save each form field entry/answer --->
		<cfloop list="#lcl.listFormFields#" index="lcl.i">
			<cfif structKeyExists(info, lcl.i)>				
				<cfset arrayAppend(lcl.formsubmission.formfield, lcl.i)>
				<cfset arrayAppend(lcl.formsubmission.answer, XmlFormat(info[lcl.i]))>
				<cfset saveFormSubmissionEntry(
					id = lcl.formsubmission.id,
					formfield = lcl.formsubmission.formfield[arraylen(lcl.formsubmission.formfield)],
					answer = lcl.formsubmission.answer[arraylen(lcl.formsubmission.answer)]
				)>
			</cfif>
		</cfloop>

		<!--- send email --->
		<cfset sendFormSubmissionEmail( 
			recipient = lcl.recipient,
			formname = lcl.formname,
			formsubmission = lcl.formsubmission,
			replyto = ""
		)>	
		
		<cfset sendFormSubmissionEmailCustom( 
			recipient = lcl.formsubmission.answer[4],
			formname = lcl.formname,
			formsubmission = lcl.formsubmission,
			replyto = ""
		)>
		
		<!--- added 06.22.2009 by Brian M Falls (cfdir through cffile)--->
		<!--- append to .txt file used in clients 'custom' ftp process --->
		<cfdirectory action="list" directory="#requestObject.getVar("dataroot")#" name="dirList">
		<cffile action="read" file="#dirList.directory#/#dirList.name#" variable="readContents">
		
		<!--- contents to append --->
		<cfset contentsToAppend = "">
		<cfloop list="#lcl.listFormFields#" delimiters="," index="i">
			<cfset contentsToAppend = listAppend(contentsToAppend, info[i], ",")>
		</cfloop>
		<cfset contentsToAppend = listAppend(contentsToAppend, "#dateFormat(now(), "mm/dd/yyyy")# - #timeFormat(now(), "h:mm")#", ",")>
		
		<cffile 
			action = "append"
			file = "#dirList.directory#/#dirList.name#"
			output = "#contentsToAppend#"
			addNewLine = "yes"
			attributes = "normal">
		
	</cffunction>

</cfcomponent>
