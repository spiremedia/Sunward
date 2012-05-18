<cfset lcl.info = getDataItem('Info')>
<cfset lcl.memberTypes = getDataItem('memberTypes')>
<cfset lcl.form = createWidget("formcreator")>
<cfset items.itm = lcl.info.items>

<cfquery name="items.getDefault" dbtype="query">
	SELECT * FROM items.itm WHERE memberType = 'default'
</cfquery>

<cfquery name="items.nonDefault" dbtype="query">
	SELECT * FROM items.itm WHERE memberType <> 'default'
</cfquery>

<cfset items.membertypes = getDataItem('membertypes')>

<!--- add default so we can recreate a deleted default group --->

<cfquery name="items.unusedGroups" dbtype="query">
	SELECT id, name FROM items.memberTypes WHERE name NOT IN ('#valuelist(items.itm.memberType, "','")#')
</cfquery>

<cfoutput>
    <cfif items.getDefault.recordcount>
        <p>
        Edit the <strong>default</strong> content object. 
        <a href="/#items.getDefault.module#/editClientModule/?id=#items.getDefault.id#&parameterlist=#urlencodedformat(lcl.info.parameterlist)#">Default</a> (#items.getDefault.module#).
        </p>
        <hr size="1" noshade width="60%" align="left" />
     </cfif>
    <cfif items.nonDefault.recordcount>
        <p>
        There are also existing content objects for specific Member Types.<br />
        <select name="alternate" onChange="if (this.value != '') location.href=this.value + '#urlencodedformat(lcl.info.parameterlist)#';">
        <option value="">Choose</option>
        <cfloop query="items.nonDefault">
            <option value="/#items.nonDefault.module#/editClientModule/?id=#items.nonDefault.id#&parameterlist=#urlencodedformat(lcl.info.parameterlist)#">#items.nonDefault.memberType# (#items.nondefault.module#)</option>
        </cfloop>
        </select>
        </p>
        <hr size="1" noshade width="60%" align="left" />
    </cfif>
    
    
    <cfif items.unusedgroups.recordcount>
        <p>
        Or you may create content for a specific Member Type:
        
        <cfset lcl.form.startform()>
        <cfset lcl.config = structnew()>
        <cfset lcl.config.options = items.unusedgroups>
        
        <cfset lcl.config.labelskey = 'name'>
        <cfset lcl.config.valueskey = 'name'>
        <cfset lcl.form.addformitem('memberType', 'Member Types Available', false, 'select', '', lcl.config)>
        
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
        <cfset lcl.form.addformitem('objName', '', false, 'hidden', lcl.info.name)>
		<cfset lcl.form.addformitem('parameterlist', '', false, 'hidden', lcl.info.parameterlist)>
        <cfset lcl.form.endform()>
        
        
        <cfoutput>#lcl.form.showHTML()#</cfoutput>
        <input type="button" onclick="self.close();" value="Cancel">
        <input type="submit" value="Save">
        </p>
        <cfelse>
        All of the alternate Member Types are being used.
    </cfif>
</cfoutput>
<script>
	window.resizeTo(870, 423);
</script>