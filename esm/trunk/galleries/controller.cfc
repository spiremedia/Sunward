<cfcomponent name="Galleries" extends="resources.abstractController">
	
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

		<cfreturn createObject('component','galleries.models.grouplogs').init(arguments.requestObject, arguments.userObj)>
	</cffunction>
	
	<cffunction name="getGroupModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','galleries.models.galleryGroups').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','galleries.models.grouplogs').init(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
    
    <cffunction name="getImageModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
        
		<!---<cfset var mdl = createObject('component','utilities.imageManipulation#iif(left(server.Coldfusion.ProductVersion,1) EQ 7, DE("7"),DE(""))#').init(arguments.requestObject, arguments.userObj)>--->
        <cfset var mdl = createObject('component','utilities.imageManipulation7').init(arguments.requestObject, arguments.userObj)>

		<!---<cfset mdl.attachObserver(createObject('component','galleries.models.grouplogs').init(arguments.requestObject, arguments.userObj))>--->
		<cfreturn mdl/>
	</cffunction>
	
	 <cffunction name="getImageParams">
		<cfset var modulexml = "">
		<cfset var xml = structnew()>
		<cfset var rq = querynew("name,maxwidth,maxheight,extensionmod")>
		<cfinclude template="modulexml.cfm">		
		<cfset xml.imageinfo = xmlsearch(modulexml,"//images/img")>
		
		<cfloop from="1" to="#arraylen(xml.imageinfo)#" index="xml.itr">
			<cfset xml.xmlitem = xml.imageinfo[xml.itr]>
			<cfset queryaddrow(rq)>
			<cfloop list="#rq.columnlist#" index="xml.itr2">
				<cfset querysetcell(rq, xml.itr2, xml.xmlitem.xmlattributes[xml.itr2])>
			</cfloop>
		</cfloop>

		<cfreturn rq/>
	</cffunction>
	
	<cffunction name="getModel">
		<cfargument name="requestObject">
		<cfargument name="userObj">
		<cfset var mdl = createObject('component','galleries.models.galleryimages').init(arguments.requestObject, arguments.userObj)>
		<cfset mdl.attachObserver(createObject('component','galleries.models.logs').init(arguments.requestObject, arguments.userObj))>
		<cfreturn mdl/>
	</cffunction>
	
	<cffunction name="getLogObj">
		<cfargument name="requestObject">
		<cfargument name="userObj">

		<cfreturn createObject('component','galleries.models.logs').init(arguments.requestObject, arguments.userObj)>
	</cffunction>
	
	<cffunction name="viewGalleryGroups">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getGroupLogObj(requestObject, userobj)>
		
		<cfset displayObject.setData('list', model.getGalleryGroups())>
		<cfset displayObject.setData('recentActivity', logs.getRecentHistory(userobj))>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="addGalleryGroup">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
		<cfset var logs = getGrouplogObj(argumentcollection = arguments)>
		<cfset var lcl = structnew()>
		<!---><cfset displayObject.setData('securityItems', dispatcher.getSecurityItems())>--->
		
		<cfset lcl.galleryGroups = model.getGalleryGroups()>
		
		<cfset displayObject.setData('list', lcl.galleryGroups)>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		<cfset displayObject.setData('userobj', userobj)>

		<cfif requestObject.isformurlvarset('id')>
			<cfset displayObject.setData('info', model.getGalleryGroup(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('itemhistory', logs.getItemHistory(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('id',requestObject.getformurlvar('id'))>
		<cfelse>
			<cfset displayObject.setData('info', model.getGalleryGroup(0))>
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
	
	<cffunction name="editGalleryGroup">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addGalleryGroup(displayObject,requestObject,userobj, dispatcher)>
	</cffunction>
	
	<cffunction name="SaveGalleryGroup">
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
			<cfif requestObject.getformurlvar('id') EQ "">
				<cfset lcl.msg.message = "Gallery Group Saved">
				<cfset lcl.msg.switchtoedit = lcl.id>
			<cfelse>
				<cfset lcl.msg.message = "Gallery Group Updated">
			</cfif>
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/Galleries/BrowseGroups/?id=#lcl.id#">
			<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
			<cfset lcl.msg.clearvalidation = 1>
			
			<cfset displayObject.sendJson( lcl.msg )>
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
			<cfset displayObject.sendJson( lcl.msg )>
		</cfif>
		
	</cffunction>
	
	<cffunction name="DeleteGalleryGroup">
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
			<cfset lcl.msg.ajaxupdater.url = "/Galleries/BrowseGroups/">
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

		<cfset displayObject.setData('list', model.getImages())>
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
		
		<cfset displayObject.setData('list', model.getImages())>
		<cfset displayObject.setData('searchResults', model.search(arguments.requestObject.getFormUrlVar('searchkeyword')))>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="AddGalleryImage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
	
		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var typesmodel = getGroupmodel(argumentcollection = arguments)>
		<cfset var logs = getlogObj(argumentcollection = arguments)>
		<cfset var temp = structnew()>	
				
		<cfset displayObject.setData('list', model.getImages())>
		<cfset displayObject.setData('requestObj', arguments.requestObject)>
		<cfset displayObject.setData('groupTypes', typesmodel.getGalleryGroups())>
		
		<cfif requestObject.isformurlvarset('id')>
			<cfset model.load(requestObject.getformurlvar('id'))>
			<cfset displayObject.setData('itemhistory', logs.getItemHistory(requestObject.getformurlvar('id')))>
			<cfset displayObject.setData('link', '/docs/Imagegalleries/#model.getField('filename')#')>
			<cfset displayObject.setData('info', model)>
			<cfset displayObject.setData('images', getImageParams())>
			<cfset displayObject.setData('id', requestObject.getformurlvar('id'))>
			<cfif model.getField('filename') NEQ "">
				<cfset displayObject.setWidgetOpen('mainContent','1,2')>
			</cfif>
		<cfelse>
			<cfset model.load(0)>
			<cfset displayObject.setData('info', model)>
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
	
	<cffunction name="editGalleryImage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		<cfreturn addGalleryImage(displayObject,requestObject,userObj,dispatcher)>
	</cffunction>
		
	<cffunction name="SaveGalleryImage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = getmodel(argumentcollection = arguments)>
				
		<cfset var requestvars = requestobject.getallformurlvars()>
		<cfparam name="requestvars.ImageGroupId" default="">
		<cfset model.setValues(requestVars)>
				
		<cfset vdtr = model.validate()>
		
		<cfif vdtr.passValidation()>
			<cfset lcl.id = model.save()>
			<cfset lcl.msg = structnew()>
			
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/Galleries/Browse/?id=#lcl.id#">
			<cfset lcl.msg.ajaxupdater.id = 'leftContent'> 
			<cfset lcl.msg.clearvalidation = 1>
			
			<cfif requestObject.isformurlvarset('id') AND requestObject.getformurlvar('id') NEQ 0 AND requestObject.getformurlvar('id') NEQ ''>
				<cfset lcl.msg.message = "The Gallery Image has been Updated">
			<cfelse>
				<cfset lcl.msg.message = "The Gallery Image has been Added">
				<cfset lcl.msg.switchtoedit = lcl.id>
			</cfif> 
		<cfelse>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.validation = vdtr.getErrors()>
		</cfif>
		
		<cfset displayObject.sendJson( lcl.msg )>
	</cffunction>
	
	<cffunction name="uploadGalleryImage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="uploadGalleryImageAction">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">
		
		<cfset var lcl = structnew()>
		
		<cfset var model = getmodel(argumentcollection = arguments)>
		<cfset var info = structnew()>
		<cfset info.filename = "imagefile">
		<cfset info.id = requestObject.getFormUrlVar("id")>
		<cfset imgparams = getImageParams()>
		<cfif len(trim(requestObject.GetFormUrlVar(info.filename))) EQ 0>
			<cflocation url="/galleries/uploadGalleryImage/?id=#info.id#&msg=#urlencodedformat("Please upload an image")#" addtoken="no">
		</cfif>

		<cfset lcl.msg = structnew()>
		
		<cfset model.load(info.id)>
		<cfset lcl.filename = model.uploadImageFileInfo(info, imgparams)>
		<cfset model.resizeImage(imgparams, getImageModel(arguments.requestObject, arguments.userobj))>
		
		<cflocation url="/Galleries/editGalleryImage/?id=#requestObject.getFormUrlVar("id")#&msg=#urlencodedformat("Image Uploaded")#" addtoken="no">

	</cffunction>
	
	<cffunction name="deleteGalleryImage">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var lcl = structnew()>
		<cfset var model = getmodel(argumentcollection = arguments)>
		
		<cfif NOT requestObject.isformurlvarset('id')>
			<cfthrow message="id not provided to delete image">
		</cfif>
		
		<cfset vdtr = model.validateDelete(requestObject.getformurlvar('id'))>
		
		<cfif vdtr.passvalidation()>
			<cfset model.deleteImage(requestObject.getformurlvar('id'))>
			<cfset lcl.msg = structnew()>
			<cfset lcl.msg.message = "The Gallery Image has been deleted">
			<cfset lcl.msg.ajaxupdater = structnew()>
			<cfset lcl.msg.ajaxupdater.url = "/Galleries/Browse/">
			<cfset lcl.msg.ajaxupdater.id = 'leftContent'>
			<cfset lcl.msg.htmlupdater = structnew()>
			<cfset lcl.msg.htmlupdater.id = "rightContent">
			<cfset lcl.msg.htmlupdater.HTML = "<div id='msg'>Gallery Image Deleted</div>">
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
		
		<cfset displayObject.setData('list', model.getImages())>
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
		
		<cfset displayObject.setData('list', model.getGalleryGroups())>
		<cfset displayObject.renderTemplate('html')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="groupSearch">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">

		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
		
		<cfset displayObject.setData('list', model.getGalleryGroups())>
		<cfset displayObject.setData('searchResults', model.search(arguments.requestObject.getFormUrlVar('searchkeyword')))>
		<cfset displayObject.setData('requestObject', arguments.requestObject)>
		
		<cfset displayObject.renderTemplate('browsecontent')>
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>
	
	<cffunction name="getAvailableImageGroups">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		
		<cfset var model = getGroupModel(arguments.requestObject, arguments.userObj)>
								
		<cfreturn model.getGalleryGroups()>
	</cffunction>
	
	<cffunction name="GetAvailableGalleries">
		<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		
		<cfset var model = getModel(requestObject, session.user)>
		
		<cfreturn model.getGalleryImages()>
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
        <cfset var imgparams = getImageParams()>
        <cfif requestObject.isFormUrlVarSet("imgaction")>
        	<cfset lcl.imgaction = requestObject.getFormUrlVar("imgaction")>
        <cfelse>
        	<cfset lcl.imgaction = "">
        </cfif>
        
        <cfset model.load(id)>
		<cfset lcl.filename = model.getField('filename')>
        <cfset lcl.imagepath = requestObject.getVar('machineroot') & "docs/imagegalleries/#id#/" & lcl.filename>
		
        <cfswitch expression="#lcl.imgaction#">
        	<cfcase value="crop">
            	<cfset checkImagebackup(lcl.imagepath, id)>
				<cfset getLogObj(requestObject,userObj).event("Crop", model)>
            	<cfset imgmodel.crop(	imgfile = lcl.imagepath,
										x = requestObject.getFormUrlVar('x'),
										y = requestObject.getFormUrlVar('y'),
										h = requestObject.getFormUrlVar('h'),
										w = requestObject.getFormUrlVar('w')
				)>
				<cfset model.resizeImage(imgparams, imgmodel)>
				
			</cfcase>
            <cfcase value="rotate">
            	<cfset checkImagebackup(lcl.imagepath, id)>
				<cfset getLogObj(requestObject,userObj).event("Rotate", model)>
            	<cfset imgmodel.rotate(	imgfile = lcl.imagepath,
										degrees = requestObject.getFormUrlVar('degrees')							
				)>
				<cfset model.resizeImage(imgparams, imgmodel)>
            </cfcase>
            
            <cfcase value="revert">
				<cfset getLogObj(requestObject,userObj).event("Revert", model)>

                <cffile action="copy" source="#rereplacenocase(lcl.imagepath, "\.(jpg|png)$", "_orig.\1")#" destination="#lcl.imagepath#" mode="644">
            	<cfset model.resizeImage(imgparams, imgmodel)>
			</cfcase>
        </cfswitch>
		        
		<cfset info = imgmodel.getInfo(lcl.imagepath)>
        <cfset info.imagepath = "/docs/imagegalleries/" & lcl.filename>
        
		<cfset displayObject.sendJson( info )>	
	</cffunction>
	
	<cffunction name="viewImage">
    	<cfargument name="requestObject" required="true">
		<cfargument name="userObj" required="true">
		<cfset var lcl = structnew()>
		<cfset var model = getModel(requestObject, session.user)>
		<cfset model.load(requestObject.getFormUrlVar("id"))>
		<cfset lcl.filename = model.getField('filename')>

		<cfheader name="content-disposition" value="inline; filename=#lcl.filename#"/>
		<cfcontent type="image/#ListLast( lcl.filename, '.' )#" file="#requestObject.getVar('machineroot') & 'docs/imagegalleries/#model.getField("id")#/' & lcl.filename#" /><cfabort>
	</cffunction>
    
    <cffunction name="checkImagebackup" access="private">
    	<cfargument name="imagepath" required="yes">
        <cfargument name="id" required="yes">
		<cfset var backupimagedirectory = "#listdeleteat(imagepath, listlen(imagepath, "/"), "/")#/bkimg_#id#">
        <cfset var backupimagepath = backupimagedirectory & "/" & listlast(imagepath, "/")>

        <cfif fileexists(backupimagepath)>
        	<cfreturn>
        </cfif>
        
		<cfif NOT directoryexists(backupimagedirectory)>
            <cfdirectory action="create" directory="#backupimagedirectory#" mode="644">
        </cfif>
        
        <cffile action="copy" source="#imagepath#" destination="#backupimagepath#" mode="644">
    </cffunction>
   
	<cffunction name="editClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset widgetsmodel = createObject('component','galleries.widgetModel').init(arguments.requestObject, arguments.userObj)>
		<cfset displayObject.setData('widgetsmodel', widgetsmodel)>
		<cfset displayObject.setData('gallerygroupmodel', getGroupModel(arguments.requestObject, arguments.userObj))>
		
		<cfset displayObject.renderTemplate('title')>
		<cfset displayObject.renderTemplate('mainContent')>
		
		<cfreturn displayObject>
	</cffunction>

	<cffunction name="saveClientModule">
		<cfargument name="displayObject" required="true">
		<cfargument name="requestObject" required="true">
		<cfargument name="userobj" required="true">
		<cfargument name="dispatcher" required="true">

		<cfset var model = createObject('component', 'galleries.widgetmodel').init(requestObject, userobj)>
		<cfset var lcl = structnew()>
		
		<cfset var requestvars = requestobject.getallformurlvars()>

		<cfset model.setValues(requestVars)>
		<!---<cfset model.setSecurityItemsFromXml(dispatcher.getSecurityItems())>--->
			
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
		
		<cfset var model = createObject('component', 'galleries.widgetmodel').init(requestObject, userobj)>
				
		<cfset model.deleteItem(requestObject.getFormUrlVar('id'))>
		
		<cfset lcl.reloadBase = 1>
		<cfset displayObject.sendJson( lcl )>
	</cffunction>
</cfcomponent>