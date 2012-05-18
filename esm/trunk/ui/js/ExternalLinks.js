var ExternalLinks =
{
	a: [],
	init: function()
	{
		ExternalLinks.a = $A(document.getElementsByTagName('a'));
		ExternalLinks.a.each( function(e) { if(e.getAttribute('href') && e.getAttribute('rel') == 'external') e.target = '_blank'; } );
	},
	newWindow: function(url, ht, wt)
	{
		
		var popupWin = window.open 
		( 
		 	url, 
			null,
			'width=' + wt + 
			',height=' + ht +
			',toolbar=1,resizable=1,scrollbars=1,screenX=0,screenY=0,top=0,left=1'
		);
		return false;
	}
}

Pre.meditate(ExternalLinks.init);