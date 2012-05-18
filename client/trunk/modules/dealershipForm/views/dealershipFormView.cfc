<cfcomponent ouput="false">
	<cffunction name="init" output="false">
    	<cfargument name="requestObject">
		<cfargument name="mdl">
		<cfargument name="data">
		
        <cfset variables.requestObject = arguments.requestObject>
		<cfset variables.mdl = arguments.mdl>		
		<cfset variables.data = arguments.data>		
        <cfreturn this>
    </cffunction>
	
    <cffunction name="showHTML" output="false">
		<cfif requestObject.isformurlvarset('dealershipFormID') AND data.vdtr.passValidation()>		
			<cfreturn showFormSubmissionReply()>
		<cfelse>				
			<cfreturn showContactForm()>
		</cfif>
    </cffunction>
	
    <cffunction name="showContactForm" output="false">
		<cfset var lcl = structnew()>
		<cfset lcl.intro = "">
		<cfset lcl.intro = lcl.intro & "<p>Contact us at 888-898-3091 or complete the form below.</p>">
		<cfset lcl.form = createObject('component', 'resources.abstractController').getUtility('formbuilder').init(requestObject,"contactForm",'Post',data.vdtr)>		
		<cfset lcl.form.addFormItem('contactFormID', '', 'hidden', 'CB7B54DE-A241-E558-13A3EB47DDBA482D')>
		<cfset lcl.options = structNew()>
		<cfset lcl.options.html = '<div id="contactBuildingForm">'>
		<cfset lcl.form.addFormItem('', '', 'html', '', lcl.options)>
		<cfset lcl.options.html = '<h3>Personal Information</h3>'>
		<cfset lcl.options.html = lcl.options.html & '</div>'>
		<cfset lcl.form.addFormItem('', '', 'html', '', lcl.options)>
		<cfset lcl.form.addFormItem('FirstName', 'First Name *', 'text')>
		<cfset lcl.form.addFormItem('LastName', 'Last Name *', 'text')>
		<cfset lcl.form.addFormItem('EmailAddress', 'Email Address *', 'text')>
		<cfset lcl.form.addFormItem('PhoneNumber', 'Phone Number *', 'text')>
		<cfset lcl.form.addFormItem('Address', 'Address', 'text')>
		<cfset lcl.form.addFormItem('City', 'City', 'text')>
		<cfset lcl.form.addFormItem('StateProv', 'State/Prov', 'text')>
		<cfset lcl.form.addFormItem('ZipPostal', 'Zip/Postal', 'text')>
		<cfset lcl.form.addFormItem('Country', 'Country', 'text')>
		<cfset lcl.options = structNew()>
		<cfset lcl.options.html = '<div id="contactBuildingForm">'>
		<cfset lcl.form.addFormItem('', '', 'html', '', lcl.options)>
		<cfset lcl.options.html = '<h3>Additional Comments</h3>'>
		<cfset lcl.options.html = lcl.options.html & '</div>'>
		<cfset lcl.form.addFormItem('', '', 'html', '', lcl.options)>
		<cfset lcl.referral = structNew()>
		<cfset lcl.referral.list = "">
		<cfset lcl.referral.delimiter = "|">
		<cfset lcl.referral.list = listAppend(lcl.referral.list, " | ")>
		<cfset lcl.referral.list = listAppend(lcl.referral.list, "Previous Buyer|Previous Buyer")>
		<cfset lcl.referral.list = listAppend(lcl.referral.list, "Referral|Referral")>
		<cfset lcl.referral.list = listAppend(lcl.referral.list, "Newspapar Ad|Newspapar Ad")>
		<cfset lcl.referral.list = listAppend(lcl.referral.list, "Magazine Ad|Magazine Ad")>
		<cfset lcl.referral.list = listAppend(lcl.referral.list, "Off Building|Off Building")>
		<cfset lcl.referral.list = listAppend(lcl.referral.list, "Other|Other")>
		<cfset lcl.form.addFormItem('ReferralType', 'How did you hear about us?', 'select', '' ,lcl.referral)><cfset lcl.options = structNew()>
		<cfset lcl.referral.html = '<p id="specifyOther" style="display:none; color: red; font-weight: bold; "><label>If Other *</label>'>
		<cfset lcl.referral.html = lcl.referral.html & '<input name="ReferralSpecific"  id="ReferralSpecific" value="Please Specify" type="text">'>
		<cfset lcl.referral.html = lcl.referral.html & '</p>'>
        <cfset lcl.form.addFormItem('', '', 'html', '', lcl.referral)>
		<cfset lcl.form.addformitem('Comments', 'Comments', 'textarea')>
		<cfset lcl.form.addSubmit('submit','', 'Submit')>
					
		<cfsavecontent variable="lcl.html">
			<div class="contactForm">
				<script type="text/javascript">  
				 $(document).ready(function(){  
					changeReferralType();  
					$("#ReferralType").change(changeReferralType); 
				 });  
				 function changeReferralType(){  
					var selected = $("#ReferralType option:selected");   
					if(selected.val() == ' '){ 
						 $("#specifyOther").hide();
					} else {   
						 $("#specifyOther").show();
					}  
				 }  
				</script>
				
				<cfoutput>
					#lcl.intro#
					#lcl.form.showHTML()#
				</cfoutput>
			</div>
	    </cfsavecontent>
		
    	<cfreturn lcl.html>
    </cffunction>
	
    <cffunction name="showFormSubmissionReply" output="false">
		<cfset var lcl = structnew()>
					
		<cfsavecontent variable="lcl.html">
			<cfoutput>
			<div class="dealershipForm">
				<p style=""font-weight:bold;"">#data.reply#<p>
			</div>
			</cfoutput>
	    </cfsavecontent>
		
    	<cfreturn lcl.html>
    </cffunction>
</cfcomponent>