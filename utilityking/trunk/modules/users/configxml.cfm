<cfsavecontent variable="modulexml">
<moduleInfo>
	<postProcess replaceString="[postprocess-usershtml]" parameterList="embededform"/>
   	 <action match="^Users/Login/?">
        <loadcfc>userLogin</loadcfc>
        <template>Article_I-frame</template>
        <title>User Login</title>
        <description>User Login</description>
        <keywords>User Login</keywords>
    </action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>