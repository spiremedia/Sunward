<cfset lcl.image = getDataItem("info")>
<cfset lcl.images = getDataItem("images")>
<cfset lcl.filename = lcl.image.getField("filename")>

<cfif lcl.filename EQ "">
	Upload an image(use button on top right).
<cfelse>
	<cfoutput query="lcl.images">
		<h4>#name# (#maxwidth# x #maxheight#)</h4>
		<img src="/docs/imagegalleries/#lcl.image.getField('id')#/#rereplace(lcl.filename, "\.(jpg|png)", "#extensionmod#.\1", "all")#"/>
	</cfoutput>
</cfif>