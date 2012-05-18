<cfsilent>
	<cfset lcl.acc = createWidget('accordion')>
	<cfset lcl.acc.setID('browselist')>
	<cfset lcl.list = getDataItem('list')>
	
	<cfif requestObj.isFormUrlVarSet('m') AND requestObj.isFormUrlVarSet('a')>
		<cfset lcl.module = requestObj.isFormUrlVarSet('m')>
		<cfset lcl.action = requestObj.isFormUrlVarSet('a')>
	<cfelse>
		<cfset lcl.module = 0>
		<cfset lcl.action = 0>
	</cfif>

	<cfset lcl.count = 0>

	<cfset lcl.s = structnew()>
	
	<cfif lcl.list.recordcount>
		<!---><cfoutput query="lcl.list" group="module">
			<cfset lcl.count = lcl.count + 1>--->
			<cfsavecontent variable="lcl.s.html">
				<div class="nav">
				<ul>
				<cfoutput query="lcl.list">
					<li><a target="_blank" <cfif lcl.module EQ lcl.list.module[lcl.list.currentrow]>class="selected"</cfif> href="../HelpItem/?m=#replace(module, "_", " ", "all")#">#module#</a></li>
				</cfoutput>
				</ul>
				</div>
			</cfsavecontent>
			<cfset lcl.acc.add('Help Files',lcl.s.html)>
		<!---></cfoutput>--->
	<cfelse>
		<cfset lcl.acc.add("No Help Files Set","")>
	</cfif>
</cfsilent>


<cfoutput>#lcl.acc.showHTML()#</cfoutput>