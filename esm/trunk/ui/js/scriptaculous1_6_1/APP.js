/****
*		Hired Gun: Matthew Gaddis <matthew@spiremedia.com>
*		Created: 2006-02-01
*		Updated: 2006-07-21
*		File: Platform2006 JS JavaScript Accordion/Pager/Panel UI
*		Requires: prototype 1.5.0 or greater
****/

var APP = {};
APP.Base = function() {};

APP.Base.prototype = 
{
	baseInitialize: function(options)
	{
		this.ELEMENT_NODE = 1;
		this.CONTAINMENT_CLASSNAMES = ['accordion', 'pager', 'panels'];
		this.LINKELEMENTTAGNAME = 'A';
		this.hideStyles = { visibility: 'hidden', height: 0, overflow: 'hidden'};
		this.showStyles = { visibility: 'visible', height: 'auto', overflow: 'visible'};
		
		if (this.setOptions)
			this.setOptions(options);
		else
			this.options = options || {};
		
		this.options.state = this.options.state || 'selected';
		this.options.exclude = this.options.exclude || 'disabled';
		this.options.tag = this.options.tag || 'DT';
		this.options.tagSibling = this.options.tagSibling || 'DD';
		this.options.containment = this.options.containment || 'DL';
		this.options.onclick = this.options.onclick ||
		function(event)
		{
			var controlChildElements, dt, e, i;
			
			e = Event.element(event);
			while(e.tagName != this.options.tag && e) { e = $(e.parentNode); }
			
			if(e && ! e.hasClassName(this.options.exclude))
			{
				controlChildElements = $A(e.parentNode.childNodes);
				
				for ( i = 0; i < controlChildElements.length; i++ )
				{
					if 
					( 
						controlChildElements[i].nodeType == this.ELEMENT_NODE 
						&& 
						controlChildElements[i].tagName == this.options.tag 
					)
					{
						dt = $(controlChildElements[i]);
						
						if ( ! dt.hasClassName(this.options.exclude) )
						{
	
							if(e == dt)
							{
								switch (dt.parentNode.className)
								{
									case 'accordion':
			
										if ( dt.hasClassName(this.options.state) ) 
										{
											dt.removeClassName(this.options.state);
											this.hideNextElement(dt, this.options.tagSibling);
											//APP.removeClassNameOfNextElement(dt, 'dd', 'selected');
										} 
										else 
										{
											dt.addClassName(this.options.state);
											this.showNextElement(dt, this.options.tagSibling);
											//APP.addClassNameOfNextElement(e, 'dd', 'selected');
										}
			
										break;
										
									case 'pager':
									case 'panels':
										if( ! dt.hasClassName(this.options.state) )
										{
											dt.addClassName(this.options.state);
											this.showNextElement(dt, this.options.tagSibling);
											//this.addClassNameOfNextElement(dt, 'dd', 'selected');
											
											switch(dt.parentNode.className)
											{
												case 'panels':
													this.sizeSelectedPanel(dt);
													break;
											}
										}
										break;
								}
							}
							else
							{
								switch(dt.parentNode.className)
								{
									case 'pager':
									case 'panels':
										dt.removeClassName(this.options.state);
										this.hideNextElement(dt, this.options.tagSibling);
										//APP.removeClassNameOfNextElement(dt, 'dd', 'selected');
										break;
								}
							}
						}
					}
				}
			}
			Event.stop(event);
		};
		
		var buttonElement, buttonElements, containmentElements, linkElements, i, j, k;
		
		for ( i = 0; i < this.CONTAINMENT_CLASSNAMES.length; i++ )
		{
			containmentElements = $$(this.options.containment + '.' + this.CONTAINMENT_CLASSNAMES[i]);
			
			for ( j = 0; j < containmentElements.length; j++ )
			{
				buttonElements = containmentElements[j].childNodes;
				
				for( k = 0; k < buttonElements.length; k++ )
				{
					buttonElement = $(buttonElements[k]);
					if
					(
					 	buttonElement.nodeType == this.ELEMENT_NODE
						&&
						buttonElement.tagName == this.options.tag
						&&
						! buttonElement.hasClassName(this.options.exclude)
					)
					{
						Event.observe(buttonElement, 'click', this.options.onclick.bindAsEventListener(this));
					}
				}
			}
			
			///
			/// Bring the Link Elements to focus...
			///
			linkElements = $$
			(
			 	this.options.containment + '.' + 
				this.CONTAINMENT_CLASSNAMES[i] + ' ' + 
				this.LINKELEMENTTAGNAME + '.' + this.options.state
			);
			
			if ( linkElements.length == 1 )
			{
				linkElements[0].focus();
				linkElements[0].blur();
			}
			
		}
	},
	sizeSelectedPanel: function(e)
	{
		var height = Element.getDimensions(e).height;
		height += Element.getDimensions(this.getNextSiblingByTagName(e, this.options.tagSibling)).height;
		Element.setStyle(e.parentNode, {height: height + "px"});
	},
	getNextSiblingByTagName: function(e, tagName)
	{
		var n = e.nextSibling;
		while(n.nodeType != this.ELEMENT_NODE && n.tagName != tagName && n.nextSibling != null) n = n.nextSibling;
		return $(n);
	},
	addClassNameOfNextElement: function(e, tagName, className) { this.getNextSiblingByTagName(e, tagName).addClassName(className); },
	removeClassNameOfNextElement: function(e, tagName, className) { this.getNextSiblingByTagName(e, tagName).removeClassName(className); },
	hideNextElement: function(e, tagName) 
	{
		Element.hide ( this.getNextSiblingByTagName(e, tagName) );
	},
	showNextElement: function(e, tagName) 
	{ 
		Element.show ( this.getNextSiblingByTagName(e, tagName) );
	}
}

APP.Create = Class.create();
APP.Create.prototype = Object.extend
(
 	new APP.Base(), 
	{
		initialize: function(options) 
		{
			this.baseInitialize(options);
		}
	}
);