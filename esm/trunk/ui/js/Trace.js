///	Trace Class (for debugging)
///	Written By Matthew Gaddis <matthew_gaddis@yahoo.com>
///	Created 2005-01-08

var Trace = 
{
	e: null,
	n: 'trace',
	out: function(strOut)
	{
		if(!this.e)
			this.e = document.getElementById(this.n);
		
		if(this.e)
			this.e.innerHTML += strOut + '<br>';
	},
	flush: function()
	{
		if(this.e)
			this.e.innerHTML = '';
	}
}