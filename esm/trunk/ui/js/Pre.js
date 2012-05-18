/// Preloader Class
///	Written By: Matthew Gaddis <matthew_gaddis@yahoo.com>
/// Created: 200-01-07

var Pre = 
{
	debug: true,
	require: function(scriptName)
	{
		document.write('<script type="text/javascript" src="' + scriptName + '"></script>');	
	},
	load: function()
	{
		var nodeListScript = document.getElementsByTagName("script");
		var i = 0;
		var path = null;
		for(i = 0; i < nodeListScript.length; i++)
		{
			//alert(nodeListScript[i].src);
			if(nodeListScript[i].src.match(/Pre\.js$/))
			{
				path = nodeListScript[i].src.replace(/Pre.\js$/,'');
				
				if(this.debug && typeof Trace == 'undefined') this.require(path + 'Trace.js');
				//if(typeof FormUtil == 'undefined') this.require(path + 'FormUtil.js');
				//if(typeof Validate == 'undefined') this.require(path + 'Validate.js');
				//if(typeof PostBack == 'undefined') this.require(path + 'PostBack.js');
				if(typeof Prototype == 'undefined'){ this.require(path + 'prototype.js'); }
				if(typeof APP == 'undefined'){ this.require(path + 'APP.js');}
				if(typeof ExternalLinks == 'undefined'){ this.require(path + 'ExternalLinks.js');}
				this.require(path + 'esmutilities.js');
				break;
				
				this.meditate
				(
					 function()
					 {
						 Event.observe(window, 'unload', Event.unloadCache, false);
					 }
				 );  
			}
		}
	},
	meditate: function(f)
	{
		var m=window.onload;
		window.onload=function(){ if(m)m(); f(); }
	}
}

Pre.load();



