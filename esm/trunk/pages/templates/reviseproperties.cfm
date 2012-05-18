<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.form.startform()>
<cfset lcl.options = structnew()>
<cfset lcl.options.style = "width:350px;height:70px;">
<cfset lcl.form.addformitem('Comments', 'Comments', true, 'textarea', '', lcl.options)>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>