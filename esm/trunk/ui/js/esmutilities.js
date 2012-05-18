

function ajaxWResponseJsCaller(url, serializedData ){
	addStopSign();
	var opt = {
	    postBody: serializedData + '&ajax=true',
	    // Handle successful response
	    onSuccess: responseJsCaller,
	    // Handle 404
	    on404: function(t) {
	        alert('Error 404: location "' + t.statusText + '" was not found.');
	    },
	    // Handle other errors
	    onFailure: function(t) {
	    	if ($('trace')) $('dump').innerHTML = t.responseText;
	        alert('Error ' + t.status + ' -- ' + t.statusText);
	    }
	}

	new Ajax.Request(url, opt);
	return false;
}
function responseJsCaller(t){
	removeStopSign();
	if (t.responseText == 'relogin') location.href='/login/loginForm/';
	//alert(t.responseText);
	//if (t.responseText.length() > 1000) $('trace').innerHTML = t.responseText;
	var jo = t.responseText.evalJSON();
	try{
		for (var z in jo) {
			window[z.toLowerCase()](jo[z]);
		}
	} catch(e){
		alert(e);
		$('dump').innerHTML = t.responseText;
	}
}
function clearvalidation(){
	//loop thru string and update all images to be checked.
	var errimgs = $$('.errorimages');
	for (var i = 0; i < errimgs.length; i++){
	  	errimgs[i].src = '/ui/css/images/passed.gif';
	}
}
function validation(d){
	//make string and show it in msg
	var htmlstring = "<ul>";
	for (var i = 0; i < d.length; i++){
	   htmlstring += "<li>" + d[i].TEXT + "</li>";
	}
	
	htmlstring += "</ul>";
	$('msg').innerHTML = htmlstring;
	
	clearvalidation();

	//loop thru string and update failed validation images
	for (var i = 0; i < d.length; i++){
	    if ($('valimg_' + d[i].FIELD)) $('valimg_' + d[i].FIELD).src = '/ui/css/images/error.gif';
	}
}
function message(m){
	//m = m.evalJSON();
	$('msg').innerHTML = m;	
}
function ajaxupdater(t){
	if (! $(t.ID)) alert('in ajaxupdater, element id "'+t.ID+'" was not found');
	new Ajax.Updater(t.ID, t.URL, {onComplete : reinitializewidgetjs});
}
function htmlupdater(t){
	if (! $(t.ID)) alert('in htmlupdater, element id "'+t.ID+'" was not found');
	$(t.ID).innerHTML = t.HTML;
}
function reinitializewidgetjs() {
	APP.Base.prototype.baseInitialize();	
}
function verify(txt, url){
	if (confirm(txt)) ajaxWResponseJsCaller(url,'');
}
function relocate(r){
	addStopSign();
	location.href = r;
}
function addStopSign(){
	var statusDiv = $("status");
	if (statusDiv) {
		var ch = statusDiv.childNodes;
		if (ch.length == 1) { 
			ch[0].src = '/ui/images/status/red.png';
		} else if (ch.length > 1){ 
			statusDiv.innerHTML += "<img src='/ui/images/status/red.png'/>";
		} else {
			alert('missing item in status');
		}	
	}
}
function removeStopSign(){
	var statusDiv = $("status");
	if (statusDiv){
		var ch = statusDiv.childNodes;
		if (ch.length == 1) { 
			ch[0].src = '/ui/images/status/green.png';
		} else if (ch.length > 1){
			var lastch = ch[ch.length -1];
			statusDiv.removeChild(lastch);
		} else {
			alert('missing item in status');
		}
	}
}
/*
function openWindow(url, width, height, name){	
	var NewWindow = window.open( url ,name , 'directories=0,height=' + height + ',width=' + width + ',location=0,menubar=0,toolbar=0,');
	NewWindow.focus();
}
*/
function openWindow(object){
	var url = '';
	var name = 'default';
	var features = [];
	 
	//set defaults 
	if(!object.directories) 
		features.push('directories=0');
	if(!object.location) 
		features.push('location=0');
	if(!object.menubar) 
		features.push('menubar=0');
	if(!object.toolbar) 
		features.push('toolbar=0');
	if(!object.scrollbars) 
		features.push('scrollbars=0');
	
	 for (var property in object)
	 {
		 switch(property) {
		  case 'url': 
			url = object[property];
			break; 
		  case 'name': 
			name = object[property];
			break; 
		  default: 
			features.push(property+'='+object[property]);
			break; 
		}
	 }
	var NewWindow = window.open( url, name, features.toString() ); 
	NewWindow.focus();
}
