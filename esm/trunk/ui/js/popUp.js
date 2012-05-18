function reloadbase(){
	//test to see if iframe or fullscreen
	try {
		var m = window.opener.parent.frames[0]['reloadframe'];
		if (m)	var isFullScreen = 1;
		else var isFullScreen = 0;
	} catch(e){
		var isFullScreen = 0;
	}
		
	if (isFullScreen) {
		//for full size 
		window.opener.parent.frames[0]['reloadframe']('same','same');
	} else {
		//for iframe	
		try
		{	//ff iframe
			window.opener.location.reload();
		}
		catch(e)
		{
			//ie iframe
			/*
				This beats stupid IE!!!
				IE with throw a permission denied error on the above line of code
				b/c the site and spireESM are likely on different domains.
				The hack below sees through this ploy by accessing the parent
				document of the iframe and then "reset" the iframe's source
				which causes a reload all the same.
			*/
	
			var iframeElement = window.opener.parent.document.getElementsByTagName('iframe')[0];
			iframeElement.setAttribute('src', iframeElement.getAttribute('src'));
		}
	}
	
	window.close();
	window.close();


}