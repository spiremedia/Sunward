/****
*		Hired Gun: Matthew Gaddis <matthew@spiremedia.com>
*		Created: 2006-01-31
*		File: Platform2006 JS Prototype JavaScript Form Validate
****/

var Validate = 
{
	f: null,
	status: function(e, src)
	{			
		var i = 0;
		var s = null;
		var sRegEx = /\-status/i;
		var pRegEx = /passed/i;
		var sSrc = '/images/formstatus/passed.gif';

		if(typeof FormUtil != 'undefined')
			this.f = FormUtil.getForm(e);

		if(src) sSrc = src;
		
		if(this.f)
		{
			s = this.f.getElementsByTagName('img');
			for(i; i < s.length; i++)
			{
				if(sRegEx.test(s[i].getAttribute('id')))
				{
					s[i].setAttribute('src', sSrc);
				}
			}
			if(pRegEx.test(sSrc))
				setTimeout('Validate.f.submit()', 1000);
		}
		return false;
	},
	clear: function(e)
	{
		if(e.value == 'Keywords')
			e.value = '';
		return false;
	}
};