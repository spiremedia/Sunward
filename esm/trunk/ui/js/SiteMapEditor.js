/*////////////////////////////////////
///	Class:			Site Map Editor Object for 2006 Platform
/// Hired Gun: 		Matthew Gaddis <matthew@spiremedia.com>
/// Written:		2006-05-11
/// Dependancies:	/ui/js/prototype.js 		version: 1.5 or greater
///					/ui/js/controls.js			version: scriptacolous 1.6.0 or greater
///					/ui/js/dragdrop.js			version: scriptacolous 1.6.0 or greater
///					/ui/js/effects.js			version: scriptacolous 1.6.0 or greater
/*/////////////////////////////////////


var SiteMapEditor = 
{
	e: {},
	i: [
		'sitemap_section_ul', 
		'sitemap_sidebar_ul',
		'sitemap_ajax_form',
		'sitemap_ajax_order',
		'sitemap_ajax_id',
		'sitemap_ajax_method'
	],
	
	
	delayedInit: function()
	{		
		setTimeout('SiteMapEditor.loadSection()', 1500);
		setTimeout('SiteMapEditor.loadSidebar()', 1500);
	},
	
	
	init: function()
	{
		///
		/// 1. Set all elements of interest ( those in SiteMapEditor.i ) into SiteMapEditor.e
		/// 2. Initialize the sidebar sortable
		/// 3. Initialize the section sortable
		///
		
		var s = SiteMapEditor;
		
		// 1.
		$A(s.i).each ( function(e) { s.e[e] = $(e); } );
		// 2. 
		s.loadSidebar();
		// 3.
		s.loadSection();
	},
	
	loadSection: function()
	{
		
		
		Sortable.create
		(
			SiteMapEditor.e.sitemap_section_ul.id, 
			{
				containment: [SiteMapEditor.e.sitemap_section_ul.id, SiteMapEditor.e.sitemap_sidebar_ul.id], 
				constraint: false,
				dropOnEmpty: true,
				only: 'drag',
				handle: 'handle',
				onChange: SiteMapEditor.onChangeEventHandler,
				onUpdate: SiteMapEditor.onUpdateEventHandler
			}
		);
		
		//Trace.out('Sortable Created ' + SiteMapEditor.e.sitemap_section_ul.id);
		
		$A(SiteMapEditor.e.sitemap_section_ul.getElementsByTagName('a')).each
		( function(e) { e.onclick = function() { return true; } } );
		
		//Trace.out('Anchors Enabled ' + SiteMapEditor.e.sitemap_section_ul.id);
	},
	
	loadSidebar: function()
	{

		Sortable.create
		(
			SiteMapEditor.e.sitemap_sidebar_ul.id, 
			{
				containment: [SiteMapEditor.e.sitemap_section_ul.id],
				dropOnEmpty: true, 
				constraint: false,
				only: 'drag',
				handle: 'handle',
				onChange: SiteMapEditor.onChangeEventHandler,
				onUpdate: SiteMapEditor.onUpdateEventHandlerSidebar 
			}
		);
		
		//Trace.out('Sortable Created ' + SiteMapEditor.e.sitemap_sidebar_ul.id);
		
		$A(SiteMapEditor.e.sitemap_sidebar_ul.getElementsByTagName('a')).each
		( function(e) { e.onclick = function() { return false; }; Element.removeClassName ( e, 'alternate' ); } );
		
		//Trace.out('Anchors Disabled ' + SiteMapEditor.e.sitemap_sidebar_ul.id);
	},
	
	mouseupEventHandlerSet: null,
	
	onChangeEventHandler: function(e)
	{
		///
		/// This event handler is called when a sortable
		/// element is "picked up" and subsequently changed by dragging anywhere in the screen.
		/// 1. Only interested in capturing the element's id in the first call of this event handler
		/// so the mouseupEventHandler is set for this element specifically, the id is captured 
		/// 2. The element id is captured in SiteMap
		/// 3. Turn "off" the anchor tag for the duration of the drag action
		///
		
		//Trace.out('onchange check: ' + e.id);
		
		if(SiteMapEditor.mouseupEventHandlerSet != e)
		{
			// 1.
			//Event.observe(e, 'mouseup', SiteMapEditor.mouseupEventHandler, false);
			// 2.
			SiteMapEditor.mouseupEventHandlerSet = $(e);
			
			//Trace.out('onchange set: ' + e.id);
			
			// 3.
			//$A( e.getElementsByTagName('a') ).each ( function (a) { a = $(a); a.onclick = function() { return false; } } );
		}
	},
	
	onSuccess: function(r)
	{
		///
		/// Ok so there is a race condition here wherein the user drops an item in the 
		/// inactive pages list at which an ajax call is made to the server to update the sitemap
		/// this ajax call has onSuccess as its "onSuccess" event handler which writes content 
		/// to the same <ul> that is being dropped into. 
		/// The request can answer before the drop is complete and therefore will halt the drop action
		/// and leave the ui in a state of disarray. This is why the <ul> is updated on a setTimeout
		/// interval, it gives the drop action a chance to complete prior to answering the ajax 
		/// response.
		///
		
		
		
		SiteMapEditor.onSuccessContent = r.responseText;
		
		//Trace.out('Sidebar Content Received!');
		
		setTimeout('SiteMapEditor.e.sitemap_sidebar_ul.innerHTML += SiteMapEditor.onSuccessContent', 500);
		
		//Trace.out('Sidebar Content Set!');
	},
	
	onSuccessContent: null,
	
	onUpdateEventHandler: function(e)
	{
		var i = 0, order = 1, serializedForm, liElements;

		/*/
		///
		///	Ajax Calls via serialization of ajaxform. 
		/// basic rules here is to switch against the id of the element's parent container
		/// sitemap_section_ul: void renderDefaultView(siteid, smid, order, id)
		/// sitemap_sidebar_ul: string renderInactivePagesView(siteid, id)
		///
		/*/
		
		/*if(SiteMapEditor.mouseupEventHandlerSet != null)
		{
			Trace.out('onUpdateEventHandler ' + e.id + ' ' + Element.childOf ( SiteMapEditor.mouseupEventHandlerSet, SiteMapEditor.e.sitemap_section_ul ));
			Trace.out('onUpdateEventHandler ' + e.id + ' ' + Element.childOf ( SiteMapEditor.mouseupEventHandlerSet, SiteMapEditor.e.sitemap_sidebar_ul ));
		}*/

		if 
		( 
			SiteMapEditor.mouseupEventHandlerSet != null
			&&
			Element.childOf ( SiteMapEditor.mouseupEventHandlerSet, SiteMapEditor.e.sitemap_section_ul ) 
			&& 
			/*
				This condition check is necessary
				b/c this event handler is used for both the sidebar and the
				section thus it will be called twice. The statement of primary
				concern is the setting of SiteMapEditor.mouseupEventHandlerSet to null
				at the right time
			*/
			e == SiteMapEditor.e.sitemap_section_ul
		)
		{
			//Trace.out('section typeof ' + typeof SiteMapEditor.mouseupEventHandlerSet);

			///
			/// 1. change the method to renderDefaultView
			/// 2. set the order value
			/// 3. set the id value
			/// 4. submit ajax request with serialized form data
			/// 5. reset the drag item pointer
			///
			
			// 1.
			SiteMapEditor.e.sitemap_ajax_method.value = 'renderDefaultView';
			// 2.
			liElements = SiteMapEditor.e.sitemap_section_ul.getElementsByTagName ( 'li' );
			for(i = 0; i < liElements.length; i++)
			{
				if ( liElements[i].id == SiteMapEditor.mouseupEventHandlerSet.id )
				{
					order = (i + 1);
					break;
				}
			}
			
			SiteMapEditor.e.sitemap_ajax_order.value = order;
			// 3.
			SiteMapEditor.e.sitemap_ajax_id.value = SiteMapEditor.mouseupEventHandlerSet;
			// 4.
			serializedForm = Form.serialize( SiteMapEditor.e.sitemap_ajax_form );
			
			//Trace.out(serializedForm);
			
			new Ajax.Request 
			( 
				SiteMapEditor.e.sitemap_ajax_form.getAttribute( 'action' ), 
				{
					postBody: serializedForm
				} 
			);
			
			SiteMapEditor.mouseupEventHandlerSet = null;
		}
		else if 
		( 
			SiteMapEditor.mouseupEventHandlerSet != null
			&&
		 	Element.childOf ( SiteMapEditor.mouseupEventHandlerSet, SiteMapEditor.e.sitemap_sidebar_ul ) 
			&&
			/*
				This condition check is necessary
				b/c this event handler is used for both the sidebar and the
				section thus it will be called twice. The statement of primary
				concern is the setting of SiteMapEditor.mouseupEventHandlerSet to null
				at the right time
			*/
			e == SiteMapEditor.e.sitemap_sidebar_ul
		)
		{
			
			//Trace.out('SiteMapEditor.mouseupEventHandlerSet : ' +  (SiteMapEditor.mouseupEventHandlerSet == null));
			
			///
			/// 1. change the method to renderInactivePagesView
			/// 2. change the id
			/// 3. change the order
			/// 4. submit ajax request with serialized form data and setting request onSuccess 
			/// 5. update sitemap_sidebar_ul with new content from onSuccess
			/// 6. reset the drag item pointer
			///
			
			// 1.
			
			SiteMapEditor.e.sitemap_ajax_method.value = 'renderInactivePagesView';
			
			//Trace.out('set ajax method: ' + SiteMapEditor.e.sitemap_ajax_method.value);
			
			// 2.
			SiteMapEditor.e.sitemap_ajax_id.value = SiteMapEditor.mouseupEventHandlerSet.id;
			
			//Trace.out('set ajax id: ' + SiteMapEditor.e.sitemap_ajax_method.value);
			
			// 3.
			liElements = SiteMapEditor.e.sitemap_sidebar_ul.getElementsByTagName ( 'li' );
			for(i = 0; i < liElements.length; i++)
			{
				if ( liElements[i].id == SiteMapEditor.mouseupEventHandlerSet.id )
				{
					order = (i + 1);
					break;
				}
			}
			
			SiteMapEditor.e.sitemap_ajax_order.value = order;
			
			//Trace.out('set order : ' + SiteMapEditor.e.sitemap_ajax_order.value);
			
			// 4. 
			serializedForm = Form.serialize(SiteMapEditor.e.sitemap_ajax_form);
			
			//Trace.out('set serializedForm');
			
			//Trace.out(serializedForm);
			
			new Ajax.Request 
			( 
				SiteMapEditor.e.sitemap_ajax_form.getAttribute( 'action' ), 
				{
					postBody: serializedForm,
					// 5. (...)
					onSuccess: SiteMapEditor.onSuccess
				}
			);
			
			// 6. 
			SiteMapEditor.mouseupEventHandlerSet = null;
			
			//Trace.out('set SiteMapEditor.mouseupEventHandlerSet : ' +  (SiteMapEditor.mouseupEventHandlerSet == null));
		}
		
		liElements = e.getElementsByTagName('li');
		for(i = 0; i < liElements.length; i++)
		{
			if ( ! Element.hasClassName ( liElements[i], 'drag' ) )
			{
				Element.setStyle 
				( 
				 	liElements[i],
					(
						(liElements.length == 1) ?
						{display: 'block'} :
						{display: 'none'}
					)
				);
			}
		}		
		
		//Trace.out('Dealt with non-dragable li');
	},
	onUpdateEventHandlerSidebar: function(e)
	{
		//Trace.out('Start Sidebar Event Handler:::');
		SiteMapEditor.onUpdateEventHandler(e);
		//Trace.out('Start Delayed Init:::');
		SiteMapEditor.delayedInit();
	}
};

Pre.meditate(SiteMapEditor.init);