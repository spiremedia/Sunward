function ListManager(id, sItems, orderAble){		
	this.setMethods = function(){
		// Set the select box to call this when its changed
		//selectBoxRef.setAttribute('onchange', objName + '.itemSelect()');

		//parse the select box for easy access to value labels
		for (var i = 1; i < selectBoxRef.options.length; i++) {
			optionsList[selectBoxRef.options[i].value] = selectBoxRef.options[i].text;
		}
	};
	this.showSelected = function(){
		var str = new Array();
		if (sItems.length){
			//write out the optionsList
			str.push("<ul class='listManager'>");
			for(var i = 0; i < sItems.length; i++) {
				try{ //try catch because theere might be in item no longer in the list
					str.push("<li>");
					str.push("<img src='/ui/images/button/delete.gif' title='Delete Item' onclick='"+objName+".removeItem(\""+sItems[i]+"\")'> ");
					if (orderAble){
						if (i != 0) str.push("<img src='/ui/images/button/up.gif' title='Move Item Up' onclick='"+objName+".moveItem(\"up\",\""+sItems[i]+"\")'> ");
						else str.push("<img src='/ui/images/button/blankdir.gif'> ");
						if (i != sItems.length-1) str.push("<img src='/ui/images/button/dn.gif' title='Move Item Down' onclick='"+objName+".moveItem(\"dn\",\""+sItems[i]+"\")'> ");
						else str.push("<img src='/ui/images/button/blankdir.gif'> ");
					}
					str.push(optionsList[sItems[i]]);
					str.push("</li>");
					//str.push("<li><img src='/ui/images/button/delete.gif' onclick='"+objName+".removeItem(\""+sItems[i]+"\")'> " + optionsList[sItems[i]] + "</li>");
				} catch(e){}
			}
			str.push("</ul>");
			str.push("<a href='javascript:"+objName+".selectAll()'>Select All</a> ");
			str.push("<a href='javascript:"+objName+".clearAll()'>Clear All</a>. ");
		} else {
			str.push("No Items are selected. ");
			str.push("<a href='javascript:"+objName+".selectAll()'>Select All</a>.");
		}
		recipientBoxRef.innerHTML = str.join('');
		//update the hidden field that is the one we will watch when submitting.
		hiddenRef.value = sItems.join(',');
	};
	this.removeItem = function(id){
		//find and remove item
		for (var i = 0; i < sItems.length; i++) {
			if (sItems[i] == id) {
				sItems.splice(i, 1);
				break;
			}
		}
		//redraw
		this.showSelected();
	};
	this.moveItem = function(dir, id){
		//find item		
		for (var i = 0; i < sItems.length; i++) {
			if (sItems[i] == id) {
				var idx = i;
				break;
			}
		}
		
		//switch with appropriate
		if (dir == 'up' && idx != 0) {
			var swapvalue = sItems[idx-1];
			sItems[idx-1] = sItems[idx];
			sItems[idx] = swapvalue;
		} 
		if (dir = 'dn' && idx != sItems.length -1){
			var swapvalue = sItems[idx+1];
			sItems[idx+1] = sItems[idx];
			sItems[idx] = swapvalue;			
		}
		
		//redraw
		this.showSelected();
	};
	this.clearAll = function(){
		//clear sItems
		sItems = new Array();
		//redraw
		this.showSelected();
	};
	this.selectAll = function(){
		//clear sItems
		sItems = new Array();
		for (var i = 1; i < selectBoxRef.options.length; i++) {
			sItems.push(selectBoxRef.options[i].value);
		}
		//redraw
		this.showSelected();
	};
	this.itemSelect = function(){
		
		//get selected item
		var selected = selectBoxRef.value;
		//reset box to 0
		selectBoxRef.selectedIndex = 0;
		//if reselected blank, do nothing
		if (selected == '') return;
		
		//check selected item is notalready selected
		for (var i = 0; i < sItems.length; i++) {
			if (selected == sItems[i]) 
				return;
		}
		sItems.unshift(selected);
		this.showSelected();
	
	};
	// html id
	var id = id;
	// whether to show up down buttons
	var orderAble = orderAble;
	//preselected items
	var sItems = sItems;
	//ref for select box for easy access
	var selectBoxRef = $(id + '_LMchooser');
	//ref for recipient box for easy access
	var recipientBoxRef = $('_' + id + '_list');
	//ref for hidden id that is to be watched for form
	var hiddenRef = $(id);
	//name of this item to be used as handle
	var objName = '_' + id + '_LM';
	//hash for quick access from select box
	var optionsList = new Object();
	
	this.setMethods();
	this.showSelected();
}