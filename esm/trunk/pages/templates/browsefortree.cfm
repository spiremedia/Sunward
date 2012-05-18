	<cfset lcl.acc = createWidget('accordion')>
	<cfset lcl.acc.setID('browselist')>
	<cfset lcl.list = getDataItem('list')>
	
	<cfif isdataItemSet('id')>
		<cfset lcl.id = getDataItem('id')>
	<cfelse>
		<cfset lcl.id = 0>
	</cfif>

	<cfset lcl.count = 0>
	

<!--- <cfdump var=#lcl.list#> --->

	<cfset lcl.s = structnew()>
	<cfset lcl.s.tlid = "">
	<cfset lcl.s.temp = "">
	<cfset lcl.s.ca = arraynew(1)>
	<cfset lcl.s.nexttitle = "">
	<cfset lcl.s.titlecount = 0>
	
	<cfoutput query="lcl.list">
		<cfif lcl.s.tlid NEQ left(hid,7)>
			<!--->resetting to #pagename#<br>--->
			<cfset lcl.s.tlid = left(hid,7)>
			<cfset lcl.s.nexttitle = Pagename>
			<cfset lcl.s.ca = arraynew(1)>
			<cfset arrayappend(lcl.s.ca,'<div class="nav">')>
			<cfset lcl.s.titlecount = lcl.s.titlecount + 1>
		</cfif>
			
		<cfif lcl.id EQ id>
			<cfset lcl.s.selected = 'class="selected"'>
			<cfset lcl.acc.setSelected(lcl.s.titlecount)>
		<cfelse>
			<cfset lcl.s.selected = ''>
		</cfif>
			
		<cfif lcl.s.tlid EQ hid>
			<cfset lcl.s.landing = "(Landing)">
		<cfelse>
			<cfset lcl.s.landing = "">
		</cfif>
		
		<!---><cfif lcl.list.levelafter NEQ "">
			<cfset arrayappend(lcl.s.ca,'</li>')>
		</cfif>--->
		
		<cfif lcl.list.levelbefore EQ "+">
			<cfset arrayappend(lcl.s.ca,'<ul>')>
		</cfif>
		
		<cfset arrayappend(lcl.s.ca,'<li><a #lcl.s.selected# href="/Pages/editPage/?id=#id#">#pagename# #lcl.s.landing#</a>')>
				
		<cfif lcl.list.levelbefore NEQ "+">
			<cfset arrayappend(lcl.s.ca, '</li>')>
		</cfif>
				
		<cfif  lcl.list.levelafter NEQ "">
			<cfset arrayappend(lcl.s.ca, repeatstring('</ul></li>', len(lcl.list.levelafter)) )>
		</cfif>
		
		<cfif lcl.list.currentrow EQ lcl.list.recordcount OR 
				left(lcl.list['hid'][lcl.list.currentrow + 1],7) NEQ lcl.s.tlid>
			<!--->	adding #lcl.s.nexttitle# with content #arraytolist(lcl.s.ca,"#chr(13)##chr(10)#")#<br>--->
			<cfset arrayappend(lcl.s.ca,'</div>')>
			<cfset lcl.acc.add(lcl.s.nexttitle, arraytolist(lcl.s.ca,"#chr(13)##chr(10)#"))>
		</cfif>
	</cfoutput>

<cfoutput>#lcl.acc.showHTML()#</cfoutput>