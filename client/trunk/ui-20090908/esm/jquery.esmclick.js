(function($){  
	$.fn.esmclick = function(options) {  
		return this.each(function() {  
							
			var i = new Object();
			i.name = $(this).attr('name');
			i.value = $(this).attr('value');
			i.id = $(this).attr('id');
			i.url = options.link;
			//sd.info = info;
			var sd = $(this).parent().click(function(){
				/*if (i.id == '')
					localurl = i.url.replace('|action|','add') + 					'&name=' + i.name + '&info=' + escape(i.value);
				else
					localurl = i.url.replace('|action|','edit') + '&id=' + i.id + 	'&name=' + i.name + '&info=' + escape(i.value);*/
				//load the window
				var popupWin = window.open
				(
				 	((i.id == '') ? i.url.replace('|action|','add') :  i.url.replace('|action|','edit') + '&id=' + i.id ) + '&name=' + i.name + '&info=' + escape(i.value) ,
					'optionsWin',
					'width=900,height=500,toolbar=0,resizable=1,scrollbars=1,screenX=0,screenY=0,top=0,left=0'
				);
				if ( !document.all && window.focus ) popupWin.focus();
			});
		});
	};
})(jQuery);  
