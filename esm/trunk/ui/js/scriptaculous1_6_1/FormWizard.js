/*////////////////////////////////////
///	Class:			Form Wizard Object for 2006 Platform
/// Hired Gun: 		Matthew Gaddis <matthew@spiremedia.com>
/// Written:		2006-03-30
/// Dependancies:	/ui/js/prototype.js 		version: 1.5 or greater
///					/ui/js/controls.js			version: scriptacolous 1.6.0 or greater
///					/ui/js/dragdrop.js			version: scriptacolous 1.6.0 or greater
///					/ui/js/effects.js			version: scriptacolous 1.6.0 or greater
/*/////////////////////////////////////

var FormWizard =
{
	c: null, //cloned node placeholder,
	e: {}, //will be an object of the elements (by id): 'toolbar', 'palette', 'howmany'
	id: 
	[
		'toolbar', //ui control
		'palette', //ui control
		'howmany_checkbox', //ui control
		'howmany_radio', //ui control
		'savebutton', //form submit button
		'palette_container', //ui control content object definition container
		'definition' //form variable content object definition 
	],
	n: null,
	s: 
	{
		length: 0
	},
	ELEMENT_NODE: 1,
	init: function()
	{
		FormWizard.id.each ( function(e) { FormWizard.e[e] = $(e); } );
		FormWizard.loadPalette();
		
		/*/
		///
		/// Init FormWizard save action: 
		/// onclick Event Handler attached to input[id=savebutton]
		///		Event Handler Responsibilities::
		///		1. cycle through all inplaceeditors and turn them off as necessary
		///		2. input[id=definition].value = div[id=palette_container].innerHtml
		///	
		/*/
		
		FormWizard.e.savebutton.onclick = function()
		{
			FormWizard.disposeInPlaceEditors();
			
			///
			/// Browser input[type=checkbox] support is lame
			/// this iteration evaluates each checkbox (required fields) and
			/// sets or removes the checked attribute depending on whether
			/// the input.check is true
			///
			var inputs = FormWizard.e.palette.getElementsByTagName('input');
			for(var i = 0; i < inputs.length; i++)
			{
				if
				(
				   inputs[i].getAttribute('type') == 'checkbox'
				   &&
				   inputs[i].checked
				 )
					inputs[i].setAttribute('checked', 'checked');
				else
					inputs[i].removeAttribute('checked');
			}
			
			inputs = null;
			
			FormWizard.e.definition.value = FormWizard.e.palette_container.innerHTML;
			
			return true;
		}
	},
	delayedPaletteReload: function()
	{
		/* 
		this value has to be greater than 
		the timeout for the toolbarSortableOnUpdateEventHandler
		*/
		setTimeout('FormWizard.loadPalette()', 200);
	},
	delayedToolbarSortableOnUpdateEventHandler: function()
	{
		setTimeout('FormWizard.toolbarSortableOnUpdateEventHandler()', 10);
	},
	disposeInPlaceEditors: function()
	{
		
		for(var InPlaceEditor in FormWizard.s)
		{
			if ( typeof FormWizard.s[InPlaceEditor] == 'object' && FormWizard.s[InPlaceEditor] != null ) 
			{
				FormWizard.s[InPlaceEditor].dispose();
			}
		}
		
		FormWizard.s = {length: 0};
		
		var spanElements = FormWizard.e.palette.getElementsByTagName('span');
		
		for (var i = 0; i < spanElements.length; i++ ) { spanElements[i].removeAttribute('id'); }
	},
	loadPalette: function()
	{
		
		/*/
		/// UI Palette Structure::
			<ul id="palette">
				<li>
					<p>
						Make Required: <input type="checkbox" name="required" value="true" title="Is this field required?" />
						<br /><br />
						<a href="[this.path]" class="remove" title="Remove?"><img src="/images/button/delete.gif" alt="" /></a>
					</p>
					<dl>
						<dt><span>[label here]</span></dt>
						<dd>
							<img src="/images/formwizard/text.gif" alt="" />
						</dd>
					</dl>
					<div class="clear"><!--Leave Empty--></div>
				</li>
				....
			</ul>
			
			ui[id=palette]: Scriptaculous Sortable on LI elements
			1. Palette can be empty
			2. Palette can receive elements from toolbar
			3. Palette can be reordered
			4. When Palette is updated with new elements from toolbar it is reloaded as a Sortable
				
		///
		/*/
		
		FormWizard.loadToolBar();
		
		Sortable.destroy(FormWizard.e.palette);
		
		Sortable.create
		(
			FormWizard.e.palette, 
			{
				containment: [FormWizard.e.toolbar.id, FormWizard.e.palette.id], 
				dropOnEmpty: true,
				onUpdate: FormWizard.delayedPaletteReload,
				handle: 'handle'
			}
		);
		
		var liElements = FormWizard.e.palette.getElementsByTagName('li');
		for ( var i = 0; i < liElements.length; i++ )
		{
			///
			/// mouse events from toolbar must be reset
			///
			liElements[i].onmousedown = null;
			
			/*/
			/// Each LI contains at least 1 A element
			///	1. Remove Button
			///	Remaining elements come in two varieties
			/// 2. a[class=addvalue] - Select Box Option for Adding a new Option value
			/// 3. a[class=removevalue] - Select Box Option for Removing a Option value
			/*/ 
			
			var aElements = liElements[i].getElementsByTagName('a');
			
			for ( var j = 0; j < aElements.length; j++ )
			{
				var a = $(aElements[j]);
						
				//remove button
				if(j == 0)
				{
					a.onclick = function() 
					{ 
						if(confirm(ExternalValues.deleteConfirmMessage))
						{
							var li = this.parentNode;
							while(li != null && li.nodeType == FormWizard.ELEMENT_NODE && li.nodeName != 'LI') li = li.parentNode;
							
							if(li != null && li.nodeType == FormWizard.ELEMENT_NODE && li.nodeName == 'LI')
								li.parentNode.removeChild(li);
								
							FormWizard.loadInPlaceEditors();
						}
						return false;
					}
				}
				
				//add value button
				else if ( Element.hasClassName ( a, 'addvalue' ) )
				{
					SelectBoxOption.setAddEventHandler(a);
				}
				
				//remove value button
				else if(Element.hasClassName ( a, 'removevalue' ) )
				{
					SelectBoxOption.setRemoveEventHandler(a);
				}
			}
		}
		
		FormWizard.loadInPlaceEditors();
	},
	
	loadToolBar: function()
	{
		
		Sortable.destroy(FormWizard.e.toolbar);
		
		Sortable.create
		(
			FormWizard.e.toolbar, 
			{
				dropOnEmpty: false, 
				constraint: false,
				ghosting: true,
				onUpdate: FormWizard.delayedToolbarSortableOnUpdateEventHandler
			}
		);
		
		var liElements = FormWizard.e.toolbar.getElementsByTagName('li');
		
		for ( var i = 0; i < liElements.length; i++ )
		{
			liElements[i].onmousedown = function()
			{
				FormWizard.c = this;
				FormWizard.n = this.nextSibling;
			}
		}
	},
	
	loadInPlaceEditor: function(e)
	{
		if
		(
		 	e.getAttribute('id') == null
			||
			e.getAttribute('id') == ''
		)
		{
			e.setAttribute('id', ('id' + FormWizard.s.length++));
		}
		
		if
		(
		 	typeof FormWizard.s[e.id] == 'undefined'
		)
		{
			FormWizard.s[e.id] = new Ajax.InPlaceEditor
			( 
				e, 
				ExternalValues.Ajax_InPlaceTextEditorUrl
			);
		}
	},
	loadInPlaceEditors: function()
	{
		FormWizard.disposeInPlaceEditors();
		
		var spanElements = FormWizard.e.palette.getElementsByTagName('span');
		
		for ( i = 0; i < spanElements.length; i++ ) { FormWizard.loadInPlaceEditor(spanElements[i]); }
	},
	toolbarSortableOnUpdateEventHandler: function(e)
	{
		if ( Element.childOf(FormWizard.c, FormWizard.e.palette ) )
		{
			var node = document.createElement('li');
			node.innerHTML = FormWizard.c.innerHTML;


			if(Element.hasClassName(FormWizard.c, 'multiple'))
			{
				
				Element.addClassName(node, 'multiple');
				
				var howManyElement = (FormWizard.c.getElementsByTagName('input'))[1];
				//Trace.out(howManyElement.value);
				if
				(
				 	! isNaN(howManyElement.value) && 
					parseInt(howManyElement.value) > 0
				)
				{
					var dd = (FormWizard.c.getElementsByTagName('dd'))[0];
					var ddInnerHTML = dd.innerHTML;
					
					for(var i = 1; i < parseInt(howManyElement.value); i++) dd.innerHTML += ddInnerHTML;
				}
			}

			node = (FormWizard.n != null) ?
					FormWizard.e.toolbar.insertBefore ( node, FormWizard.n) :
					FormWizard.e.toolbar.appendChild(node);
		}
		
		FormWizard.c = FormWizard.n = node = null;
	}
};


var SelectBoxOption =
{
	setAddEventHandler: function(e)
	{
		e.onclick = function()
		{
			var a, div, divClone, span;
			
			div = this.parentNode;
			
			while(div != null && div.nodeType == FormWizard.ELEMENT_NODE && div.nodeName != 'DIV') div = div.parentNode;
			
			if(div != null && div.nodeType == FormWizard.ELEMENT_NODE && div.nodeName == 'DIV')
			{
				///
				/// If This value is the first value in the select box list, the remove link needs to be 
				/// set to its remove state and behavior
				///
				a = $ ( $A( div.getElementsByTagName('a') ).last() );
				if ( Element.hasClassName ( a, 'disabled' ) )
				{
					SelectBoxOption.setRemoveEventHandler(a);
					Element.removeClassName(a, 'disabled');
				}
				
				///
				/// Setup New Node Process:
				/// 1. Clone This Node
				/// 2. Fine SPAN element 
				///		a. assign default text 
				///		b. invoke Ajax.InPlaceEditor 
				/// 3. Assign event handlers to anchor tags
				/// 4. Append clone to this node's parent
				//divClone = document.createElement('div');
				//divClone.innerHTML = div.innerHTML;
				
				divClone = div.cloneNode(true);
				span = document.createElement('span');
				divClone.replaceChild(span, (divClone.getElementsByTagName('span'))[0]);
				span.innerHTML = ExternalValues.ValueHere;
				FormWizard.loadInPlaceEditor(span);
				
				a = $A(divClone.getElementsByTagName('a'));
				SelectBoxOption.setAddEventHandler(a.first());
				SelectBoxOption.setRemoveEventHandler(a.last());
				div.parentNode.appendChild(divClone);
				
				div = divClone = null;
		
				FormWizard.loadInPlaceEditors();
				
			}
			return false;
		};
	},
	setRemoveEventHandler: function(e)
	{
		e.onclick = function()
		{
			var aElements, div, list, span, divParent;
			
			div = this.parentNode;
			while(div != null && div.nodeType == FormWizard.ELEMENT_NODE && div.nodeName != 'DIV') div = div.parentNode;
			
			if(div != null && div.nodeType == FormWizard.ELEMENT_NODE && div.nodeName == 'DIV')
			{				
				///
				///	Remove target option value
				///
				
				divParent = div.parentNode;
				divParent.removeChild(div);
				list = divParent.getElementsByTagName('div');
				
				if(list.length == 1)
				{
					aElements = list[0].getElementsByTagName('a');
					Element.addClassName(aElements[aElements.length - 1], 'disabled');
					aElements[aElements.length - 1].onclick = function() { return false; }
				}
		
				FormWizard.loadInPlaceEditors();
			}
			return false;
		};
	}
}


FormWizard.init();