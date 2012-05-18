<cfset lcl.asset = getDataItem("info")>
<cfset lcl.filename = lcl.asset.getField("filename")>
<cfset lcl.extension = listlast(lcl.filename,".")>
<cfset lcl.id = lcl.asset.getField("id")>
<cfif NOT listfind("jpg,png,gif",lcl.extension)>
	Not applicable.
<cfelse>
	<script type="text/javascript" src="/ui/js/imageEditor/PageInfo.js"></script>
	<script type="text/javascript" src="/ui/js/imageEditor/ImageEditor.js"></script>
	<script type="text/javascript">
	//<![CDATA[
		if (window.opener){
			//window.moveTo(0, 0);
			//window.resizeTo(screen.width, screen.height - 28);
			//window.focus();
		}
		<cfoutput>
		Event.observe(window, 'load',
			function() { ImageEditor.init("#lcl.id#"); }
		);
		</cfoutput>
	//]]>
	</script>
    <style>
        body {
            margin: 0;
            padding: 0;
        }
        #image-editor {
            padding: 0px 3px 3px 3px;
            font-size: 10px;
        }
        #image-editor .toolbar {
            padding: 3px 0px;
            border-bottom: 1px solid #ccc;
            white-space: nowrap;
        }
        #image-editor .toolbar button {
            font-size: 10px;
            margin: 0 1px;
        }
        #image-editor .toolbar span.spacer {
            font-weight:bold;
            font-size: 16px;
            color: #ccc;
        }
        #image-editor #loading-text {
            font-size: 16px;
            font-weight: bold;
            color: #333;
            white-space: nowrap;
        }
        #image-editor #txt-width, #image-editor #txt-height {
            font-size: 10px;
            text-align: center;
        }
        #image-editor #crop-size {
            font-size: 12px;
        }
        #image-editor #image {
            background-repeat: no-repeat;
            margin-top: 3px;
        }
        .cropRegion {
            position: absolute;
            zIndex: 2;
            border: 1px dotted #fff;
            cursor: crosshair;
            display: none;
        }
	</style>
	<div id="image-editor">
		<div class="toolbar">
			<button onclick="ImageEditor.revertToOriginal();">Revert to Orig</button>
			<!---<button onclick="ImageEditor.viewActive()">View Active</button>
			<button onclick="ImageEditor.save()">Save As Active</button>
			<span class="spacer"> || </span>
			<button onclick="ImageEditor.undo()">Undo/Redo</button>
			<span class="spacer"> || </span>--->
			w:<input id="txt-width" type="text" size="3" maxlength="4" />
			h:<input id="txt-height" type="text" size="3" maxlength="4" />
			<input id="chk-constrain" type="checkbox" checked="checked" />Constrain
			<button onclick="ImageEditor.resize();">Resize</button>
			<!---<span class="spacer"> || </span>--->
			<button onclick="ImageEditor.rotate(270)">Rotate 90&deg;CCW</button>
			<button onclick="ImageEditor.rotate(90)">Rotate 90&deg;CW</button>
			<!---<span class="spacer"> || </span>--->
			<button onclick="ImageEditor.crop()">Crop</button>
            <br/>
			<span id="crop-size"></span>
		</div>
		<!---<div class="toolbar">
			<button onclick="ImageEditor.grayscale()">Gray Scale</button>
			<button onclick="ImageEditor.sepia()">Sepia</button>
			<button onclick="ImageEditor.pencil()">Pencil</button>
			<button onclick="ImageEditor.emboss()">Emboss</button>
			<button onclick="ImageEditor.sblur()">Blur</button>
			<button onclick="ImageEditor.smooth()">Smooth</button>
			<button onclick="ImageEditor.invert()">Invert</button>
			<button onclick="ImageEditor.brighten()">Brighten</button>
			<button onclick="ImageEditor.darken()">Darken</button>
		</div>--->
		<div id="imagewrap"><div id="image"></div></div>
	</div>
	
</cfif>