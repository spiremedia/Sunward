<cfcomponent name="menusystem" output="false">
	<cffunction name="init" output="false">
		<cfargument name="modules" required="true">
		<cfset variables.modules = arguments.modules>
		<cfset parsemodules()>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="parsemodules" output="false">
		<cfset var mk = "">
		<cfset var i = "">
		<cfset var menuitem = "">
		<cfset var submenuitem = "">
		<cfset var submenuitemsarray = "">
		<cfset var order = structnew()>
		<cfset var ordered = "">
		<cfset var count = 0><!--- counter for items that must be in menu (where menuorder < 0> --->
		<cfset var tmp = structnew()>
		<!--- get order for topmenu --->
		
		<cfloop collection="#variables.modules#" item="mk">
			<cfif variables.modules[mk].menuorder NEQ 0>
				<cfset count = count + 1>
				<cfset order[variables.modules[mk].menuorder] = mk>
			</cfif>
		</cfloop>
		
		<cfset ordered = listtoarray(structkeylist(order))>
		
		<cfif arraylen(ordered) NEQ count>
			<cfset tmp.list = "">
			<cfloop collection="#variables.modules#" item="mk">
				<cfif variables.modules[mk].menuorder NEQ 0>
					<cfset tmp.list = listappend(tmp.list,"#variables.modules[mk].foldername#:#variables.modules[mk].menuorder#")>
				</cfif>
			</cfloop>
			<cfthrow message="Menu item not correct. Most likely, you have two modules with the same sort number. #tmp.list#.">
		</cfif>
		
		<cfset arraysort(ordered, 'numeric')>

		<!--- make main menu and submenus --->
		<cfset variables.mainmenu = arraynew(1)>
        <cfset variables.mainmenu1 = arraynew(1)>
		<cfloop from="1" to="#arraylen(ordered)#" index="i">
			<cfif variables.modules[ order[ ordered[i] ] ].menuOrder>
				<cfset menuitem = structnew()>
				<cfset menuitem.name = variables.modules[ order[ ordered[i] ] ].name>
				<cfset menuitem.label = variables.modules[ order[ ordered[i] ] ].label>
				<cfset menuitem.securityitems = variables.modules[ order[ ordered[i] ] ].securityitems>
				<cfset menuitem.submenu = arraynew(1)>
				<cfset submenuitemsarray = variables.modules[ order[ ordered[i] ] ].actionsarray>
				<cfloop from="1" to="#arraylen(submenuitemsarray)#" index="j">
					<cfif submenuitemsarray[j].onmenu>
						<cfset submenuitem = structnew()>
						<cfset submenuitem.name = submenuitemsarray[j].name>
						<cfset submenuitem.method = submenuitemsarray[j].method>
						<cfset arrayappend(menuitem.submenu, submenuitem)>
					</cfif>
				</cfloop>
                
                <cfif variables.modules[ order[ ordered[i] ] ].topmenunav>
                	<cfset arrayappend(variables.mainmenu, menuitem)>
                <cfelse>
                	<cfset arrayappend(variables.mainmenu1, menuitem)>
                </cfif>				
			</cfif>
			
		</cfloop>

	</cffunction>
	
	<cffunction name="getmainmenu" output="false">
		<cfargument name="securityObj">
        <cfargument name="level">
		
		<cfset var i = 0>
		<cfset var q = querynew('label,module,method')>
		<cfset var menu = "">

        <cfif level EQ 'top'>
        	<cfset menu = variables.mainmenu>
        <cfelse>
        	<cfset menu = variables.mainmenu1>
        </cfif>

		<cfloop from="1" to="#arraylen(menu)#" index="i">
			<cfif securityObj.isallowed(menu[i].name, 'view')>
				<cfset queryaddrow(q)>
				<cfset querysetcell(q,'label',menu[i].label)>
				<cfset querysetcell(q,'module',menu[i].name)>
				<cfset querysetcell(q,'method','StartPage')>
			</cfif>
		</cfloop>

		<cfreturn q>
	</cffunction>
	
	<cffunction name="getallmainmenuitems" output="false">
		<cfargument name="securityObj">
		
		<cfset var i = 0>
		<cfset var q = querynew('label,module,method')>
		
		<cfloop from="1" to="#arraylen(variables.mainmenu)#" index="i">
			<cfset queryaddrow(q)>
			<cfset querysetcell(q,'label',variables.mainmenu[i].label)>
			<cfset querysetcell(q,'module',variables.mainmenu[i].name)>
			<cfset querysetcell(q,'method','StartPage')>
		</cfloop>

		<cfloop from="1" to="#arraylen(variables.mainmenu1)#" index="i">
			<cfset queryaddrow(q)>
			<cfset querysetcell(q,'label',variables.mainmenu1[i].label)>
			<cfset querysetcell(q,'module',variables.mainmenu1[i].name)>
			<cfset querysetcell(q,'method','StartPage')>
		</cfloop>
        
		<cfreturn q>
	</cffunction>
	
	<cffunction name="getmainmenuhtml" output="false">
		<cfargument name="securityObj" required="true">
		<cfargument name="requestObj" required="true">
        <cfargument name="level" default="top">
		<cfset var q = getmainmenu(arguments.securityObj, arguments.level)>
		<cfset var r = arraynew(1)>
		<cfset var currentmodule = arguments.requestObj.getModuleFromPath()>
		<cfset var selected = false>
		<cfset arrayappend(r,"<ul>")>

		<cfloop query="q">
			<cfset selected = ''>
			<cfif q.module EQ currentmodule>
				<cfset selected = 'id="selected"'>
			</cfif>
			<cfset arrayappend(r,"<li #selected#><a href=""/#module#/#method#/"">#label#</a></li>")>
		</cfloop>
		<cfset arrayappend(r,"</ul>")>
		<cfreturn arraytolist(r,"#chr(13)##chr(10)#")>
	</cffunction>
	
	<cffunction name="getsubmenu" output="false">
		<cfargument name="securityObj" required="true">
		<cfargument name="requestObj" required="true">
		
		<cfset var i = 0>
		<cfset var q = querynew('label,module,method')>
		<cfset var currentmodule = arguments.requestObj.getModuleFromPath()>
		<cfset var submenuitems = "">
		<cfset var count = "">
		<cfset var mnitem = "">
		
		<cfset submenuitems = arraynew(1)>
		
		<cfloop from="1" to="#arraylen(variables.mainmenu)#" index="mnitem">
			<cfif variables.mainmenu[mnitem].name EQ currentmodule>
				<cfset submenuitems = variables.mainmenu[mnitem].submenu>
			</cfif>
		</cfloop>
		
		<cfloop from="1" to="#arraylen(variables.mainmenu1)#" index="mnitem">
			<cfif variables.mainmenu1[mnitem].name EQ currentmodule>
				<cfset submenuitems = variables.mainmenu1[mnitem].submenu>
			</cfif>
		</cfloop>
		
		<cfloop from="1" to="#arraylen(submenuitems)#" index="i">
			<cfif securityObj.isallowed(currentmodule, submenuitems[i].name)>
				<cfset queryaddrow(q)>
				<cfset querysetcell(q,'label',submenuitems[i].name)>
				<cfset querysetcell(q,'module',currentmodule)>
				<cfset querysetcell(q,'method',submenuitems[i].method)>
			</cfif>
		</cfloop>
	
		<cfreturn q>
	</cffunction>
	
	<cffunction name="getsubmenuhtml" output="false">
		<cfargument name="securityObj" required="true">
		<cfargument name="requestObj" required="true">
	
		<cfset var q = getsubmenu(arguments.securityObj, requestObj)>
		<cfset var r = arraynew(1)>
		<cfset var currentaction = arguments.requestObj.getActionFromPath()>
		<cfset var currentmodule = arguments.requestObj.getModuleFromPath()>
		<cfset var id ="">
		<cfset var class = "">
		
		<cfset arrayappend(r,"<ul>")>
	
		<cfloop query="q">
			<cfset id = ''>	
			<cfset class = "">
			<cfif q.module EQ currentaction>
				<cfset id = 'id="selected"'>
			</cfif>
			
			<cfif q.currentrow EQ 1>
				<cfset class='class="alternate"'>
			</cfif>
			<cfset arrayappend(r,"<li #id# #class#><a href=""/#currentmodule#/#method#/"">#label#</a></li>")>
		</cfloop>
		
		<cfset arrayappend(r,"</ul>")>
		
		<cfreturn arraytolist(r,"#chr(13)##chr(10)#")>
	</cffunction>
	
	<cffunction name="dump">
		<cfdump var="#variables#"><cfabort>
	</cffunction>
	
	<cffunction name="getModuleLabel" OUtput="False">
		<cfargument name="requestObject" required="true">
		
		<cfset var module = requestObject.getFormUrlVar('module')>
		<cfset var mdl = "">
		
		<cfif NOT structkeyexists(variables.modules, module)>
			<cfthrow message="in menusystem.cfc, #module# not found in modules">
		</cfif>
	
		<cfreturn variables.modules[module].label>
	</cffunction>
	
	<cffunction name="getActionLabel">
		<cfargument name="requestObject" required="true">
		
		<cfset var module = requestObject.getFormUrlVar('module')>
		<cfset var action = requestObject.getFormUrlVar('action')>
				
		<cfif NOT structkeyexists(variables.modules, module)>
			<cfthrow message="in menusystem.cfc, #module# not found in modules">
		</cfif>
		
		<cfif NOT structkeyexists(variables.modules[module].actions, action)>
			<cfthrow message="in menusystem.cfc, #module# #action# not found in modules">
		</cfif>
	
		<cfreturn variables.modules[module].actions[action].name>
	</cffunction>
</cfcomponent>