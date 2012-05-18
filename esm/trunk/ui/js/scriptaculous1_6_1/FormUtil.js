/****
*		Hired Gun: Matthew Gaddis <matthew@spiremedia.com>
*		Created: 2006-01-31
*		File: Platform2006 JS Prototype JavaScript Form Utils
****/

var FormUtil = 
{
	getForm: function(e)
	{
		var f = e.parentNode;
		while(f.tagName != 'FORM' && f.parentNode) f = f.parentNode;
		return f;
	}
};