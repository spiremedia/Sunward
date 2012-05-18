<cfset lcl.userinfo = getDataItem('userinfo')>
<cfset lcl.states = getDataItem('states')>
<cfset lcl.form = createWidget("formcreator")>

<cfset lcl.form.startform()>
<cfset lcl.form.addformitem('line1', 'Line 1', false, 'text', lcl.userinfo.line1)>
<cfset lcl.form.addformitem('line2', 'Line 2', false, 'text', lcl.userinfo.line2)>
<cfset lcl.form.addformitem('city', 'City', false, 'text', lcl.userinfo.city)>
<cfset lcl.config = structnew()>
<cfset lcl.config.options = lcl.states>
<cfset lcl.config.addblank = 1>
<cfset lcl.config.blanktext = ''>
<cfset lcl.config.labelskey = 'name'>
<cfset lcl.config.valueskey = 'abbrev'>
<cfset lcl.form.addformitem('state', 'State', false, 'select', lcl.userinfo.state, lcl.config)>
<cfset lcl.countrystuff = structnew()>
<cfset lcl.countrystuff.options = querynew('value,label')>
<cfset queryaddrow(lcl.countrystuff.options)>
<cfset querysetcell(lcl.countrystuff.options,'value','USA')>
<cfset querysetcell(lcl.countrystuff.options,'label','USA')>
<cfset lcl.form.addformitem('country', 'Country', false, 'select', lcl.userinfo.country, lcl.countrystuff)>
<cfset lcl.form.addformitem('postalcode', 'Postal Code', false, 'text', lcl.userinfo.postalcode)>
<cfset lcl.form.endform()>

<cfoutput>#lcl.form.showHTML()#</cfoutput>