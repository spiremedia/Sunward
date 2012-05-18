/***********************************************
* IFrame SSI script II- © Dynamic Drive DHTML code library (http://www.dynamicdrive.com)
* Visit DynamicDrive.com for hundreds of original DHTML scripts
* This notice must stay intact for legal use
***********************************************/


//Number of pixels to be added at the bottom of the page in case it does not fit properly.
var extraHeight = 50; 

// Variables to activate/deactivate the automatic resize
var automaticResize = false;

// Variables to activate/deactivate the automatic scroll to the top of the page on load
var scrollToTop = false;
var scrollToTopX = 0;
var scrollToTopY = 0;

//Set the domain
//document.domain = 'fpanet.org';

//Input the IDs of the IFRAMES you wish to dynamically resize to match its content height:
//Separate each ID with a comma. Examples: ["myframe1", "myframe2"] or ["myframe"] or [] for none:
var iframeids = ["ISGwebContainer"];

//Should script hide iframe from browsers that don't support this script (non IE5+/NS6+ browsers. Recommended):
var iframehide = "yes"

var getFFVersion = navigator.userAgent.substring(navigator.userAgent.indexOf("Firefox")).split("/")[1]
var FFextraWidth = parseFloat(getFFVersion) >= 0.1 ? 16 : 0		//extra width in px to add to iframe in FireFox 1.0+ browsers
var FFextraHeight = parseFloat(getFFVersion) >= 0.1 ? 16 : 0	//extra height in px to add to iframe in FireFox 1.0+ browsers

function IFrameSettings(autoResize, autoScrollToTop, autoScrollToTopX, autoScrollToTopY)
{
	automaticResize = autoResize;	
	if (autoScrollToTop)
	{
	    scrollToTop = autoScrollToTop;
	}
	if (autoScrollToTopX)
	{
	    scrollToTopX = autoScrollToTopX;
	}
	if (autoScrollToTopY)
	{
	    scrollToTopY = autoScrollToTopY;
	}
}

function resizeCaller() 
{
	var dyniframe = new Array()

    try {
	    for (i = 0; i < iframeids.length; i++)
	    {
		    if (document.getElementById)
			    resizeIframe(iframeids[i])
    		
		    //reveal iframe for lower end browsers? (see var above):
		    if ((document.all || document.getElementById) && iframehide == "no")
		    {
			    var tempobj = document.all ? document.all[iframeids[i]] : document.getElementById(iframeids[i])
			    tempobj.style.display = "block"
		    }
	    }
	}
	catch(err) {}
}


function resizeIframe(frameid)
{
	var currentfr = document.getElementById(frameid)

	try {
	    if (currentfr && !window.opera)
	    {
		    currentfr.style.display = "block"
		    currentfr.width = "100%"
		    //currentfr.width = "1000"
    		
		    if (automaticResize)
		    {
		    	try {	    
			        if (currentfr.contentDocument && currentfr.contentDocument.body.offsetHeight)	//ns6 syntax
			        {
				        currentfr.height = currentfr.contentDocument.body.offsetHeight + FFextraHeight + extraHeight; 
				        currentfr.width = currentfr.contentDocument.body.scrollWidth;				    
    				  
                    }
			        else if (currentfr.Document && currentfr.Document.body.scrollHeight)			//ie5+ syntax
			        { 
				        currentfr.height = currentfr.Document.body.scrollHeight + extraHeight; 
    				    
				        if (currentfr.Document.body.offsetWidth <= currentfr.Document.body.scrollWidth)
				        {
				            currentfr.width = currentfr.Document.body.scrollWidth;				    
				        }	
    				    
			        }
			    } catch (err) {
			        currentfr.scrolling = "auto";
			        currentfr.height = "100%";
			        currentfr.width = "100%";
			    }			    
		    }	
    		
		    if (currentfr.addEventListener)
		    {		    
			    currentfr.addEventListener("load", readjustIframe, false)
			    window.addEventListener("resize", readjustIframe, false) 
			    
			    if (scrollToTop)
	            {
			        currentfr.addEventListener("load", scrollToPageTop, false)
			    }
			}
		    else if (currentfr.attachEvent)
		    {
			    currentfr.detachEvent("onload", readjustIframe)	// Bug fix line
			    currentfr.attachEvent("onload", readjustIframe)
			    
			    window.detachEvent("onresize", resizeCaller)
	            window.attachEvent("onresize", resizeCaller)  	
	            
	            if (scrollToTop)
	            {
	                currentfr.detachEvent("onload", scrollToPageTop)
	                currentfr.attachEvent("onload", scrollToPageTop)  	            
	            }
	          
		    }
		   
	    }
	} catch(err){}
}

function pageWidth() 
{
    return window.innerWidth != null? window.innerWidth : document.documentElement && document.documentElement.clientWidth ?       document.documentElement.clientWidth : document.body != null ? document.body.clientWidth : null;
} 

function readjustIframe(loadevt)
{
	var crossevt = (window.event) ? event : loadevt
	var iframeroot = (crossevt.currentTarget) ? crossevt.currentTarget : crossevt.srcElement
	
	if (iframeroot)
		resizeIframe(iframeroot.id);
		
	
}

function loadintoIframe(iframeid, url)
{
	if (document.getElementById)
		document.getElementById(iframeid).src = url
}

function scrollToPageTop()
{
    window.scrollTo(scrollToTopX, scrollToTopY);
}

// Main code
if (window.addEventListener)
{
	window.addEventListener("load", resizeCaller, false)
	window.addEventListener("resize", resizeCaller, false) 
	/*
	if (scrollToTop)
	{
	    window.addEventListener("load", scrollToPageTop, false);
	}
	*/
}
else if (window.attachEvent)
{
	window.attachEvent("onload", resizeCaller)	
	window.attachEvent("onResize", resizeCaller) 
	/*
	if (scrollToTop)
	{
	    window.attachEvent("onload", scrollToPageTop);
	}
	*/
}
else
{
	window.onload = resizeCaller 	
	window.onResize = resizeCaller
	/*
	if (scrollToTop)
	{
	    window.onload += scrollToPageTop;
	}*/
}
