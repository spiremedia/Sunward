/****
*		Hired Gun: Matthew Gaddis <matthew@spiremedia.com>
*		Created: 2006-01-31
*		File: Platform2006 JS Prototype JavaScript PostBack
****/

var PostBack = 
{
	f: document.createElement('form'),
	h: document.createElement('input'),
	UrlRegEx: /[^\?]+[\?]*page=([^&]*)/i,
	load: function()
	{
		///
		///	Have to use PostBack references in this function
		/// because it is loaded in the Pre.pushOnload 
		/// and becomes disassociated from 'this'
		///
		var a = document.getElementsByTagName('a');
		var i = 0;
		if(a.length > 0)
		{
			for(i; i < a.length; i++)
			{
				if(PostBack.UrlRegEx.test(a[i].getAttribute('href')))
				{
					a[i].onclick = function() { return PostBack.post( this.getAttribute('href').replace(PostBack.UrlRegEx, "$1")); };
					//a[i].setAttribute('href', a[i].getAttribute('href').replace(pageRegEx, ''));
				} 
			}
			
			PostBack.f.setAttribute('action', 'prototype/');
			PostBack.f.setAttribute('method', 'post');
			PostBack.h.setAttribute('type', 'hidden');
			PostBack.h.setAttribute('name', 'page');
			PostBack.f.appendChild(PostBack.h);
			document.getElementsByTagName('body')[0].appendChild(PostBack.f);
		}
	},

	post: function(v)
	{
		if(typeof FormUtil != 'undefined' && this.h && this.f)
		{
			this.h.setAttribute('value', v);
			this.f.submit();
			return false;
		}
	}
};

Pre.meditate(PostBack.load);

