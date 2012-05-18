<cfoutput>
<cfcontent reset="yes"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<!-- template made in forms -->
<head>
    <LINK rel="stylesheet" href="/ui/css/layout.css" type="text/css" />
	<LINK rel="stylesheet" href="/ui/css/typo.css" type="text/css" />
	<LINK rel="stylesheet" href="/ui/css/nav.css" type="text/css" />
	<LINK rel="stylesheet" href="/ui/css/form.css" type="text/css" />
	<LINK rel="stylesheet" href="/ui/css/print.css" type="text/css" media="print" />
	<script src="/ui/js/jquery-1.2.6.pack.js"></script>
</head>

<body class="blank">
	<div id="content" class="clearfix">

		&nbsp;<input class="contentObjectMarker" type="hidden" name="mainContent" value='#variables.formid#'>
		
		#variables.definition#

	</div><!-- end content -->

</body>
</html>

<!---><script type="text/javascript">
	//if(parent != window)
	//{
		new editBlock.ESM
		('#variables.requestObject.getVar('cmslocation')#forms/editFormWizard/?id=#variables.formid#');
	//}--->
	
	<link rel="stylesheet" href="/ui/esm/esm.css" />
	<script src="/ui/esm/jquery.esmclick.js"></script>
	<script type="text/javascript">
		$(function(){ 
			$('a').click(function(){return false});
			$('.contentObjectMarker').parent().hover(function(){
				$(this).addClass("contentObject-edit");
			},function(){
				$(this).removeClass("contentObject-edit");
			});
			<cfoutput>$('.contentObjectMarker').esmclick({link:'#variables.requestObject.getVar('cmslocation')#forms/editFormWizard/?id=#variables.formid#'});</cfoutput>
		});  
	</script>



</cfoutput>