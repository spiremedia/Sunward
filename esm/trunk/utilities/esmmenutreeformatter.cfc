<cfcomponent name="formatter">
	
	<cffunction name="init">
		<cfargument name="selected" required="true">
		<cfargument name="siteMapObject" required="true">
		<cfargument name="accordionObject" required="true">
		<cfargument name="stateObject" required="true">
		<cfargument name="userObject" required="true">
		<cfset variables.selectedid = arguments.selected>
		<cfset variables.siteMapObject = arguments.siteMapObject>
		<cfset variables.accordionObject = arguments.accordionObject>
		<cfset variables.stateObject = arguments.stateObject>
		<cfset variables.userObject = arguments.userObject>
		<cfset variables.strlist = arraynew(1)>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getHTML" output="true">
		<!--- 
			It breaks the sitemap generation into silos (a silo is a 
			second level navigation and all its children) which are 
			then fed into an accordion object
			
			It either gets the silo (ul li a tree structure) from 
			application scope or regenerates it dynamically via 
			the 'utilities.esmmenuulliformatter' cfc and stores each silo 
			in memory if it was regenerated
			
			For each silo item, 
				The system must have the silo html, its either in state object 
				or it muset be recreated
				
				It checks the top level silo item for users rights to it. 
				This is an optimization step as most permissions use is 
				at the secondary nav level.
				
				If user does not have rightsm, it loads silo as xml 
				and does xpath operations on it with the users 
				allowed ids from the session object.
				
				When it finds an allowed object, it does another xpath 
				operation to get all its a tags and removes the disabling 
				attributes which gives the user the right to that area.
				
		  		It then feeds each silo to the accordion
		  		
		  		While in this loop, it determines if the selected id is
		  		in this silo so that it can be opened for display.
		  	
		  	Then it sets the selected silo open if one was found and
		  	returns the renderd accordion.
		 --->
		<cfset var silos = arraynew(1)>
		<cfset var locationTopAllowedID = userObject.getLocationTopAllowedID()>
		<cfset var tli = variables.siteMapObject.getTopItem(locationTopAllowedID)>
		<cfset var tlis = variables.siteMapObject.getChildren(tli.id)>
		<cfset var formatter = "">
		<cfset var silohtml = "">
		<cfset var selectedSilo = 1>
		<cfset var siloList = arraynew(1)>
		<cfset var selected = ''>
		<cfset var link = "">
		<!--- determine if user is allowed to root --->
		<cfset var rootallowed =  userObject.isPathAllowed(tli.urlpath)>
		<!--- get users alloweable ids --->
		<cfset var allowedLocationIds = userObject.getAllowedLocationIds()>
		<cfset var siloxml = "">
		<cfset var disabledText = ' class="disabled" onclick="return false;" '>

		<!--- setup the home page accordion area --->
		<cfset link = "<a href='/pages/editPage/?id=#tli.id#'>#tli.pagename#</a>">

		<cfif NOT userObject.isPathAllowed(tli.urlpath)>
			<cfset link = replace(link, "<a", "<a #disabledText#")>
		</cfif>
		
		<cfset accordionObject.add(tli.pagename, "<div class='nav'><ul><li>#link#</li></ul></div>")>

		<cfloop query="tlis">
			
			<!--- check for existence of this silo in state --->
			<cfif variables.stateObject.isvarset("_#userobject.getCurrentSiteId()#_#tlis.id#")>

				<cfset silohtml = variables.stateObject.getVar("_#userobject.getCurrentSiteId()#_#tlis.id#")>
			<cfelse>
				<!--- 
					not found, recreate silo
					store in state
				--->
				<cfset formatter = createObject('component', 'utilities.esmmenuulliformatter').init("noselect")>
				<cfset silohtml = siteMapObject.getTree(variables.userobject, formatter, tlis.id)>
				<cfset variables.stateObject.setVar("_#userobject.getCurrentSiteId()#_#tlis.id#", silohtml)>
			</cfif>
			
			<!--- determine if user is allowed. If so, skip sub processing  --->
			<cfif NOT rootallowed AND NOT userObject.isPathAllowed(tlis.urlpath)>
				<cfset silohtml = setAlloweablesInLinksViaXml(silohtml, allowedLocationIds)>
			</cfif>
			
			<cfset silohtml = '<div class="nav">' & silohtml & '</div>'>
			
			<!--- if a silo was found to contain the id, mark it so --->
			<cfif variables.selectedid NEQ "" AND find(variables.selectedid, silohtml)>
				<cfset selectedsilo = tlis.currentrow + 1>
			</cfif>
			
			<cfif selectedid NEQ "">
				<cfset silohtml = replace(silohtml, '<a  href="/pages/editPage/?id=#selectedid#', '<a class="selected" href="/pages/editPage/?id=#selectedid#')>
			</cfif>
			<!--- add silo to accordion --->
			<cfset accordionObject.add(tlis.pagename, silohtml)>
			
		</cfloop>
		
		<!--- set appropriate accordion panel open --->
		<cfset accordionObject.setSelected(selectedsilo)>
		

		<cfreturn accordionObject.showHTML()>
	</cffunction>
	
	<cffunction name="setAlloweablesInLinksViaXml" output="true">
		<cfargument name="localhtml" required="true">
		<cfargument name="alloweableids" required="true">
			
		<cfset var localxml = "">
		<cfset var aid = "">
		<cfset var disabledText = ' class="disabled" onclick="return false;" '>
		<cfset var anchors = "">
		<!--- make each link inactive. We'll reactivate them in xml if they are allowed --->
		
		<cfset localhtml = replace(localhtml, "<a", "<a #disabledText#", "all")>
	
		<cfset localxml = xmlparse(localhtml)>
	
		<cfloop collection="#alloweableids#" item="aid">		
		
			<cfset anchors = XmlSearch
				(
					localxml,
					'//li[a/@href=''/pages/editPage/?id=#aid#'']/descendant-or-self::li/a'
				)>

			<cfloop from="1" to="#ArrayLen(anchors)#" index="j">
				<cfset StructDelete(anchors[j].XmlAttributes, 'class', false)>
				<cfset StructDelete(anchors[j].XmlAttributes, 'onclick', false)>
			</cfloop>
			
		</cfloop>
		
		<cfset localhtml = tostring(localxml)>
		
		<cfreturn replace(localhtml, '<?xml version="1.0" encoding="UTF-8"?>','')>
	</cffunction>
	
</cfcomponent>