<cfset lcl.defaultdescription = getDataItem('defaultdescription')>
<cfset lcl.defaultkeywords = getDataItem('defaultkeywords')>

<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.form.startform()>


<cfset lcl.options = structnew()>
<cfset lcl.options.style="width:250px;height:70px;">

<cfset lcl.form.addformitem('defaultdescription', 'Default Description', true, 'textarea', lcl.defaultdescription, lcl.options)>

<cfset lcl.options = structnew()>
<cfset lcl.options.style="width:250px;height:70px;">
<cfset lcl.form.addformitem('defaultkeywords', 'Default Keywords', true, 'textarea', lcl.defaultkeywords, lcl.options)>

<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>


<cfoutput>#lcl.defaultdescription#</cfoutput>