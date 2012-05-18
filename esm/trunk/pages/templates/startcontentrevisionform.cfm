<cfset lcl.publishedpageslist = getDataItem('publishedpageslist')>
<cfset lcl.availablepages = getDataItem('availablepages')>
<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.infoarray = arraynew(1)>
<cfloop query="lcl.publishedpageslist">
	<cfset arrayappend(lcl.infoarray,fname & ' ' & lname & ' /' & urlpath & ' ' & dateformat(publisheddatetime, "mm/dd/yy") & ' ' & timeformat(publisheddatetime, "hh:mm tt"))>
</cfloop>
<cfset queryaddcolumn(lcl.publishedpageslist,'info', lcl.infoarray)>
<cfset lcl.form.startform()>
<cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.publishedpageslist>
<cfset lcl.options.addblank = true>
<cfset lcl.options.blanktext = "Choose">
<cfset lcl.options.labelskey = 'info'>
<cfset lcl.options.valueskey = 'id'>
<cfset lcl.form.addformitem('publishedPageArchiveId', '', true, 'select', "", lcl.options)>
<cfset lcl.form.endform()>

<style>
	div.steps {
		margin:0 0 10px 0;
	}
	div.steps h1 {
		font-size:11px;
	}
	div.steps div#oldcontent {
		border:1px solid gray;
		padding:10px;
	}
</style>

<div class="steps">
<h1>Step 1 : Find the publishing activity that you wish to retrieve content from:</h1>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
</div>


<div class="steps" id="step2" style="display:none;">
<h1>Step 2 : Select the content to retrive by choosing the spot on the template that contained the content and the module that contained it. </h1>
<div id="availableitemsdiv"></div> 
</div>


<div class="steps" id="step3" style="display:none;">
<h1>Step 3 : Validate that this is the correct content to retrieve.</h1>
<div id="oldcontent"></div>  
<input type="hidden" name="revertableContentId">
<input type="button" value="Yes this is correct." onclick="isrightcontent()">
<input type="button" value="No, this is not." onclick="notrightcontent()">
</div>

<cfset lcl.form = createWidget("formcreator")>
<cfset lcl.form.startform()>
<cfset lcl.options = structnew()>
<cfset lcl.options.options = lcl.availablePages>
<cfset lcl.options.addblank = true>
<cfset lcl.options.blanktext = "Choose">
<cfset lcl.options.labelskey = 'pagename'>
<cfset lcl.options.valueskey = 'id'>
<cfset lcl.form.addformitem('targetpageid', 'Choose an active Page', true, 'select', "", lcl.options)>
<cfset lcl.form.endform()>

<div class="steps" id="step4"  style="display:none;">
<h1>Step 4 : Choose the page that you wish this content to be reverted to:</h1>
<cfoutput>#lcl.form.showHTML()#</cfoutput>
<div id="step4message"></div>
</div>

<input type="hidden" name="revertableContentId">
<div class="steps" id="step5" style="display:none;">
<h1>Step 5 : Identify the spot in the template that you wish this to revert the content to:</h1>
<div id="targetRecipientList"></div>
</div>

<input type="hidden" name="targetContentObjectName">
<input type="hidden" name="targetMemberType">
<div class="steps" id="step6" style="display:none;">
<h1>Step 6 : Confirm that you wish to overwrite the existing content with the previous:</h1>
<input type="button" value="Yes! Overwrite the content." onclick="revertContent();">
<span id="resultsMessage"></span>
</div>


<script>
	function availableitems(s){
		var items = s.ITEMS;
		var s = items.length + " Revertible Items Were Found for this Published Item.<br><ul>";
		for (var i = 0; i < items.length; i++){
			s+= "<li>";
			s+= "Module : \"" + items[i].MODULE + "\" Template Spot :  \"" + items[i].TEMPLATESPOT + "\" ";
			if (items[i].MEMBERTYPE != 'default') s+= "MemberType : \"" + items[i].MEMBERTYPE + "\" ";
			s+= " <a href='' onclick=\"loadContentHTML('" + items[i].ID + "');return false;\">Choose</a> ";
			s+= "</li>";
		}
		s+= "</ul>";
		$('step2').style.display = 'block';
		$('availableitemsdiv').innerHTML = s;
	}
	function submitPageForm(){
		if (document.myForm.publishedPageArchiveId.selectedIndex == 0) return;
		submitAjaxForm();
	}
	function loadContentHTML(id){
		var s = new Object();
		s.ID = 'oldcontent';
		document.myForm.revertableContentId.value = id;
		s.URL = '/pages/showRevertableContent/?id=' + id;
		$('step3').style.display = 'block';
		$('oldcontent').innerHTML = s.URL;
		$('oldcontent').innerHTML = 'Loading';
		$('step4').style.display = 'none';
		$('step5').style.display = 'none';
		$('step6').style.display = 'none';
		$('step4message').innerHTML = "";
		ajaxupdater(s);
	}
	function notrightcontent(){
		$('oldcontent').innerHTML = '';
		$('step3').style.display = 'none';
		$('step4').style.display = 'none';	
		$('step5').style.display = 'none';
		$('step6').style.display = 'none';
	}
	function isrightcontent(){
		$('step4').style.display = 'block';
	}
	function getTargetPageOptions(){
		if (document.myForm.targetpageid.selectedIndex == 0) return;
		
		var s = 'revertibleId=' + document.myForm.revertableContentId.value;
		s += '&targetPageId=' + document.myForm.targetpageid.value;
		$('dump').innerHTML = '/pages/getRevertibleTargetList/?' + s;
		ajaxWResponseJsCaller('/pages/getRevertibleTargetList/', s);
	}
	function targetoptions(m){
		if (m.length == 0){
			$('step4message').innerHTML = 'There are no options available on that page that can accomodate this type of module.  For instance, if you want to revert a DHTML Pager, the target page must have a spot that can accept a DHTML Pager. ';
			$('targetRecipientList').innerHTML = "";
			return;
		}
		var s = "Note that any content that is currently in this spot will be overwritten. <ul>";
		for (var i = 0; i < m.length; i++){ 
			s+= "<li>Spot : \"" + m[i].NAME + "\"";
			if (m[i].MEMBERTYPE != 'default') s+= ", membertype : \"" + m[i].MEMBERTYPE+ "\" ";
			s+= " <a href='' onclick=\"chooseTargetItem('" + m[i].NAME + "','" + m[i].MEMBERTYPE + "'); return false;\">Choose</a></li>";
		}
		s += "</ul>";

		$('step5').style.display = 'block';
		$('targetRecipientList').innerHTML = s;
		$('step4message').innerHTML = "";
	}
	function chooseTargetItem(spotName, memberType){
		
		document.myForm.targetContentObjectName.value = spotName;
		document.myForm.targetMemberType.value = memberType;
	
		$('step6').style.display = 'block';
		return false;
	}
	function revertContent(){
		var s = 'revertibleId=' + document.myForm.revertableContentId.value;
		s += '&targetPageId=' + document.myForm.targetpageid.value;
		s += '&targetContentObjectName=' + document.myForm.targetContentObjectName.value;
		s += '&publishedPageArchiveId=' + document.myForm.publishedPageArchiveId.value;
		s += '&targetMemberType=' + document.myForm.targetMemberType.value;
		ajaxWResponseJsCaller('/pages/revertContentAction/', s);
	}
	function revertcontentrslt(status){
		if (status)
			$('resultsMessage').innerHTML = "Success! <a href='/pages/editPage/?id=" + document.myForm.targetpageid.value + "'>Continue to the page</a>."
		else
			$('resultsMessage').innerHTML = "There was an issue. Either use the view screen to copy and paste your content or contact your technical department.";
	}
	
	document.myForm.publishedPageArchiveId.onchange = submitPageForm;
	document.myForm.targetpageid.onchange = getTargetPageOptions;
</script>


