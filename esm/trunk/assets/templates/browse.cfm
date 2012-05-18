
<cfsilent>

	<cfset lcl.acc = createWidget('accordion')>
	<cfset lcl.acc.setID('browselist')>
	<cfset lcl.list = getDataItem('list')>
	
	<cfif isdataItemSet('id')>
		<cfset lcl.id = getDataItem('id')>
	<cfelse>
		<cfset lcl.id = 0>
	</cfif>

	<cfset lcl.count = 0>

	<cfset lcl.s = structnew()>
	<cfoutput query="lcl.list" group="assetgroupname">
		<cfset lcl.count = lcl.count + 1>
		<cfsavecontent variable="lcl.s.html">
			<div class="nav">
			<ul>
			<cfoutput>
				<li><a <cfif lcl.id EQ lcl.list.id[lcl.list.currentrow]>class="selected" <cfset lcl.acc.setselected(lcl.count)></cfif> href="../editAsset/?id=#id#">#name#</a></li>
			</cfoutput>
			</ul>
			</div>
		</cfsavecontent>
		<cfset lcl.acc.add(assetgroupname,lcl.s.html)>
	</cfoutput>
	
	<cfif lcl.list.recordcount EQ 0>
		<cfset lcl.acc.add("No Assets Loaded","")>
	</cfif>
</cfsilent>

<cfoutput>#lcl.acc.showHTML()#</cfoutput>
