<cfset lcl.info = getDataItem('Info')>
<cfset lcl.form = createWidget("formcreator")>


<cfset lcl.form.startform()>
<cfset lcl.config = structnew()>
<cfset lcl.config.options = querynew('module')>
<cfloop list="#lcl.info.module#" index="itm">
	<cfset queryaddrow(lcl.config.options)>
	<cfset querysetcell(lcl.config.options, 'module', trim(itm))>
</cfloop>

<cfset lcl.config.labelskey = 'module'>
<cfset lcl.config.valueskey = 'module'>

<cfset lcl.form.addformitem('mdl', 'Modules Available', false, 'select', '', lcl.config)>
<cfset lcl.form.addformitem('pageid', '', false, 'hidden', lcl.info.pageid)>
<cfset lcl.form.addformitem('objName', '', false, 'hidden', lcl.info.objname)>
<cfset lcl.form.addformitem('memberType', '', false, 'hidden', 'default')>
<cfset lcl.form.addformitem('parameterlist', '', false, 'hidden',lcl.info.parameterlist)>
<cfset lcl.form.endform()>


<cfoutput>#lcl.form.showHTML()#</cfoutput>
<input type="button" onclick="self.close();" value="Cancel">
<input type="submit" value="Save">

<script>
	window.resizeTo(870, 290);
</script>