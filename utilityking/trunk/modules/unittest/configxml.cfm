<cfsavecontent variable="modulexml">
<moduleInfo>
	<action match="^unittest/[a-zA-Z0-9\_]+">
		<loadcfc>unitTest</loadcfc>
        <template>_blank</template>
	</action>
</moduleInfo>
</cfsavecontent>

<cfset modulexml = xmlparse(modulexml)>