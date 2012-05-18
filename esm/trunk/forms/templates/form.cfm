<cfset lcl.info = getDataItem('info')>

<div class="content-block form 1">
	<cfoutput>#lcl.info.getField('definition')#</cfoutput>
	<!--- <input type="hidden" name="id" value="<cfoutput>#lcl.info.getField('id')#</cfoutput>" /> --->
</div>

<!--- 					<div id="contentDiv">

						

&nbsp;<input class="contentObjectMarker" id="025081CC-BBFC-A830-D92B3C19DDC87A4C" type="hidden" name="mainContent2" value='{"PARAMETERLIST":"editable","MODULE":"HTMLContent,Search,Form,Assets,Events","NAME":"mainContent2"}'>
			
		
					</div> --->
						