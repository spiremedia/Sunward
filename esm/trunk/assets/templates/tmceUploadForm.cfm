<cfset lcl.List = getDataItem('grouptypes')>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Image Upload</title>
	<script language="javascript" type="text/javascript" src="/ui/tiny_mce/tiny_mce_popup.js"></script>
	<script>

		function showErrors(error){
			document.getElementById("msg").innerHTML = "There was a problem." + error;
		}
		var FileBrowserDialogue = {
			init : function () {
		   		// Here goes your code for setting your custom things onLoad.
			},
			imageChosen : function (id) {
				var url = "/assets/viewImage/?id=" + id;
				var win = tinyMCEPopup.getWindowArg("window");

				// insert information now
				win.document.getElementById(tinyMCEPopup.getWindowArg("input")).value = url;

				// for image browsers: update image dimensions
				if (win.ImageDialog.getImageData) win.ImageDialog.getImageData();
				if (win.ImageDialog.showPreviewImage) win.ImageDialog.showPreviewImage(url);

				//update the description and title
				var imgName = document.getElementById("name").value;
				win.document.getElementById("alt").value = imgName;
				win.document.getElementById("title").value = imgName;

				//add a list eleemnt to the drop list if it exists
				var lst = win.document.getElementById('src_list');
				var option = win.document.createElement('option');
				option.setAttribute('value',url);
				option.appendChild(win.document.createTextNode(imgName));
				lst.appendChild(option);
				// close popup window
				tinyMCEPopup.close();
			}
		}

		tinyMCEPopup.onInit.add(FileBrowserDialogue.init, FileBrowserDialogue);
	</script>
	<style>
		#msg {
			color:red;font-weight:bold;
		}
		#msg ul {
			margin-top:0;
			padding-top:0;
			margin-bottom:0;
			padding-bottom:0;
		}
		#submitIframe {
			display:none;
		}
	</style>
	<base target="_self" />
</head>
<body style="display: none">
<form  enctype="multipart/form-data"  method='post' target="submitIframe" name="uploadForm" action="/assets/tinymceuploadaction/">
	<input type="hidden" name="id" value="0">
	<table border="0" cellpadding="4" cellspacing="0">
		<tr>
			<td colspan="2" class="title">Upload an Image asset</td>
		</tr>
		<tr>
			<td colspan="2" class="msg"><div id="msg" style="">Note:<br/>&nbsp;This form will store uploaded images in the assets area.</div></td>
		</tr>
		<tr>
			<td nowrap="nowrap">Asset Name</td>
			<td><input name="name" type="text" class="mceFocus" id="name" value="" style="width: 300px" /></td>
		</tr>
		<tr>
			<td nowrap="nowrap">Asset Group</td>
			<td>
				<select name="assetGroupid">
					<cfoutput query="lcl.list">
					<option value="#id#">#name#</option></cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<td nowrap="nowrap">File</td>
			<td><input name="filename" type="file" class="mceFocus" id="filename" /></td>
		</tr>
	</table>

	<div class="mceActionPanel">
		<div style="float: left">
			<input type="submit" id="insert" name="insert" value="Save" />
		</div>

		<div style="float: right">
			<input type="button" id="cancel" name="cancel" value="{#cancel}" onclick="tinyMCEPopup.close();" />
		</div>

	</div>
</form>
<iframe id="submitIframe" name="submitIframe" width="500" height="100"></iframe>
</body>
</html>
