<cfset lcl.widgetModel = getDataItem('widgetsModel')>
<cfset lcl.items = lcl.widgetModel.getInfo()>
<cfset lcl.id = lcl.widgetModel.getId()>
<cfset lcl.itemsjson = getDataItem('itemsjson')>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.plist = lcl.widgetmodel.getParsedParameterList()>

<style>
	ul#pageItemList { 
		list-style:none;
		margin:0;
		padding:0;
	}
	ul#pageItemList li{
		list-style:none;
		padding:3px;
		margin:0;
	}
	div#msg2 {
		font-weight:bold;
		color:red;
		padding:4px;
		font-size:11px;
	}
</style>
<div id="msg2">

</div>
<table width="100%">
<tr>
<td valign="top">
	<div id="itemListDiv">
    	<ul id="pageItemList">
    	
        </ul>
        
    </div>

    <p>(drag drop for order)</p>
</td>
<td valign="top">

	<div id="itemForm">
        <table class='formtable'>
        <tr>
        <td class='label'>
        <label for='Title'>
        Title
        </label>
        </td>
        <td>
        <input type='text'  name='frmTitle' id='frmTitle' size="50" value=""   >
        </td>
        </tr>
        <input type='hidden' name='id' id='id' value="">
        <tr>
        <td class='label'>
        <label for='Content'>
        Content
        </label>
        </td>
        <td>
        <textarea class="myconfig" name="frmContent" id="frmContent" style='width:500px;height:200px;'></textarea>
        <br /><br />
		<input type="button" value="Save Item" onClick="myFormMgr.saveItem()"/>
        <input type="button" value="Clear for New" onClick="myFormMgr.startadd()"/>
        </td>
        </tr>
        </table>
    </div>
    
</td>
</tr>
</table>


<script language="javascript" type="text/javascript" src="/ui/tiny_mce/tiny_mce.js"></script>

<script language="javascript" type="text/javascript" src="/ui/js/scriptaculous.js"></script>
<script language="javascript" type="text/javascript" src="/ui/js/dragdrop.js"></script>

<script language="javascript" type="text/javascript">
    tinyMCE.init({
        mode : "textareas", 
        editor_selector : "myconfig", 
        theme : "advanced",  
        
        theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,styleselect,formatselect",
        theme_advanced_buttons2 : "cut,copy,paste,pastetext,pasteword,|,bullist,numlist,|,outdent,indent,blockquote,|,undo,redo,|,link,unlink,anchor,image,cleanup,help,code",
        theme_advanced_buttons3 : "hr,removeformat,visualaid,sub,sup,|,charmap",
        plugins : "paste,table",
		<cfif isdefined("lcl.plist.css")>
			<cfoutput>content_css : "/ui/css/tmce.css,/tinymce/getStyle/?file=#urlencodedformat(lcl.plist.css)#",</cfoutput>
		<cfelse>
			content_css : "/ui/css/tmce.css",
		</cfif>
        add_form_submit_trigger : true,
        
        external_link_list_url : "/tinymce/showJSPageList/",
        
        external_image_list_url : "/tinymce/showJSImageList/",
        
        convert_urls : false,
        theme_advanced_buttons3_add : "tablecontrols"
    });


	function submitAjaxForm(){
		
		var myForm = 'id=<cfoutput>#lcl.id#</cfoutput>';
		myForm += '&startsopen=' + document.myForm.startsopen.value;
		myForm += '&dhtmltype=' + document.myForm.dhtmltype.value;
		myForm += "&items=" + itemList.getItems();
		$('trace').innerHTML = myForm;
		ajaxWResponseJsCaller('/dhtmlpager/saveClientModule/',myForm);
		return false;
	}

	function Items() {
		this.init = function(itms){
			itms = eval(itms);
			for (var i = 0; i < itms.length; i++){
				this.addItm(itms[i]);
			}
			Sortable.create('pageItemList',{ghosting:true});
		}
		this.getItems = function(){
			var a = new Array();

			var links = $('pageItemList').childNodes;
			for (var i = 0; i < links.length; i++){
				if (links[i].childNodes.length == 2){
					var itmObj = new Object();
					itmObj.title = links[i].childNodes[0].innerHTML;
					itmObj.content = links[i].childNodes[0].content;
					a.push(itmObj);
				}
			}		
			return escape(Object.toJSON(a));
		}
		
		this.addItm = function(itm) {
			var myli = document.createElement('LI');
			var mya = document.createElement('A');
			var txt = document.createTextNode(itm.title);
			//alert(itm.title)
			mya.setAttribute('href', "");
			mya.onclick = function(){myFormMgr.startedit(this);return false;};
			mya.content = itm.content;
			mya.appendChild(txt); 
			myli.appendChild(mya);
			var mydelbtn = document.createElement('IMG');
			mydelbtn.setAttribute('src', '/ui/images/button/delete.gif');
			mydelbtn.onmouseup = function(){itemList.removeItm(mydelbtn);};
			mydelbtn.style.marginLeft = '10px';
			myli.appendChild(mydelbtn); 
			$("pageItemList").appendChild(myli);
			Sortable.create('pageItemList');//destroy and recreate sorting so that items stay working
			Sortable.create('pageItemList',{ghosting:true});
			
		}
		this.editItm = function(data) {
			var link = $('id').linkRef;
			link.content = data.content;
			
			link.innerHTML = data.title;
		}
		this.removeItm = function(itm) {
			myFormMgr.startadd();
			$('msg2').innerHTML = "Item \""+itm.parentNode.childNodes[0].innerHTML+"\" Deleted";
			itm.parentNode.parentNode.removeChild(itm.parentNode);
			Sortable.create('pageItemList');//destroy and recreate sorting so that items stay working
			Sortable.create('pageItemList',{ghosting:true});
			
		}
		this.validate = function(itm) {
			if (itm.title == "" || itm.content == ""){
				alert("Both a Title and Content are required");
				return false;
			}
			return true;
		}
	}

	function FormMgr() {
		this.show = function(data) {
			this.items = items;
		}
		this.startadd = function() {
			$('frmTitle').value = "";
			$('frmContent').value = "";
			tinyMCE.activeEditor.setContent('');

			$('id').linkRef = "";	
		}
		this.saveItem = function() {
			var mitem = new Object();
			tinyMCE.triggerSave()
			mitem.title = $('frmTitle').value;
			mitem.content = $('frmContent').value;
			
			if (!itemList.validate(mitem)) return;
			

			if (typeof($('id').linkRef) == 'object'){
				itemList.editItm(mitem);
				$('msg2').innerHTML = "Item \""+mitem.title+"\" Updated";
			} else {
				itemList.addItm(mitem);
				$('msg2').innerHTML = "Item \""+mitem.title+"\" Added";
				this.startadd();
			}
		}
		this.startedit = function(itm) {
			$('frmTitle').value = itm.innerHTML.replace("&amp;","&");
			$('frmContent').value = itm.content;
			tinyMCE.activeEditor.setContent(itm.content);
			$('id').linkRef = itm;
		}
	}

	myFormMgr = new FormMgr();
	
	itemList = new Items();
	itemList.init(<cfoutput>#replace(lcl.itemsJson,"&amp;","&","all")#</cfoutput>);
	window.resizeTo(880, 620);
</script>