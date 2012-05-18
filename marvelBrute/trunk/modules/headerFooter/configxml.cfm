<cfsavecontent variable="modulexml">
<moduleInfo>
   	 <action match="^system/headerfooter/head">
        <loadcfc>showheaderFooter</loadcfc>
        <template>_head</template>
        <title>[title]</title>
        <keywords>[keywords]</keywords>
        <description>[description]</description>
        <breadcrumbs></breadcrumbs>
    </action>
   	 <action match="^system/headerfooter/simpleheader">
        <loadcfc>showheaderFooter</loadcfc>
        <template>_headSimple</template>
        <title>[title]</title>
        <keywords>[keywords]</keywords>
        <description>[description]</description>
        <breadcrumbs></breadcrumbs>
    </action>
    <action match="^system/headerfooter/foot">
        <loadcfc>showheaderFooter</loadcfc>
        <template>_foot</template>
        <title>[title]</title>
        <keywords>[keywords]</keywords>
        <description>[description]</description>
        <breadcrumbs></breadcrumbs>
    </action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>