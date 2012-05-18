<cfsavecontent variable="modulexml">
<module name="TinyMce" label="TinyMce" menuOrder="0" securityitems="">
	
	<action name="show JS Page List"/>
	
	<action name="show JS Image List"/>
    <action name="get Style"/>

</module>
</cfsavecontent>


<cfset modulexml = xmlparse(modulexml)>
