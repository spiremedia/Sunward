/*
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
menuTopHover = function(){
	var sfImgs = document.getElementById("nav").getElementsByTagName("IMG");
		for (var i=0; i<sfImgs.length; i++) {
		sfImgs[i].onmouseover=function() {
			this.src = this.src.replace(new RegExp("\.png"), '_over.png');
		}
		sfImgs[i].onmouseout=function() {

			this.src = this.src.replace(new RegExp("\_over\.png"), '.png');
		}
	}
}

//if (window.attachEvent) window.attachEvent("onload", sfHover);

attachItems = function(){
	if (window.attachEvent) sfHover();
	menuTopHover();
}
window.onload = attachItems;
*/

function addLoadEvent(func) {
	var oldonload = window.onload;
	if (typeof window.onload != 'function') {
		window.onload = func;
	} else {
		window.onload = function() {
			if (oldonload) {
				oldonload();
			}
			func();
		}
	}
}
sfHover = function() {
	if (window.attachEvent){
		
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
}

safariMenuBlock = function () {
	//safari not working properly with dhtml nav
	if (/Safari/.test(navigator.userAgent)){
		var itm = document.getElementById('nav');
		itm.id = 'navSaf';
	}
}
menuTopHover = function(){
	var sfImgs = document.getElementById("nav").getElementsByTagName("IMG");
		for (var i=0; i<sfImgs.length; i++) {
		sfImgs[i].onmouseover=function() {
			this.src = this.src.replace(new RegExp("\.png"), '_over.png');
		}
		sfImgs[i].onmouseout=function() {

			this.src = this.src.replace(new RegExp("\_over\.png"), '.png');
		}
	}
}
addLoadEvent(menuTopHover);
addLoadEvent(safariMenuBlock);
addLoadEvent(sfHover);
