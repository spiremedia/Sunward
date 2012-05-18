sfHover = function() {
	var sfEls = document.getElementById("nav").getElementsByTagName("LI");
	for (var i=0; i<sfEls.length; i++) {
		sfEls[i].onmouseover=function() {
			this.className+=" sfhover";
		}
		sfEls[i].onmouseout=function() {
			this.className=this.className.replace(new RegExp(" sfhover\\b"), "");
		}
	}
}
if (window.attachEvent) window.attachEvent("onload", sfHover);

/**
 * Update the search input text box
 * @param focus
 */
function setSearchText(focus)
{
	var txtSearch = document.getElementById('txtSearch');
	var defaultValue = 'Search site';
	if (focus) {
		if (txtSearch.value == defaultValue) {
			txtSearch.value = '';
		}
	} else {
		if (txtSearch.value == '') {
			txtSearch.value = defaultValue;
		}
	}
}