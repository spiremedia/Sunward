<cfcomponent name="" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getMemberTypeLogObj">
		<cfargument name="requestObject">
		<cfargument name="userObj">

		<cfreturn createObject('component','sitemembers.models.memberTypeLogs').init(arguments.requestObject, arguments.userObj)>
	</cffunction>
	
	<cffunction name="getMemberTypeModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','sitemembers.models.memberTypes').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','sitemembers.models.memberTypeLogs').init(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
	
	<cffunction name="getModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','sitemembers.models.members').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','sitemembers.models.logs').init(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>	
	
	<cffunction name="getLogObj">
		<cfargument name="requestObject">
		<cfargument name="userObj">

		<cfreturn createObject('component','sitemembers.models.logs').init(arguments.requestObject, arguments.userObj)>
	</cffunction>
	
	<cffunction name="ViewMemberTypes">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var model = getMemberTypeModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getMemberTypeLogObj(requestObject, userobj)>
		
		<cfset displayObject.setData('list', model.getMemberTypes())>
		<cfset displayObject.setData('recentActivity', logs.getRecentHistory(userobj))>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="addMemberType">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var model = getMemberTypeModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getMemberTypeLogObj(requestObject, userobj)>
		
		<cfset displayObject.setData('list', model.getMemberTypes())>
		
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('info', model.getMemberType(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('itemhistory', logs.getItemHistory(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('id',requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('requestObject',requestObject)>
		<cfelse>
			<cfset displayObject.setData('info', model.getMemberType(0))>
			<cfset displayObject.setData('id', 0)>
		</cfif>
		
		<cfset displayObject.setWidgetOpen('mainContent','1')>
			
		<cfif requestObject.isformurlvarset('search')>
			<cfset displayObject.setData('search', model.search(requestObject.getformurlvar('search')))>
		</cfif>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('maincontent')>
		
		<cfreturn displayObject>
	</cffunction>    	
    
	<cffunction name="editMemberType">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addMemberType(displayObject,requestObject,userObj,dispatcher)>
	</cffunction>
	
	<cffunction name="SaveMemberType">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>		
		<cfset var model = getMemberTypeModel(arguments.requestObject, arguments.userObj)>				
		<cfset var requestvars = requestobject.getallformurlvars()>
		
		<cfset model.setValues(requestVars)>
			
		<cfset vdtr = model.validate()>
		
		<cfif vdtr.passValidation()>
			<cfset lcl.id = model.saveMemberType()> 
			<cfset lcl.msg = structnew()>
			<cfif requestObject.isformurlvarset('id') AND requestObject.getformurlvar('id') NEQ 0 AND requestObject.getformurlvar('id') NEQ ''>
				<cfset lcl.msg.message = "The Member Type has been Saved.">
				<cfset lcl.msg.ajaxupdater = structnew()>
				<cfset lcl.msg.ajaxupdater.url = "/SiteMembers/BrowseMemberTypes/?id=#lcl.id#">
				<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
				<cfset lcl.msg.clearvalidation = 1>
			<cfelse>
				<cfset lcl.msg.message = "The Member Type has been Added.">
				<cfset lcl.msg.relocate = "/SiteMembers/editMemberType/?id=#lcl.id#&msg=#lcl.msg.message#">
			</cfif>
			
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
	</cffunction>
   
	<cffunction name="DeleteMemberType">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getMemberTypeModel(arguments.requestObject, arguments.userObj)>		
		
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to delete member type">
		</cfif>
		
		<cfset vdtr = model.validateDelete(requestObject.getformurlvar('id'))>
		
		<cfif vdtr.passvalidation()>
			<cfset model.deleteMemberType(requestObject.getformurlvar('id'))> 
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Member Type has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/SiteMembers/BrowseMemberTypes/">
			<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>Member Type Deleted</div>">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>

	</cffunction>
	
	<cffunction name="StartPage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getlogObj(argumentcollection = arguments)>
		
		<cfset displayObject.setData('list', model.getMembers())>
		<cfset displayObject.setData('recentActivity', logs.getRecentHistory(userobj))>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="Search">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getmodel(argumentcollection = arguments)>
		
		<cfset displayObject.setData('list', model.getMembers())>
		<cfset displayObject.setData('searchResults', model.search(arguments.requestObject.getFormUrlVar('searchkeyword')))>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="AddMember">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var modelMemberType = getMemberTypeModel(arguments.requestObject, arguments.userObj)>		
		<cfset var logs = getlogObj(argumentcollection = arguments)>
		<cfset var temp = structnew()>	
				
		<cfset displayObject.setData('list', model.getMembers())>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>
		<cfset displayObject.setData('memberTypes', modelMemberType.getMemberTypes())>
		
		<cfif requestObject.isformurlvarset('id')>
			<cfset model.load(requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('itemhistory', logs.getItemHistory(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('info', model.getMember(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('requestObject',requestObject)>
		<cfelse>
			<cfset displayObject.setData('info', model.getMember(0))>
		</cfif>
			
		<cfif requestObject.isformurlvarset('search')>
			<cfset displayObject.setData('search', model.search(requestObject.getformurlvar('search')))>
		</cfif>

		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('maincontent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="EditMember">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn AddMember(displayObject,requestObject,userObj,dispatcher)>
	</cffunction>
		
	<cffunction name="SaveMember">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var requestvars = requestobject.getallformurlvars()>
		
		<cfparam name="requestvars.id" default="">
		
		<cfset model.setValues(requestVars)>
				
		<cfset vdtr = model.validate()>
		
		<cfif vdtr.passValidation()>
			<cfset lcl.id = model.save()> 
			<cfset lcl.msg = structnew()>
			
			<cfif requestObject.isformurlvarset('id') AND requestObject.getformurlvar('id') NEQ 0 AND requestObject.getformurlvar('id') NEQ ''>
				<cfset lcl.msg.message = "The Member has been Saved.">
				<cfset lcl.msg.ajaxupdater = structnew()>
				<cfset lcl.msg.ajaxupdater.url = "/SiteMembers/Browse/?id=#lcl.id#">
				<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
				<cfset lcl.msg.clearvalidation = 1>
			<cfelse>
				<cfset lcl.msg.message = "The Member has been Added.">
				<cfset lcl.msg.relocate = "/SiteMembers/EditMember/?id=#lcl.id#&msg=#lcl.msg.message#">
			</cfif>
			
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
	</cffunction>
	
	<cffunction name="DeleteMember">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getmodel(argumentcollection = arguments)>
		
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to delete site member">
		</cfif>
		
		<cfset vdtr = model.validateDelete(requestObject.getformurlvar('id'))>
		
		<cfif vdtr.passvalidation()>
			<cfset model.deleteMember(requestObject.getformurlvar('id'))>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Site Member has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "../Browse/">
			<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>Site Member Deleted</div>">
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>

	</cffunction>
	
	<cffunction name="Browse">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var model = getModel(arguments.requestObject, arguments.userObj)>
						
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>	
		</cfif>
		
		<cfset displayObject.setData('list', model.getMembers())>
		<cfset displayObject.renderTemplate('html')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="BrowseMemberTypes">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var model = getMemberTypeModel(arguments.requestObject, arguments.userObj)>
						
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>	
		</cfif>
		
		<cfset displayObject.setData('list', model.getMemberTypes())>
		<cfset displayObject.renderTemplate('html')>
		
		<cfreturn displayObject>
	</cffunction>
    
	<cffunction name="SearchMemberTypes">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getMemberTypeModel(arguments.requestObject, arguments.userObj)>
		
		<cfset displayObject.setData('list', model.getMemberTypes())>
		<cfset displayObject.setData('searchResults', model.search(arguments.requestObject.getFormUrlVar('searchkeyword')))>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
       
    <cffunction name="getAvailableMemberTypes">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
	
		<cfset var mktg = getMemberTypeModel(arguments.requestObject, arguments.userObj).getMemberTypes()>
        
		<cfreturn mktg>
	</cffunction>

</cfcomponent>