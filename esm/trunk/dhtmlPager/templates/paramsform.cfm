<cfset lcl.widgetModel = getDataItem('widgetsModel')>
<cfset lcl.widgetInfo = lcl.widgetModel.getInfo()>
<cfset lcl.plist = lcl.widgetmodel.getParsedParameterList()>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.form.startform()>
<cfset lcl.options = structnew()>

<cfset lcl.options.options = querynew("value,label")>
<cfloop from="1" to="10" index="lcl.count">
	<cfset queryaddrow(lcl.options.options)>
	<cfset querysetcell(lcl.options.options, 'value', lcl.count)>
	<cfset querysetcell(lcl.options.options, 'label',lcl.count)>
</cfloop>

<cfset querysetcell(lcl.options.options, 'value', "all")>
<cfset querysetcell(lcl.options.options, 'label',"all")>

<cfset queryaddrow(lcl.options.options)>

<cfset lcl.form.addformitem('startsopen', 'Item Starts Open', false, 'select', lcl.widgetinfo.startsopen, lcl.options)>

<cfset lcl.options = structnew()>

<cfif structkeyexists(lcl.plist, 'type')>
	<cfset lcl.options.options = lcl.plist['type']>
<cfelse>
	<cfset lcl.options.options = "Accordion,Tabs">
</cfif>

<cfset lcl.form.addformitem('dhtmltype', 'DHTML Type', false, 'select', lcl.widgetinfo.dhtmltype, lcl.options)>

<cfset lcl.form.endform()>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
