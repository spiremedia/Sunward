<cfset lcl.keyphrases = getDataItem('keyphrases')>
<cfset lcl.form = createWidget("formcreator")>

<p>Add one phrase per line to the Key Phrases textarea that the site will be seo targeted to.</p><p>Phrases will then be used when analyzing pages in the last accordion of the edit page view.</p>
<cfset lcl.form.startform()>
<cfset lcl.config = structnew()>
<cfset lcl.config.style="width:400px;height:300px;">
<cfset lcl.form.addformitem('keyphrases', 'Key Phrases', true, 'textarea', lcl.keyphrases, lcl.config)>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>