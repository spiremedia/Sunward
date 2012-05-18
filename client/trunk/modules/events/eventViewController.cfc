<cfcomponent name="eventViewController" output="false" extends="resources.abstractController">
	
	<cffunction name="init" output="false">
		<cfargument name="data" required="true">
		<cfargument name="model" required="true">
		<cfargument name="requestObj" required="true">
		<cfargument name="pageref" required="true">
		<cfset var path = requestObj.getFormUrlVar('path')>
		<cfset variables.id = listlast(path,'/')>
		<cfset variables.view = listgetat(path, listlen(path,'/') -1,'/')>
		
		<cfset variables.eventqry = arguments.model.getEvent(variables.id)>
		<cfset variables.requestObj = arguments.requestObj>
		<cfset variables.model = arguments.model>
		<cfset variables.pageref = arguments.pageref>

		<cfreturn this>
	</cffunction>
	
	<cffunction name="showEvent" output="false">
		<cfargument name="showdescription" default="true">
		<cfargument name="showlocation" default="false">
		<cfset var html = "">
		<cfset var df1 = "mmmm d, yyyy">
		<cfset var df2 = "">
		<cfsavecontent variable="html">
			<style>
				form p label {width:200px;}
			</style>
			<div class="eventView">
			<cfoutput query="variables.eventqry">
				<h3>
				<cfif startdate EQ enddate>
					#dateformat(startdate,df1)#
				<cfelseif dateformat(startdate,"myyyy") EQ dateformat(enddate,"myyyy")>
					#dateformat(startdate,'mmmm')# #dateformat(startdate,'d')#-#dateformat(enddate,'d')#, #dateformat(startdate,'yyyy')#
				<cfelse>
					#dateformat(startdate,df1)# - #dateformat(enddate,df1)#
				</cfif>
				</h3>

				<cfif arguments.showLocation>
				<p>
					#replace(location,"#chr(10)#","<br>","all")#
				</p>
				</cfif>

				<cfif arguments.showDescription>
				<p>
					#description#
				</p>
				</cfif>
							
				<cfif filename NEQ "" AND listfindnocase('event,register,thanks', variables.view)>
				<p><a href="/docs/assets/#filename#" target="_blank">Download the Agenda (PDF)</a></p>
				</cfif>
				<cfif maplink NEQ "">
				<p><a href="#maplink#" target="_blank">Map</a></p>
				</cfif>
				<cfif variables.view EQ 'event'>
				<p><a href="/NewsAndEvents/Register/#id#">Register</a></p>
				</cfif>
			</cfoutput>
			</div>
		</cfsavecontent>
		<cfreturn html>
	</cffunction>
	
	<cffunction name="showEventForm" output="false">
		<cfset var vdtr = getUtility('datavalidator').init()>
		<cfset var form = "">
		<cfset var html = "">
	
		<cfif variables.requestObj.isformurlvarset('email')>
			<cfset model.registrationValidate(vdtr)>
			<cfif vdtr.passValidation()>
				<cfset model.registerUser(variables.id)>
				<cfset model.sendConfirmationMessage(variables.eventqry)>
				<cflocation url="/#variables.pageref.getField('onSuccess')##variables.id#/" addtoken="no">
			</cfif>
		</cfif>
	
		<cfset form = getUtility('formbuilder')>
		<cfset form.init(variables.requestObj,"eventForm",'Post',vdtr)>
		<cfset form.addFormItem('email', 'Email*', 'text')>
		<cfset form.addFormItem('fname', 'First Name*', 'text')>
		<cfset form.addFormItem('lname', 'Last Name*', 'text')>
		<cfset form.addFormItem('companyname', 'Company Name*', 'text')>
		<cfset form.addFormItem('title', 'Title', 'text')>
		<cfset form.addFormItem('add1', 'Street Address', 'text')>
		<cfset form.addFormItem('add2', '&nbsp;', 'text')>
		<cfset form.addFormItem('city', 'City', 'text')>
		<cfset options = structnew()>
		<cfset options.query = getUtility('worldinfo').init(variables.requestObj).getStates()>
		<cfset options.labelskey = 'abbrev'>
		<cfset options.valueskey = 'name'>
		<cfset options.blankitem = 'Choose'>
		<cfset form.addFormItem('state', 'State', 'select', "", options)>
		<cfset form.addFormItem('zip', 'Zip', 'text')>
		<cfset form.addFormItem('phone', 'Telephone*', 'text')>
		<cfif variables.eventqry.showaddtlattendees EQ 1>
			<cfset options = structnew()>
            <cfset options.list = '0,1,2,3,4,5,6,7,8,9'>
			<cfset form.addFormItem('addtlattendeescount', 'Additional Attendees (Number)', 'select', "", options)>
			<cfset form.addFormItem('addtlattendeesinfo', 'Additional Attendees first and last name(s) and email(s)', 'textarea')>
		</cfif>
		<cfset options = structnew()>
		<cfset options.query = querynew('value,label')>
		<cfset queryaddrow(options.query)>
		<cfset querysetcell(options.query, 'value', '1')>
		<cfset querysetcell(options.query, 'label', '')>
		<cfif variables.eventqry.showmaterialsform EQ 1>
			<cfset form.addFormItem('materials', 'Materials Only', 'checkbox', "", options)>
		</cfif>
		<cfset form.addFormItem('comment', 'Comment', 'textarea')>
		<cfset form.addSubmit('submit','', 'Submit')>
		<cfreturn showEvent(showlocation = 1) & '<div class="eventView">' & form.showHTML() & '</div>'>
	</cffunction>
	
	<cffunction name="showThanks" output="false">
		<cfreturn showEvent(showdescription = false, showlocation = true)>
	</cffunction>
	
	<cffunction name="showHTML">
		<cfif variables.view EQ "event">
			<cfreturn showEvent(showlocation = 1)>
		<cfelseif variables.view EQ 'register'>
			<cfreturn showEventForm()>
		<cfelse>
			<cfreturn showThanks()>
		</cfif>
	</cffunction>
	
	<cffunction name="dump">
		<cfdump var=#variables.variables.eventsqry#>
		<cfabort>
	</cffunction>
	
	
</cfcomponent>