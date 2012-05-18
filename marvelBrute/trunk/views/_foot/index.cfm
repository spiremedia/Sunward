<cfoutput>
<cfsavecontent variable="lcl.cntnts">
				</div>

			</div>
            <br class="clear"/>
			<cfinclude template="../footer.cfm">
		</div>
	</div>
</body>
</html>
</cfsavecontent>

<cfset lcl.cntnts = replacenocase(lcl.cntnts, 'href="/', 'href="#requestObject.getVar('siteurl')#',"all")>
<cfset lcl.cntnts = replacenocase(lcl.cntnts, 'src="/', 'src="#requestObject.getVar('siteurl')#',"all")>
<cfset lcl.cntnts = replacenocase(lcl.cntnts, 'action="/', 'action="#requestObject.getVar('siteurl')#',"all")>

<cfcontent reset="yes">#lcl.cntnts#
</cfoutput>

