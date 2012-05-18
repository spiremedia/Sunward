<cfcomponent name="Assets" extends="resources.abstractController">
	
	<cffunction name="init">
		<cfargument name="request" required="true">
		<cfargument name="userobj" required="true">
		<cfset variables.request = arguments.request>
		<cfset variables.userobj = arguments.userobj>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getGroupLogObj">
		<cfargument name="requestObject">
		<cfargument name="userObj">

		<cfreturn createObject('component','assets.models.grouplogs').init(arguments.requestObject, arguments.userObj)>
	</cffunction>
	
	<cffunction name="getGroupModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','assets.models.assetGroups').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','assets.models.grouplogs').init(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
    
    <cffunction name="getImageModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
        <!---<cfset var mdl = createObject('component','utilities.imageManipulation#iif(left(server.Coldfusion.ProductVersion,1) EQ 7, DE("7"),DE(""))#').init(arguments.requestObject, arguments.userObj)>--->
		<cfset var mdl = createObject('component','utilities.imageManipulation7').init(arguments.requestObject, arguments.userObj)>
		<!---<cfset mdl.attachObserver(createObject('component','assets.models.grouplogs').init(arguments.requestObject, arguments.userObj))>--->
		<cfreturn mdl/>
	</cffunction>
	
	<cffunction name="getModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','assets.models.assets').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','assets.models.logs').init(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
	
	<cffunction name="getLogObj">
		<cfargument name="requestObject">
		<cfargument name="userObj">

		<cfreturn createObject('component','assets.models.logs').init(arguments.requestObject, arguments.userObj)>
	</cffunction>
	
	<cffunction name="viewAssetGroups">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getGroupLogObj(requestObject, userobj)>
		
		<cfset displayObject.setData('list', model.getAssetGroups())>
		<cfset displayObject.setData('recentActivity', logs.getRecentHistory(userobj))>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="addAssetGroup">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getGrouplogObj(argumentcollection = arguments)>
		<cfset var lcl = structnew()>
		<!---><cfset displayObject.setData('securityItems', dispatcher.getSecurityItems())>--->
		
		<cfset lcl.assetGroups = model.getAssetGroups()>
		
		
		
		<cfset displayObject.setData('list', lcl.assetGroups)>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		<cfset displayObject.setData('userobj', userobj)>

		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('info', model.getAssetGroup(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('itemhistory', logs.getItemHistory(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('id',requestObject.getformurlvar('id'))>
		<cfelse>
			<cfset displayObject.setData('info', model.getAssetGroup(0))>
			<cfset displayObject.setData('id', 0)>
		</cfif>
	
		<cfset displayObject.setWidgetOpen('mainContent','1')>
			
		<cfif requestObject.isformurlvarset('search')>
			<cfset displayObject.setData('search', 
				model.search(
					requestObject.getformurlvar('search')))>
		</cfif>

		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('maincontent')>
		
		<cfreturn displayObject>
		
	</cffunction>
	
	<cffunction name="editAssetGroup">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addAssetGroup(displayObject,requestObject,userobj, dispatcher)>
	</cffunction>
	
	<cffunction name="SaveAssetGroup">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
				
		<cfset var requestvars = requestobject.getallformurlvars()>

		<cfset model.setValues(requestVars)>
			
		<cfset vdtr = model.validate()>
		
		<cfif vdtr.passvalidation()>
			<cfset lcl.id = model.save()>
			<cfset lcl.msg = structnew()>
			<cfif requestObject.getformurlvar('id') EQ 0>
				<cfset lcl.msg.message = "Asset Group Saved">
				<cfset lcl.msg.switchtoedit = lcl.id>
			<cfelse>
				<cfset lcl.msg.message = "Asset Group Updated">
			</cfif>
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/Assets/BrowseGroups/?id=#lcl.id#">
			<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
			<cfset lcl.msg.clearvalidation = 1>
			
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
	</cffunction>
	
	<cffunction name="DeleteAssetGroup">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
		
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to deletecontentgroup">
		</cfif>
		
		<cfset vdtr = model.validateDelete(requestObject.getformurlvar('id'))>
		
		<cfif vdtr.passvalidation()>
			<cfset model.deletegroup(requestObject.getformurlvar('id'))> 
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Group has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/Assets/BrowseGroups/">
			<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>Group Deleted</div>">
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

		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var log = getLogObj(requestObject, userObj)>

		<cfset displayObject.setData('list', model.getAssets())>
		<cfset displayObject.setData('recentActivity', log.getRecent())>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('mainContent')>
		<cfset displayObject.renderTemplate('title')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="Search">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getmodel(argumentcollection = arguments)>
		
		<cfset displayObject.setData('list', model.getAssets())>
		<cfset displayObject.setData('searchResults', model.search(arguments.requestObject.getFormUrlVar('searchkeyword')))>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="AddAsset">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var logs = getlogObj(argumentcollection = arguments)>
		<cfset var temp = structnew()>	
				
		<cfset displayObject.setData('list', model.getAssets())>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>
		<cfset displayObject.setData('groupTypes', model.getGroupTypes())>
		
		<cfif requestObject.isformurlvarset('id')>
			<cfset model.load(requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('itemhistory', logs.getItemHistory(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('link', '/docs/assets/#model.getField('id')#/#model.getField('filename')#')>
			<cfset displayObject.setData('info', model)>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>
		<cfelse>
			<cfset displayObject.setData('info', model.Load(0))>
		</cfif>
		
		<cfif requestObject.isformurlvarset('sortdir')>
			<cfset displayObject.setWidgetOpen('mainContent','1,3')>
		</cfif>
			
		<cfif requestObject.isformurlvarset('search')>
			<cfset displayObject.setData('search', 
				model.search(
					requestObject.getformurlvar('search')))>
		</cfif>

		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('maincontent')>
		
		<cfreturn displayObject>
		
	</cffunction>
	
	<cffunction name="editasset">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addasset(displayObject,requestObject,userObj,dispatcher)>
	</cffunction>
		
	<cffunction name="SaveAsset">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = getmodel(argumentcollection = arguments)>
				
		<cfset var requestvars = requestobject.getallformurlvars()>
		<cfparam name="requestvars.assetGroupId" default="">
		<cfset model.setValues(requestVars)>
				
		<cfset vdtr = model.validate()>
		
		<!-- file upload requests can't go thru ajax. resubmit -->
		<cfif requestObject.getFormUrlVar('filename') EQ "" AND vdtr.passValidation()>
			<cfset lcl.id = model.save()>
			<cfset lcl.msg = structnew()>
			
			<cfif requestObject.isformurlvarset('id') AND requestObject.getformurlvar('id') NEQ 0 AND requestObject.getformurlvar('id') NEQ ''>
				<cfset lcl.msg.message = "The Asset has been Updated">
				<cfset lcl.msg.ajaxupdater = structnew()>
				<cfset lcl.msg.ajaxupdater.url = "/Assets/Browse/?id=#lcl.id#">
				<cfset lcl.msg.ajaxupdater.id = 'leftContent'> 
				<cfset lcl.msg.clearvalidation = 1>
			<cfelse>
				<cfset lcl.msg.message = "The Asset has been Added">
				<cfset lcl.msg.relocate = "/Assets/EditAsset/?id=#lcl.id#&msg=#lcl.msg.message#">
			</cfif>
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelseif requestObject.isformurlvarset('really') AND vdtr.passValidation()>
			<cfset lcl.id = model.save()>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Asset has been Updated">
			<cfset lcl.msg.relocate = "/Assets/EditAsset/?id=#lcl.id#&msg=#lcl.msg.message#">
			<cflocation url="../editAsset/?id=#lcl.id#&msg=#lcl.msg.message#" addtoken="false"> 
		<cfelseif vdtr.passvalidation()>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.switchandsubmit = 1>
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
	</cffunction>
	
	<cffunction name="DeleteAsset">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getmodel(argumentcollection = arguments)>
		
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to delete asset">
		</cfif>
		
		<cfset vdtr = model.validateDelete(requestObject.getformurlvar('id'))>
		
		<cfif vdtr.passvalidation()>
			<cfset model.deleteAsset(requestObject.getformurlvar('id'))>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Asset has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/Assets/Browse/">
			<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>Asset Deleted</div>">
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
		
		<cfset var model = getmodel(argumentcollection = arguments)>
						
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>	
		</cfif>
		
		<cfset displayObject.setData('list', model.getAssets())>
		<cfset displayObject.renderTemplate('html')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="BrowseGroups">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
						
		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>	
		</cfif>
		
		<cfset displayObject.setData('list', model.getAssetGroups())>
		<cfset displayObject.renderTemplate('html')>
		
		<cfreturn displayObject>
	</cffunction>
	
    
    
	<cffunction name="groupSearch">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
		
		<cfset displayObject.setData('list', model.getAssetGroups())>
		<cfset displayObject.setData('searchResults', model.search(arguments.requestObject.getFormUrlVar('searchkeyword')))>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="getAvailableAssetGroups">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
								
		<cfreturn model.getAssetGroups()>
	</cffunction>
	
	<cffunction name="editClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset widgetsmodel = createObject('component','assets.widgetModel').init(arguments.requestObject, arguments.userObj)>
		<cfset assetsModel = getModel(arguments.requestObject, arguments.userObj)>
		<cfset displayObject.setData('widgetsmodel', widgetsmodel)>
		<cfset displayObject.setData('assetsmodel', assetsmodel)>
		
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="GetAvailableAssets">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset var model = getModel(requestObject, session.user)>
		
		<cfreturn model.getAssets()>
	</cffunction>
	
	<cffunction name="viewImage">
    	<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		<cfset var lcl = structnew()>
		<cfset var model = getModel(requestObject, session.user)>
		<cfset model.load(requestObject.getFormUrlVar("id"))>
		<cfset lcl.filename = model.getField('filename')>

		<cfheader name="content-disposition" value="inline; filename=#lcl.filename#"/>
		<cfcontent type="image/#ListLast( lcl.filename, '.' )#" file="#requestObject.getVar('machineroot') & 'docs/assets/#id#/' & lcl.filename#" /><cfabort>
	</cffunction>
    
    <cffunction name="eaImg">
    	<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
        
		<cfset var lcl = structnew()>
		<cfset var model = getModel(requestObject, session.user)>
        <cfset var imgmodel = getImageModel(requestObject, session.user)>
        <cfset var info = structnew()>
        <cfset var id = requestObject.getFormUrlVar("id")> 
        
        <cfif requestObject.isFormUrlVarSet("imgaction")>
        	<cfset lcl.imgaction = requestObject.getFormUrlVar("imgaction")>
        <cfelse>
        	<cfset lcl.imgaction = "">
        </cfif>
        
        <cfset model.load(id)>
		<cfset lcl.filename = model.getField('filename')>
        <cfset lcl.imagepath = requestObject.getVar('machineroot') & "docs/assets/#id#/" & lcl.filename>
		
        <cfswitch expression="#lcl.imgaction#">
        	<cfcase value="crop">
            	<cfset checkImagebackup(lcl.imagepath, id)>
            	<cfset imgmodel.crop(	imgfile = lcl.imagepath,
										x = requestObject.getFormUrlVar('x'),
										y = requestObject.getFormUrlVar('y'),
										h = requestObject.getFormUrlVar('h'),
										w = requestObject.getFormUrlVar('w')
				)>
			</cfcase>
            <cfcase value="rotate">
            	<cfset checkImagebackup(lcl.imagepath, id)>
            	<cfset imgmodel.rotate(	imgfile = lcl.imagepath,
										degrees = requestObject.getFormUrlVar('degrees')							
				)>
            </cfcase>
            <cfcase value="resize">
            	<cfset checkImagebackup(lcl.imagepath, id)>
            	<cfset imgmodel.resize(	imgfile = lcl.imagepath,
										w = requestObject.getFormUrlVar('w'),
										h = requestObject.getFormUrlVar('h')							
				)>
            </cfcase>
            <cfcase value="revert">
            	<cfset lcl.backupimagedirectory = "#listdeleteat(lcl.imagepath, listlen(lcl.imagepath, "/"), "/")#/bkimg">
				<cfset lcl.backupimagepath = lcl.backupimagedirectory & "/" & listlast(lcl.imagepath, "/")>

                <cfif NOT fileexists(lcl.backupimagepath)>
                    <cfset displayObject.sendJson(info)>
                </cfif>
                
                <cffile action="copy" destination="#lcl.imagepath#" source="#lcl.backupimagepath#" mode="644">
            </cfcase>
        </cfswitch>
		        
		<cfset info = imgmodel.getInfo(lcl.imagepath)>
        <cfset info.imagepath = "/docs/assets/#id#/" & lcl.filename>
        
		<cfset displayObject.sendJson( info )>	
	</cffunction>
    
    <cffunction name="checkImagebackup" access="private">
    	<cfargument name="imagepath" required="yes">
        <cfargument name="id" required="yes">
		<cfset var backupimagedirectory = "#listdeleteat(imagepath, listlen(imagepath, "/"), "/")#/bkimg">
        <cfset var backupimagepath = backupimagedirectory & "/" & listlast(imagepath, "/")>

        <cfif fileexists(backupimagepath)>
        	<cfreturn>
        </cfif>
        
		<cfif NOT directoryexists(backupimagedirectory)>
            <cfdirectory action="create" directory="#backupimagedirectory#" mode="644">
        </cfif>
        
        <cffile action="copy" source="#imagepath#" destination="#backupimagepath#" mode="644">
    </cffunction>
    <!---
    <cffunction name="eaImgCrop">
    	<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
        
		<cfset var lcl = structnew()>
		<cfset var model = getModel(requestObject, session.user)>
        <cfset var imgmodel = getImageModel(requestObject, session.user)>
        <cfset var info = "">
		
		<cfset model.load(requestObject.getFormUrlVar("id"))>
		<cfset lcl.filename = model.getField('filename')>
     
		
       
        <cfset info = imgmodel.getInfo(requestObject.getVar('machineroot') & "docs/assets/" & lcl.filename)>
        <cfset info.imagepath = "/docs/assets/" & lcl.filename>
        
		<cfset displayObject.sendJson( info )>	
	</cffunction>
    
    <cffunction name="eaImgRotate">
    	<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
        
		<cfset var lcl = structnew()>
		<cfset var model = getModel(requestObject, session.user)>
        <cfset var imgmodel = getImageModel(requestObject, session.user)>
        <cfset var info = "">
		
		<cfset model.load(requestObject.getFormUrlVar("id"))>
		<cfset lcl.filename = model.getField('filename')>
     
		
       
        <cfset info = imgmodel.getInfo(requestObject.getVar('machineroot') & "docs/assets/" & lcl.filename)>
        <cfset info.imagepath = "/docs/assets/" & lcl.filename>
        
		<cfset displayObject.sendJson( info )>	
	</cffunction>
 
    <cffunction name="eaImgresize">
    	<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
        
		<cfset var lcl = structnew()>
		<cfset var model = getModel(requestObject, session.user)>
        <cfset var imgmodel = getImageModel(requestObject, session.user)>
        <cfset var info = "">
		
		<cfset model.load(requestObject.getFormUrlVar("id"))>
		<cfset lcl.filename = model.getField('filename')>
     
		
       
        <cfset info = imgmodel.getInfo(requestObject.getVar('machineroot') & "docs/assets/" & lcl.filename)>
        <cfset info.imagepath = "/docs/assets/" & lcl.filename>
        
		<cfset displayObject.sendJson( info )>	
	</cffunction>
	   --->
	<cffunction name="saveClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var model = createObject('component', 'assets.widgetmodel').init(requestObject, userobj)>
		<cfset var lcl = structnew()>
		
		<cfset var requestvars = requestobject.getallformurlvars()>

		<cfset model.setValues(requestVars)>
		<!---><cfset model.setSecurityItemsFromXml(dispatcher.getSecurityItems())>--->
			
		<cfset vdtr = model.validate()>
		
		<cfif vdtr.passvalidation()>
			<cfset model.save()>
			<cfset lcl.reloadBase = 1>
			<cfset displayObject.sendJson( lcl )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
	</cffunction>
	
	<cffunction name="deleteClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = createObject('component', 'assets.widgetmodel').init(requestObject, userobj)>
				
		<cfset model.deleteItem(requestObject.getFormUrlVar('id'))>
		
		<cfset lcl.reloadBase = 1>
		<cfset displayObject.sendJson( lcl )>
	</cffunction>
    
    <cffunction name="tinymceUpload">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
		
		<cfset lcl.assetGroups = model.getAssetGroups()>
				
		<cfset displayObject.setData('grouptypes', lcl.assetGroups)>
	
		<cfset displayObject.renderTemplate('html')>
        
        <cfreturn displayObject>
	</cffunction>
        
    <cffunction name="tinymceUploadAction">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var requestvars = requestobject.getallformurlvars()>
		
		<cfparam name="requestvars.description" default="">
		<cfparam name="requestvars.startdate" default="">
		<cfparam name="requestvars.enddate" default="">
		<cfset requestvars.active = 1>
		<cfset model.setValues(requestVars)>

		<cfset vdtr = model.validate()>
		
		<!-- file upload requests can't go thru ajax. resubmit -->
		<cfif vdtr.passValidation()>
			<cfset lcl.id = model.save()>
			<cfset displayObject.showHTML("<script>parent.FileBrowserDialogue.imageChosen('#lcl.id#')</script>")>
		<cfelse>
			<cfset displayObject.showHTML("<script>parent.showErrors('#rereplace(vdtr.getFormattedErrors(),"[\r\t\n ]+"," ","all")#')</script>")>
		</cfif>
		  
    </cffunction> 
</cfcomponent>