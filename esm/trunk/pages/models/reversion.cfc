<cfcomponent name="revision" extends="resources.abstractModel">
	<cffunction name="init">
		<cfargument name="requestObject">
		<cfargument name="userObject">
		<cfset variables.requestObject = arguments.requestObject>
		<cfset variables.userObject = arguments.userObject>
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="getPublishInstances">
		<cfset var r = "">
		
		<cfquery name="r" datasource="#variables.requestObject.getvar('dsn')#">
			SELECT 
				DISTINCT
				u.fname, u.lname,
				p.urlpath, 
				ppa.publisheddatetime, ppa.pageid, ppa.id
			FROM publishedPagesArchive ppa
			INNER JOIN sitepages p ON p.id = ppa.pageid
			INNER JOIN users u ON ppa.userid = u.id
			WHERE 
				ppa.siteid = <cfqueryparam value="#userobject.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
			ORDER BY ppa.publisheddatetime DESC
		</cfquery>
		
		<cfreturn r/>
	</cffunction>
	
	<cffunction name="getRevertableItemsByArchiveId">
		<cfargument name="archiveid" required="true">
		<cfset var r = "">
		
		<cfquery name="r" datasource="#variables.requestObject.getvar('dsn')#">
			SELECT 
				name,[module], membertype, id
			FROM publishedPageObjectsArchive ppoa
			WHERE 
				ppoa.siteid = <cfqueryparam value="#userobject.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
				AND ppoa.publishedPageArchiveId = <cfqueryparam value="#arguments.archiveid#" cfsqltype="cf_sql_varchar">
			ORDER BY membertype, name
		</cfquery>
		
		<cfreturn r/>
	</cffunction>
	
	<cffunction name="getRevertibleItem">
		<cfargument name="itemId" required="true">
		<cfset var r = "">
		
		<cfquery name="r" datasource="#variables.requestObject.getvar('dsn')#">
			SELECT 
				ppoa.name, ppoa.[module], ppoa.membertype, ppoa.id, ppoa.data,
				ppa.publisheddatetime, 
				sp.urlpath
			FROM publishedPageObjectsArchive ppoa
			INNER JOIN publishedPagesArchive ppa ON ppa.id = ppoa.publishedPageArchiveId
			INNER JOIN sitepages sp ON ppa.pageid = sp.id
			WHERE 
				ppoa.siteid = <cfqueryparam value="#userobject.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
				AND ppoa.id = <cfqueryparam value="#arguments.itemId#" cfsqltype="cf_sql_varchar">	
		</cfquery>
		
		<cfreturn r/>
	</cffunction>
	
	<cffunction name="revertItem">
		<cfset var lcl = structnew()>
		<cfset var input = structnew()>
		<cfset var temp = structnew()>
		
		<!--- get revertible info --->
		<cfset input.publishedPageArchiveId = variables.requestObject.getFormUrlVar('publishedPageArchiveId')>
		<cfset input.revertibleId = variables.requestObject.getFormUrlVar('revertibleId')>
		<cfset input.targetPageId = variables.requestObject.getFormUrlVar('targetPageId')>
		<cfset input.targetContentObjectName = variables.requestObject.getFormUrlVar('targetContentObjectName')>
		<cfset input.targetMemberType = variables.requestObject.getFormUrlVar('targetMemberType')>
		
		<cfset lcl.revertibleItem = getRevertibleItem(variables.requestObject.getFormUrlVar('revertibleId'))>revision

		<cfif left(lcl.revertibleItem.data, 1) NEQ '{'>
			<cfset temp.content = lcl.revertibleItem.data>
			<cfset lcl.revertibleItem.data[1] = createObject('component', 'utilities.json').encode(temp)>
		</cfif>
		
		<!--- remove current module --->
		<cfquery name="lcl.revertpo" datasource="#variables.requestObject.getvar('dsn')#">
			UPDATE [pageObjects] SET
				deleted = 1
			WHERE
				siteid = <cfqueryparam value="#userobject.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
				AND pageid = <cfqueryparam value="#input.targetPageId#" cfsqltype="cf_sql_varchar">
				AND name = <cfqueryparam value="#input.targetContentObjectName#" cfsqltype="cf_sql_varchar">
				AND status = 'staged'
				AND membertype = <cfqueryparam value="#input.targetMemberType#" cfsqltype="cf_sql_varchar">
		</cfquery>
		
		<!--- insert new module --->
		<cfquery name="lcl.revertpo" datasource="#variables.requestObject.getvar('dsn')#">
			INSERT INTO [pageObjects](
					[id]
		           ,[name]
		           ,[module]
		           ,[data]
		           ,[pageid]
		           ,[siteid]
		           ,[status]
		           ,[deleted]
		           ,[memberType])
		     VALUES
		           (<cfqueryparam value="#createuuid()#" cfsqltype="cf_sql_varchar">
		           ,<cfqueryparam value="#input.targetContentObjectName#" cfsqltype="cf_sql_varchar">
		           ,<cfqueryparam value="#lcl.revertibleItem.module#" cfsqltype="cf_sql_varchar">
		           ,<cfqueryparam value="#lcl.revertibleItem.data#" cfsqltype="cf_sql_varchar">
		           ,<cfqueryparam value="#input.targetPageId#" cfsqltype="cf_sql_varchar">
		           ,<cfqueryparam value="#userobject.getCurrentSiteId()#" cfsqltype="cf_sql_varchar">
		           ,'staged'
		           ,0
		           ,<cfqueryparam value="#input.targetMemberType#" cfsqltype="cf_sql_varchar">
		    )
		</cfquery>
		
		<cfset variables.observeEvent('Item Reverted', input)>
		
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="getRevertableTargets">
		<cfargument name="memberTypes" required="true">
		<cfargument name="viewList" required="true">
		<cfargument name="module" required="true">
		<cfargument name="loadedPageObjects" required="true">
		
		<cfset var alist = arraynew(1)>
		<cfset var s = "">
		<cfset var pos = structnew()>
		
		<cfloop query="loadedPageObjects">
			<cfif not structkeyexists(pos, loadedPageObjects.name)>
				<cfset pos[name] = structnew()>
			</cfif>
			<cfset pos[name][membertype] = 1>
		</cfloop>
	
		<cfloop query="viewlist">
			<cfif structkeyexists(viewlist.parameterlist[currentrow],'editable') 
					AND parameterlist[currentrow]['editable']
					AND listfindnocase(viewlist.modulename, module)>
				<cfset s = structnew()>
				<cfset s.name = viewlist.name>
				<cfset s.membertype = "default">
				<cfset arrayappend(alist, s)>
				<cfif structkeyexists(pos, viewlist.name) AND structkeyexists(pos[viewlist.name],'default')>
					<cfloop query="memberTypes">
						<cfset s = structnew()>
						<cfset s.name = viewlist.name>
						<cfset s.membertype = memberTypes.name>
						<cfset arrayappend(alist, s)>
					</cfloop>
				</cfif>
			</cfif>
		</cfloop>

		<cfreturn alist>
	</cffunction>
</cfcomponent>