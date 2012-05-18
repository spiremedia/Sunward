/****
*		Hired Gun: Matthew Gaddis <matthew@spiremedia.com>
*		Created: 2006-04-26
*		File: Platform2006 JS JavaScript Browser UI
*		Requires: prototype 1.5.0 or greater
****/

var Browser = {};
Browser.Base = function() {};

Browser.Base.prototype = 
{
	baseInitialize: function(element, update, toggle, options)
	{
		var list, span;
		
		this.element = $(element);
		this.update = $(update);
		this.toggle = $(toggle);
		
		if (this.setOptions)
			this.setOptions(options);
		else
			this.options = options || {};
		
		this.options.onclick = this.options.onclick ||
		function(event)
		{
			document.onclick = null;
			// ORIGINAL CODE DON'T REMOVE
			var a = Event.findElement(event, 'A');
			this.element.value = $A(a.getElementsByTagName('span')).first().innerHTML;
			Effect.toggle(this.update, 'appear', {duration: 0.15});
			return false;
		};
		
		list = $A(this.update.getElementsByTagName('a'));
		
		for(var i = 0; i < list.length; i++)
		{
			if(! $( list[i] ).hasClassName('disabled') )
			{
				span = list[i].getElementsByTagName('span');
				
				if ( span.length > 0 && span[0].className == 'informal' )
				{
					Event.observe(list[i], 'click', this.options.onclick.bindAsEventListener(this));
					///
					/// Needed b/c of Safari Safari 2.0.3 bug::
					/// http://particletree.com/notebook/eventstop/
					///
					list[i].onclick = function(e) { return false; }
				}
			}
		}
		
		this.toggle.onclick = this.onToggle.bindAsEventListener(this);
		
	},
	onToggle: function(event)
	{
		try {
			document.closeOpenMenus = true;
			document.onclick();
		} catch(e) {
			// document.onclick() may not be a function
		} finally {
			document.closeOpenMenus = null;
		}
		if (Element.visible(this.update)) {
			// Menu is open and being toggled closed; remove the event observer
			document.onclick = null;
		} else {
			// Menu is closed and being toggled open; add the event observer
			document.onclick = this.onDocumentClick.bindAsEventListener(this);
		}
		
		// ORIGINAL CODE DON'T REMOVE
		Effect.toggle(this.update, 'appear', {duration: 0.15});
		return false;
	},
	onDocumentClick: function(event)
	{
		var clickWithinBrowser = false;
		
		// event may be undefined if another control is forcing this to close
		if (event != undefined) {
			var elem = Event.element(event);
			do {
				// Check to see if the click happpened on the Browser or toggle item
				try {
					if (elem.className == "browser" || elem == this.toggle) {
						clickWithinBrowser = true;
						break;
					}
				} catch(e) {
					// Node doesn't have a className attribute, dismiss the error
				}
				elem = elem.parentNode;
			}
			while(elem.nodeName != "#document")
		}
		
		if (!clickWithinBrowser || document.closeOpenMenus == true) {
			document.onclick = null;
			Effect.toggle(this.update, 'appear', {duration: 0.15});
		}
	}
};

Browser.Accordion = Class.create();
Browser.Accordion.prototype = Object.extend
(
 	new Browser.Base(), 
	{
		initialize: function(element, update, toggle, options) 
		{
			this.baseInitialize(element, update, toggle, options);
		}
	}
);
