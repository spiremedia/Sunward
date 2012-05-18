/**
 * DatePickerControl.v.1.0.2
 *
 * Transform your input text control into a date-picker control.
 *
 * By Hugo Ortega_Hernandez - hugorteg{no_spam}@gmail.com
 *
 * Last version of this code: http://dali.mty.itesm.mx/~hugo/js/datepickercontrol/
 *
 * Features:
 *   + Automatic input control conversion with a single attribute
 *     in the 'input' tag or a special 'id' attribute format.
 *   + Multiple date formats.
 *   + Layered calendar, without pop-up window.
 *   + Mouse and keyboard navigation.
 *   + Variable first day of week.
 *   + CSS support.
 *
 * License: GPL (that's, use this code as you wish, just keep it free)
 * Provided as is, without any warranty.
 * Feel free to use this code, but don't remove this disclaimer please.
 *
 * If you're going to use this library, please send me an email, and
 * would be great if you include a photo of your city :)
 * (se habla espa&ntilde;ol)
 *
 * Credits:
 *
 * Functions to calculate days of a year and to generate the calendar code by:
 *    Kedar R. Bhave - softricks{no_spam}@hotmail.com
 *    ttp://www.softricks.com
 *    = Modified by Hugo Ortega_H:
 *      + CSS style
 *      + Remove non useful code (original version with pop-up window)
 *      + Clean job :-) (so hard!)
 *      + Add support for layered calendar
 *      + Many other stuff.
 *
 * Other code functions and lines to calculate objects' size & location by:
 *    Mircho Mirev - mo{no_spam}@momche.net
 *
 * First day of week code by:
 *    Massimiliano Ciancio  -  massimiliano at ciancio dot net
 *
 *
 *                                        Veracruz & Monterrey, Mexico, 2005.
 */


//-----------------------------------------------------------------------------
// Some parameters for style and behaviour...
// Is better to use global parameters to avoid problems with updates,
// but if you want to override default values, here are the variables :-)
// (see index.html to see how to use global parameters)

DatePickerControl.defaultFormat   = "DD/MM/YYYY";
DatePickerControl.offsetY         = 1;
DatePickerControl.offsetX         = 0;
DatePickerControl.todayText       = "Today";
DatePickerControl.buttonTitle     = "Open calendar...";
DatePickerControl.buttonPosition  = "in";  // or "out"
DatePickerControl.buttonOffsetX   = 0;     // See below for some considerations about
DatePickerControl.buttonOffsetY   = 0;     // that values (for IE)
DatePickerControl.closeOnTodayBtn = true;  // close if today button is pressed?
DatePickerControl.defaultTodaySel = true;  // If true and content is blank, today date will be selected
DatePickerControl.autoShow        = false; // Auto show the calendar when the input grab the focus.
DatePickerControl.firstWeekDay    = 0;     // First day of week: 0=Sunday, 1=Monday, ..., 6=Saturday
DatePickerControl.weekend         = [0,6]; // Sunday and Saturday as weekend (maybe a 3-day weekend in France :D , I love it!...)

DatePickerControl.Months =
//	["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];
	["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
//	["Janvier", "F&eacute;vrier", "Mars", "Avril", "Mai", "Juin", "Juillet", "Ao&ucirc;t", "Septembre", "Octobre", "Novembre", "D&eacute;cembre"];
//	["Januar", "Februar", "M&auml;rz", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"];
//	["Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"];

DatePickerControl.Days =
//	["Dom", "Lun", "Mar", "Mi&eacute;", "Jue", "Vie", "S&aacute;b"];
	["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
//	["Dim", "Lun", "Mar", "Mer", "Jeu", "Ven", "Sam"];
//	["Son", "Mon", "Die", "Mit", "Don", "Fre", "Sam"];
//	["Dom", "Lun", "Mar", "Mer", "Gio", "Ven", "Sab"];


//-----------------------------------------------------------------------------
// Specific patches

DatePickerControl.useTrickyBG = false;
// Some people ask me about IE strange behaviour... well, here's the patch
// IE returns object position with one pixel more
// <sarcasm>Patches for IE?, I can't believe!</sarcasm>
// There area a LOT of problems with IE, because if you change, for example,
// the body margin, all control's positions are wrong... agghh... I hate IE...
// this is why all my projects have a technical requirement: Mozilla family :-)
if (navigator.userAgent.indexOf("MSIE") > 1){
	DatePickerControl.useTrickyBG   = true;
	DatePickerControl.offsetY       = 0;
	DatePickerControl.offsetX       = -1;
	DatePickerControl.buttonOffsetX = -4;
	DatePickerControl.buttonOffsetY = -2;
	// but if document have xhtml dtd, things are different... :S
	if (document.getElementsByTagName("html")[0].getAttribute("xmlns") != null){
		DatePickerControl.offsetY       = 16;
		DatePickerControl.offsetX       = 10;
		DatePickerControl.buttonOffsetX = 8;
		DatePickerControl.buttonOffsetY = 14;
	}
}

//-----------------------------------------------------------------------------
// Some constants and internal stuff

DatePickerControl.editIdPrefix   = "DPC_";          // The prefix for edit's id
DatePickerControl.displayed      = false;           // Is the calendar layer displayed?
DatePickerControl.HIDE_TIMEOUT   = 200;             // Time in ms for hide the calendar layer
DatePickerControl.hideTimeout    = null;            // The timeout identifier
DatePickerControl.buttonIdPrefix = "CALBUTTON";     // The prefix for the calendar button's id
DatePickerControl.dayIdPrefix    = "CALDAY";        // The prefix for the calendar days frames' id
DatePickerControl.currentDay     = 1;               // The current day of current month of current year :-)
DatePickerControl.originalValue  = "";              // The original value of edit control
DatePickerControl.calFrameId     = "calendarframe"; // The id for the calendar layer
DatePickerControl.submitByKey    = false;           // Is submitting by keyboard?
DatePickerControl.dayOfWeek      = 0;               // The current day of current week ...
DatePickerControl.firstFocused   = false;           // Is the first time that the current edit control is focused?
DatePickerControl.hideCauseBlur  = false;           // Was the calendar close by onblur event?
DatePickerControl.DOMonth        = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]; // Non-leap year month days
DatePickerControl.lDOMonth       = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]; // Leap year month days


//-----------------------------------------------------------------------------
// The fun

/**
 * Constructor
 */
function DatePickerControl()
{
}

/**
 * Creates the calendar's div element and the button into the input-texts with
 * attibute datepicker="true" or id="DPC_foo_[format]"
 */
DatePickerControl.init = function()
{
	// try to create the DatePickerControl.container:
	if (!document.getElementById("CalendarPickerControl")){

		// but first, looking for global parameters:
		var obj = document.getElementById("DPC_DEFAULT_FORMAT");
		if (obj) this.defaultFormat = obj.value;

		obj = document.getElementById("DPC_FIRST_WEEK_DAY");
		if (obj) this.firstWeekDay = (obj.value < 0 || obj.value > 6) ? 0 : parseInt(obj.value);

		obj = document.getElementById("DPC_WEEKEND_DAYS");
		if (obj) eval("this.weekend = " + obj.value);

		obj = document.getElementById("DPC_AUTO_SHOW");
		if (obj) this.autoShow = obj.value == "true";

		obj = document.getElementById("DPC_DEFAULT_TODAY");
		if (obj) this.defaultTodaySel = obj.value == "true";

		obj = document.getElementById("DPC_CALENDAR_OFFSET_X");
		if (obj) this.offsetX = parseInt(obj.value);

		obj = document.getElementById("DPC_CALENDAR_OFFSET_Y");
		if (obj) this.offsetY = parseInt(obj.value);

		obj = document.getElementById("DPC_TODAY_TEXT");
		if (obj) this.todayText = obj.value;

		obj = document.getElementById("DPC_BUTTON_TITLE");
		if (obj) this.buttonTitle = obj.value;

		obj = document.getElementById("DPC_BUTTON_POSITION");
		if (obj) this.buttonPosition = obj.value;

		obj = document.getElementById("DPC_BUTTON_OFFSET_X");
		if (obj) this.buttonOffsetX = parseInt(obj.value);

		obj = document.getElementById("DPC_BUTTON_OFFSET_Y");
		if (obj) this.buttonOffsetY = parseInt(obj.value);

		obj = document.getElementById("DPC_MONTH_NAMES");
		if (obj) eval("this.Months = " + obj.value);

		obj = document.getElementById("DPC_DAY_NAMES");
		if (obj) eval("this.Days = " + obj.value);
		// end of global parameters

		this.calBG = null;
		if (this.useTrickyBG){
			// Creates a tricky bg to hide the select controls (IE bug).
			// We use a iframe element, because is one of the elements that can
			// stay on top of select controls.
			// I don't like this solution, but IE is a pseudo-browser for developers
			this.calBG                = document.createElement("iframe");
			this.calBG.id             = "CalendarPickerControlBG";
			this.calBG.style.zIndex   = "49999"; // below calcontainer
			this.calBG.style.position = "absolute";
			this.calBG.style.display  = "none";
			this.calBG.style.border   = "0px solid transparent";
			document.body.appendChild(this.calBG);
		}
		this.calContainer                = document.createElement("div");
		this.calContainer.id             = "CalendarPickerControl";
		this.calContainer.style.zIndex   = "50000";
		this.calContainer.style.position = "absolute";
		this.calContainer.style.display  = "none";
		document.body.appendChild(this.calContainer);

		if (this.calContainer.addEventListener){
			this.calContainer.addEventListener("click", DPC_onContainerClick, false);
			//window.addEventListener("resize", DPC_onWindowResize, false);
		}
		else if (this.calContainer.attachEvent){
			this.calContainer.attachEvent("onclick", DPC_onContainerClick);
			//window.attachEvent("onresize", DPC_onWindowResize);
		}
	}
	// search for input controls that will be transformed into DatePickerControl's.
	var inputsLength = document.getElementsByTagName("input").length;
	for (i=0; i<inputsLength; i++){
		if (document.getElementsByTagName("input")[i].type.toLowerCase() == "text"){
			var editctrl  = document.getElementsByTagName("INPUT")[i];
			var dpcattr   = editctrl.getAttribute("datepicker");
			var setEvents = false;
			// if datepicker pseudo-attribute:
			if (dpcattr != null && dpcattr == "true"){
				if (editctrl.id){
					if (!this.createButton(editctrl, false)) continue;
					setEvents = true;
				}
				else{
					alert("Attribute 'id' is mandatory for DatePickerControl.");
				}
			}
			// if fomated id attr:
			else if (editctrl.id && editctrl.id.indexOf(this.editIdPrefix) == 0){
				if (!this.createButton(editctrl, true)) continue;
				setEvents = true;
			}
			// add the events:
			if (setEvents){
				editctrl.setAttribute("maxlength", "10");
				if(editctrl.addEventListener){
					editctrl.addEventListener("keyup", DPC_onEditControlKeyUp, false);
					editctrl.addEventListener("keydown", DPC_onEditControlKeyDown, false);
					editctrl.addEventListener("blur", DPC_onEditControlBlur, false);
					editctrl.addEventListener("focus", DPC_onEditControlFocus, false);
				}
				else if (editctrl.attachEvent){
					editctrl.attachEvent("onkeyup", DPC_onEditControlKeyUp);
					editctrl.attachEvent("onkeydown", DPC_onEditControlKeyDown);
					editctrl.attachEvent("onblur", DPC_onEditControlBlur);
					editctrl.attachEvent("onfocus", DPC_onEditControlFocus);
				}
				var theForm = editctrl.form;
				if (theForm){
					if (theForm.addEventListener){
						theForm.addEventListener('submit', DPC_onFormSubmit, false);
					}
					else if (theForm.attachEvent){
						theForm.attachEvent('onsubmit', DPC_onFormSubmit);
					}
				}
			}
		}
	}
}


function DPC_autoInit()
{
	DatePickerControl.init();
}

if (window.addEventListener){
	window.addEventListener("load", DPC_autoInit, false);
}
else if (window.attachEvent){
	window.attachEvent("onload", DPC_autoInit);
}


/**
 * Creates the calendar button for an text-input control
 * @param input The associated text-input to create the button.
 * @param useId Specify if you want to use the Id of input control to obtain the format
 * @return true is the control has been created, otherwise false
 */
DatePickerControl.createButton = function(input, useId)
{
	var newid = this.buttonIdPrefix + input.id;
	if (document.getElementById(newid)) return false; // if exists previously....
	// set the date format
	var fmt = "";
	if (useId){ // get the format from the control's id
		var arr = input.id.split("_");
		var last = arr[arr.length-1];
		// a not so beauty validation :S
		if ((last.indexOf("-")>0 || last.indexOf("/")>0) && last.indexOf("YY") >= 0 &&
			last.indexOf("D") >= 0 && last.indexOf("M") >= 0){ // is a format
				fmt = last;
		}
		else{
			fmt = this.defaultFormat;
		}
	}
	else{ // get the format from pseudo-attibute
		fmt = input.getAttribute("datepicker_format");
		if (fmt == null) fmt = this.defaultFormat;
	}
	// Create the button
	var calButton = document.createElement("div");
	calButton.id = newid;
	calButton.style.display = 'inline'
	calButton.style.marginLeft = '-17px';
	calButton.style.marginTop = '2px';
	calButton.title = this.buttonTitle;
	// Set some attributes to remember the text-input associated
	// with this button and its format:
	calButton.setAttribute("datepicker_inputid", input.id);
	calButton.setAttribute("datepicker_format", fmt);
	// Add the event listeners:
	if(calButton.addEventListener){
		calButton.addEventListener("click", DPC_onButtonClick, false);
	}
	else if (calButton.attachEvent){
		calButton.attachEvent("onclick", DPC_onButtonClick);
	}
	// add first to have access to the size properties
	if (input.nextSibling) {
		input.parentNode.insertBefore(calButton, input.nextSibling);
	} else {
		input.parentNode.appendChild(calButton);
	}

	calButton.className    = "calendarbutton";
	calButton.style.zIndex = 10000;
	calButton.style.cursor = "pointer";

	return true;
}

/**
 * Show the calendar
 */
DatePickerControl.show = function()
{
	if (!this.displayed){
		var input = this.inputControl;
		if (input == null) return;
		if (input.disabled) return; // just in case ;)
		var top  = getObject.getSize("offsetTop", input);
		var left = getObject.getSize("offsetLeft", input);
		var calframe = document.getElementById(this.calFrameId);

		this.calContainer.style.top        = top + input.offsetHeight + this.offsetY + "px";
		this.calContainer.style.left       = left + this.offsetX + "px";
		this.calContainer.style.display    = "none";
		this.calContainer.style.visibility = "visible";
		this.calContainer.style.display    = "block";
		this.calContainer.style.height     = calframe.offsetHeight;
		if (this.calBG){ // the ugly patch for IE
			this.calBG.style.top        = this.calContainer.style.top;
			this.calBG.style.left       = this.calContainer.style.left;
			this.calBG.style.display    = "none";
			this.calBG.style.visibility = "visible";
			this.calBG.style.display    = "block";
			this.calBG.style.width      = this.calContainer.offsetWidth;
			if (calframe){
				this.calBG.style.height = calframe.offsetHeight;
			}
		}
		this.displayed = true;
		input.focus();
	}
}


/**
 * Hide the calendar
 */
DatePickerControl.hide = function()
{
	if (this.displayed){
		this.calContainer.style.visibility = "hidden";
		this.calContainer.style.left = -1000; // some problems with overlaped controls
		this.calContainer.style.top = -1000;
		if (this.calBG){ // the ugly patch for IE
			this.calBG.style.visibility = "hidden";
			this.calBG.style.left = -1000;
			this.calBG.style.top = -1000;
		}
		this.inputControl.value = this.originalValue;
		this.displayed = false;
	}
}


/**
 * Gets the name of a numbered month
 */
DatePickerControl.getMonthName = function(monthNumber)
{
	return this.Months[monthNumber];
}

/**
 * Obtains the days of a given month and year
 */
DatePickerControl.getDaysOfMonth = function(monthNo, p_year)
{
	/*
	Check for leap year ..
	1.Years evenly divisible by four are normally leap years, except for...
	2.Years also evenly divisible by 100 are not leap years, except for...
	3.Years also evenly divisible by 400 are leap years.
	*/
	if ((p_year % 4) == 0){
		if ((p_year % 100) == 0 && (p_year % 400) != 0){
			return this.DOMonth[monthNo];
		}
		return this.lDOMonth[monthNo];
	}
	else{
		return this.DOMonth[monthNo];
	}
}

DatePickerControl.calcMonthYear = function(p_Month, p_Year, incr)
{
	/*
	Will return an 1-D array with 1st element being the calculated month
	and second being the calculated year
	after applying the month increment/decrement as specified by 'incr' parameter.
	'incr' will normally have 1/-1 to navigate thru the months.
	*/
	var ret_arr = new Array();

	if (incr == -1) {
		// B A C K W A R D
		if (p_Month == 0) {
			ret_arr[0] = 11;
			ret_arr[1] = parseInt(p_Year) - 1;
		}
		else {
			ret_arr[0] = parseInt(p_Month) - 1;
			ret_arr[1] = parseInt(p_Year);
		}
	} else if (incr == 1) {
		// F O R W A R D
		if (p_Month == 11) {
			ret_arr[0] = 0;
			ret_arr[1] = parseInt(p_Year) + 1;
		}
		else {
			ret_arr[0] = parseInt(p_Month) + 1;
			ret_arr[1] = parseInt(p_Year);
		}
	}

	return ret_arr;
}

/**
 * Gets the DatePickerControl.code
 */
DatePickerControl.getAllCode = function()
{
	var vCode = "";
	vCode += "<table class='calframe' id='" + this.calFrameId + "'>";
	vCode += this.getHeaderCode();
	vCode += this.getDaysHeaderCode();
	vCode += this.getDaysCode();
	vCode += "</table>";
	return vCode;
}

/**
 * The title and nav buttons
 */
DatePickerControl.getHeaderCode = function()
{
	var prevMMYYYY = this.calcMonthYear(this.month, this.year, -1);
	var prevMM = prevMMYYYY[0];
	var prevYYYY = prevMMYYYY[1];

	var nextMMYYYY = this.calcMonthYear(this.month, this.year, 1);
	var nextMM = nextMMYYYY[0];
	var nextYYYY = nextMMYYYY[1];

	var gNow = new Date();
	var vCode = "";

	vCode += "<tr><td colspan='7' class='monthname'>";
	vCode += this.monthName + "&nbsp;&nbsp;";

	vCode += "<span title='" + this.Months[this.month] + " " + (parseInt(this.year)-1) + "' class='yearbutton' ";
	vCode += "onclick='DatePickerControl.build(" + this.month + ", " + (parseInt(this.year)-1)+");return false;'>&laquo;</span>";
	vCode += "&nbsp;" + this.year + "&nbsp;";

	vCode += "<span title='" + this.Months[this.month] + " " + (parseInt(this.year)+1) + "' class='yearbutton' ";
	vCode += "onclick='DatePickerControl.build(" + this.month + ", " + (parseInt(this.year)+1) + ");return false;'>&raquo;</span>";
	vCode += "</td></tr>";

	vCode += "<tr><td style='border-width:0px' colspan='7'>";
	vCode += "<table class='navigation' width='100%'><tr>";

	vCode += "<td class='navbutton' title='" + this.Months[prevMM] + " " + prevYYYY + "' ";
	vCode += "onclick='DatePickerControl.build(" + prevMM + ", " + prevYYYY + ");return false;'>&lt;&lt;</td>";

	vCode += "<td class='navbutton' title='" + gNow.getDate() + " " + this.Months[gNow.getMonth()] + " " + gNow.getFullYear() + "' ";
	vCode += "onclick='DatePickerControl.build(" + gNow.getMonth() + ", " + gNow.getFullYear() + ");DatePickerControl.selectToday();return false;'>";
	vCode += this.todayText + "</td>";

	vCode += "<td class='navbutton' title='" + this.Months[nextMM] + " " + nextYYYY + "' ";
	vCode += "onclick='DatePickerControl.build(" + nextMM + ", " + nextYYYY +	");return false;'>&gt;&gt;</td>";

	vCode += "</tr></table>";
	vCode += "</td></tr>";

	return vCode;
}

/**
 * The days' name headers
 */
DatePickerControl.getDaysHeaderCode = function()
{
	var vCode = "";

	vCode = vCode + "<tr>";
	for (i=this.firstWeekDay; i<this.firstWeekDay+7; i++){
		vCode = vCode + "<td class='dayname' width='14%'>" + this.Days[i % 7] + "</td>";
	}
	vCode = vCode + "</tr>";

	return vCode;
}

/**
 * The days numbers code
 */
DatePickerControl.getDaysCode = function()
{
	var vDate = new Date();
	vDate.setDate(1);
	vDate.setMonth(this.month);
	vDate.setFullYear(this.year);

	var vFirstDay = vDate.getDay();
	var vDay = 1;
	var vLastDay = this.getDaysOfMonth(this.month, this.year);
	var vOnLastDay = 0;
	var vCode = "";
	this.dayOfWeek = vFirstDay;

	var prevm = this.month == 0 ? 11 : this.month-1;
	var prevy = this.prevm == 11 ? this.year - 1 : this.year;
	prevmontdays = this.getDaysOfMonth(prevm, prevy);
	vFirstDay = (vFirstDay == 0 && this.firstWeekDay) ? 7 : vFirstDay;

	// Write the last days of previous month
	vCode = vCode + "<tr>";
	for (i=this.firstWeekDay; i<vFirstDay; i++) {
		vCode = vCode + "<td class='dayothermonth'>" + (prevmontdays-vFirstDay+i+1) + "</td>";
	}

	// Write rest of the 1st week
	for (j=vFirstDay-this.firstWeekDay; j<7; j++) {
		classname = this.getDayClass(vDay, j);
		vCode = vCode + "<td class='" + classname + "' class_orig='" + classname + "' " +
			"onClick='DatePickerControl.writeDate(" + vDay + ")' id='" + this.dayIdPrefix + vDay + "'>" +
			vDay +
			"</td>";
		vDay = vDay + 1;
	}
	vCode = vCode + "</tr>";

	// Write the rest of the weeks
	for (k=2; k<7; k++){
		vCode = vCode + "<TR>";
		for (j=0; j<7; j++){
			classname = this.getDayClass(vDay, j);
			vCode = vCode + "<td class='" + classname  + "' class_orig='" +  classname + "' " +
				"onClick='DatePickerControl.writeDate(" + vDay + ")' id='" + this.dayIdPrefix + vDay + "'>" +
				vDay +
				"</td>";
			vDay = vDay + 1;
			if (vDay > vLastDay){
				vOnLastDay = 1;
				break;
			}
		}

		if (j == 6)
			vCode = vCode + "</tr>";
		if (vOnLastDay == 1)
			break;
	}

	// Fill up the rest of last week
	for (m=1; m<(7-j); m++){
		vCode = vCode + "<td class='dayothermonth'>" + m + "</td>";
	}

	return vCode;
}

/**
 * Get the class according if is 'today', the 'current' date at the control,
 * a 'weekend' day, or a 'normal' day.
 * @param vday The number of the day in the current month and year
 * @param dayofweek The number of the day within the week (0..6)
 */
DatePickerControl.getDayClass = function(vday, dayofweek)
{
	var gNow      = new Date();
	var vNowDay   = gNow.getDate();
	var vNowMonth = gNow.getMonth();
	var vNowYear  = gNow.getFullYear();

	if (vday == vNowDay && this.month == vNowMonth && this.year == vNowYear){
		return "today";
	}
	else{
		// transform the day acording the specified firts day of week
		var realdayofweek = (7 + dayofweek + this.firstWeekDay) % 7;
		for (i=0; i<this.weekend.length; i++){
			if (realdayofweek == this.weekend[i]){
				return "weekend";
			}
		}
		return "day";
	}
}

/**
 * Gets the date string according to calendar's format
 * @param p_day The number of the day in the current month and year
 */
DatePickerControl.formatData = function(p_day)
{
	var vData;
	var vMonth = 1 + this.month;
	vMonth = (vMonth.toString().length < 2) ? "0" + vMonth : vMonth;
	var vMon = this.getMonthName(this.month).substr(0,3).toUpperCase();
	var vFMon = this.getMonthName(this.month).toUpperCase();
	var vY4 = new String(this.year);
	var vY2 = new String(this.year).substr(2,2);
	var vDD = (p_day.toString().length < 2) ? "0" + p_day : p_day;

	switch (this.format) {
		case "MM/DD/YYYY" :
			vData = vMonth + "/" + vDD + "/" + vY4;
			break;
		case "MM/DD/YY" :
			vData = vMonth + "/" + vDD + "/" + vY2;
			break;
		case "MM-DD-YYYY" :
			vData = vMonth + "-" + vDD + "-" + vY4;
			break;
		case "MM-DD-YY" :
			vData = vMonth + "-" + vDD + "-" + vY2;
			break;
		case "YYYY-MM-DD":
			vData = vY4 + "-" + vMonth + "-" + vDD;
			break;
		case "YYYY/MM/DD":
			vData = vY4 + "/" + vMonth + "/" + vDD;
			break;

		case "DD/MON/YYYY" :
			vData = vDD + "/" + vMon + "/" + vY4;
			break;
		case "DD/MON/YY" :
			vData = vDD + "/" + vMon + "/" + vY2;
			break;
		case "DD-MON-YYYY" :
			vData = vDD + "-" + vMon + "-" + vY4;
			break;
		case "DD-MON-YY" :
			vData = vDD + "-" + vMon + "-" + vY2;
			break;

		case "DD/MONTH/YYYY" :
			vData = vDD + "/" + vFMon + "/" + vY4;
			break;
		case "DD/MONTH/YY" :
			vData = vDD + "/" + vFMon + "/" + vY2;
			break;
		case "DD-MONTH-YYYY" :
			vData = vDD + "-" + vFMon + "-" + vY4;
			break;
		case "DD-MONTH-YY" :
			vData = vDD + "-" + vFMon + "-" + vY2;
			break;

		case "DD/MM/YYYY" :
			vData = vDD + "/" + vMonth + "/" + vY4;
			break;
		case "DD/MM/YY" :
			vData = vDD + "/" + vMonth + "/" + vY2;
			break;
		case "DD-MM-YYYY" :
			vData = vDD + "-" + vMonth + "-" + vY4;
			break;
		case "DD-MM-YY" :
			vData = vDD + "-" + vMonth + "-" + vY2;
			break;

		default :
			vData = vMonth + "/" + vDD + "/" + vY4;
	}

	return vData;
}


/**
 * Try to get the date from the control according to the format:
 * This function doesn't work with named months
 * @return An object of class Date with the current date in the control (if succesfull) or
 *  today if fails.
 */
DatePickerControl.getDateFromControl = function()
{
	var aDate = new Date();
	var value = this.inputControl.value;
	var day, month, year;
	value = value.replace("/", "@").replace("/", "@");
	value = value.replace("-", "@").replace("-", "@");
	// si persisten los caracteres el formato es invalido:
	if (value.indexOf("/")>=0 || value.indexOf("-")>=0) return aDate;
	// validate all other stuff
	var data = value.split("@");
	if (data.length != 3) return aDate;
	for (i=0; i<3; i++){
		if (isNaN(parseInt(data[i]))) return aDate;
	}
	if (this.format.substring(0,1).toUpperCase() == "D"){
		aDate.setDate(data[0]);
		aDate.setMonth(data[1]-1);
		aDate.setFullYear(data[2]);
	}
	else if (this.format.substring(0,1).toUpperCase() == "Y"){
		aDate.setDate(data[2]);
		aDate.setMonth(data[1]-1);
		aDate.setFullYear(data[0]);
	}
	else if (this.format.substring(0,1).toUpperCase() == "M"){
		aDate.setDate(data[1]);
		aDate.setMonth(data[0]-1);
		aDate.setFullYear(data[2]);
	}
	return aDate;
}


/**
 * Writes the specified date in the control and close the calendar.
 */
DatePickerControl.writeDate = function(day)
{
	var d = this.formatData(day);
	this.inputControl.value = d;
	this.originalValue = d;
	this.hide();
	if (DatePickerControl.onSelect) DatePickerControl.onSelect(this.inputControl.id);
	this.firstFocused = true;
	this.inputControl.focus();
}

/**
 * Writes the current date in the control
 */
DatePickerControl.writeCurrentDate = function()
{
	var d = this.formatData(this.currentDay);
	this.inputControl.value = d;
}


/**
 * Creates and write the calendar's code
 * @param m The month to build
 * @param y The year to build
 */
DatePickerControl.build = function(m, y)
{
	var calframe = document.getElementById(this.calFrameId);
	if (m==null){
		var now = new Date();
		this.month     = now.getMonth();
		this.monthName = this.Months[this.month];
		this.year      = now.getFullYear();
	}
	else{
		this.month     = m;
		this.year      = y;
		this.monthName = this.Months[this.month];
	}
	var code = this.getAllCode();
	writeLayer(this.calContainer.id, null, code);
	if (this.calContainer && calframe) this.calContainer.style.height = calframe.offsetHeight;
	this.firstFocused = true;
	this.inputControl.focus();
	this.selectDay(this.currentDay);
}

/**
 * Build the prev month calendar
 */
DatePickerControl.buildPrev = function()
{
	if (!this.displayed) return;
	var prevMMYYYY = this.calcMonthYear(this.month, this.year, -1);
	var prevMM = prevMMYYYY[0];
	var prevYYYY = prevMMYYYY[1];
	this.build(prevMM, prevYYYY);
}

/**
 * Build the next month calendar
 */
DatePickerControl.buildNext = function()
{
	if (!this.displayed) return;
	var nextMMYYYY = this.calcMonthYear(this.month, this.year, 1);
	var nextMM = nextMMYYYY[0];
	var nextYYYY = nextMMYYYY[1];
	this.build(nextMM, nextYYYY);
}


/**
 * Today button action
 */
DatePickerControl.selectToday = function()
{
	var now = new Date();
	var today = now.getDate();
	if (this.closeOnTodayBtn){
		this.currentDay = today;
		this.writeDate(this.currentDay);
	}
	else{
		this.selectDay(today);
	}
}

/**
 * Select a specific day
 */
DatePickerControl.selectDay = function(day)
{
	if (!this.displayed) return;
	var n = this.currentDay;
	var max = this.getDaysOfMonth(this.month, this.year);
	if (day > max) return;
	var newDayObject = document.getElementById(this.dayIdPrefix+day);
	var currentDayObject = document.getElementById(this.dayIdPrefix+this.currentDay);
	if (currentDayObject){
		currentDayObject.className = currentDayObject.getAttribute("class_orig");
	}
	if (newDayObject){
		newDayObject.className = "current";
		this.currentDay = day;
		this.writeCurrentDate();
	}
}

/**
 * Select the prev week day
 * @param decr Use 1 for yesterday or 7 for prev week
 */
DatePickerControl.selectPrevDay = function(decr)
{
	if (!this.displayed) return;
	var n = this.currentDay;
	var max = this.getDaysOfMonth(this.month, this.year);
	var prev = n - decr;
	if ( prev <= 0 ){
		if (decr == 7){
			n = (n + this.dayOfWeek) + 28 - this.dayOfWeek;
			n--;
			prev = n > max ? n-7 : n;
		}
		else{
			prev = max;
		}
	}
	this.selectDay(prev);
}

/**
 * Select the next week day
 * @param decr Use 1 for tomorrow or 7 for next week
 */
DatePickerControl.selectNextDay = function(incr)
{
	if (!this.displayed) return;
	var n = this.currentDay;
	var max = this.getDaysOfMonth(this.month, this.year);
	var next = n + incr;
	if ( next > max ){
		if (incr == 7){
			n = ((n + this.dayOfWeek) % 7) - this.dayOfWeek;
			next = n < 0 ? n+7 : n;
			next++;
		}
		else{
			next = 1;
		}
	}
	this.selectDay(next);
}

/**
 * Show the calendar for an edit control
 */
DatePickerControl.showForEdit = function(edit)
{
	if (this.displayed) return;
	if (edit == null) return;
	if (edit.disabled) return;
	var idbtn = this.buttonIdPrefix + edit.id;
	var button = document.getElementById(idbtn);
	this.inputControl = edit;
	this.originalValue = edit.value;
	// and the format
	var format = button.getAttribute("datepicker_format");
	if (format == null) format = this.defaultFormat;
	this.format = format;
	// build with the date
	if (edit.value == ""){
		this.currentDate = null;
		this.build(null, null);
		if (this.defaultTodaySel){
			this.currentDay = new Date().getDate();
		}
		else{
			this.currentDay = 1;
		}
	}
	else{
		var date = this.getDateFromControl();
		this.currentDate = date;
		this.build(date.getMonth(), date.getFullYear());
		this.currentDay  = date.getDate();
	}
	var currentDayObject = document.getElementById(this.dayIdPrefix+this.currentDay);
	if (currentDayObject) currentDayObject.className = "current";
	this.writeCurrentDate();
	// and
	this.show();
}


/**
 * Click event for calendar button
 */
function DPC_onButtonClick(event){DatePickerControl.onButtonClick(event);}
DatePickerControl.onButtonClick = function(event)
{
	if (!this.displayed){
		// get the button
		if (event == null) event = window.event;
		var button = (event.srcElement) ? event.srcElement : event.originalTarget;
		// gets the associated input:
		var input = document.getElementById(button.getAttribute("datepicker_inputid"));
		this.showForEdit(input);
	}
	else{
		this.hide();
	}
}

/**
 * Click event for calendar layer.
 */
function DPC_onContainerClick(event){DatePickerControl.onContainerClick(event);}
DatePickerControl.onContainerClick = function(event)
{
	if (event == null) event = window.event;
	if (this.hideTimeout){
		clearTimeout(this.hideTimeout);
		this.hideTimeout = null;
	}
	this.inputControl.focus();
	return false;
}

/**
 * Key-up event for edit controls as date-pickers
 */
function DPC_onEditControlKeyUp(event){DatePickerControl.onEditControlKeyUp(event);}
DatePickerControl.onEditControlKeyUp = function(event)
{
	if (event == null) event = window.event;
	var edit = (event.srcElement) ? event.srcElement : event.originalTarget;
	//alert(event.keyCode);
	switch (event.keyCode){
		case 37: // left arrow key
			this.selectPrevDay(1);
			break;

		case 38: // up arrow key
			this.selectPrevDay(7);
			break;

		case 39: // right arrow key
			this.selectNextDay(1);
			break;

		case 40: // down arrow key
			if (!this.displayed){
				this.showForEdit(edit);
			}
			else{
				this.selectNextDay(7);
				break;
			}
			break;

		case 27: // escape key
			this.hide();
			break;

		case 33: // repag key
			this.buildPrev();
			break;

		case 34: // avpag key
			this.buildNext();
			break;

		case 13: // enter-key (forms without submit buttons)
			if (this.displayed && this.currentDay > 0 && this.submitByKey){
				this.writeDate(this.currentDay);
			}
			break;
	}
	return false;
}

/**
 * Key-down event for edit controls as date-pickers
 */
function DPC_onEditControlKeyDown(event){DatePickerControl.onEditControlKeyDown(event);}
DatePickerControl.onEditControlKeyDown = function(event)
{
	if (event == null) event = window.event;
	var edit = (event.srcElement) ? event.srcElement : event.originalTarget;
	//alert(event.keyCode);
	switch (event.keyCode){
		case 13: // enter key
			this.submitByKey = true;
			break;
		case 9:  // tab key
		case 32: // space-bar key
			if (this.displayed && this.currentDay > 0){
				this.writeDate(this.currentDay);
			}
			break;
	}
}

/**
 * Blur event for edit controls as date-pickers
 */
function DPC_onEditControlBlur(event){DatePickerControl.onEditControlBlur(event);}
DatePickerControl.onEditControlBlur = function(event)
{
	if (event == null) event = window.event;
	if (!this.hideTimeout){
		this.hideTimeout = setTimeout("DatePickerControl.hide()", this.HIDE_TIMEOUT);
	}
	this.firstFocused  = false;
	this.hideCauseBlur = true;
	var edit = (event.srcElement) ? event.srcElement : event.originalTarget;
}

/**
 * Focus event for edit controls as date-pickers
 */
function DPC_onEditControlFocus(event){DatePickerControl.onEditControlFocus(event);}
DatePickerControl.onEditControlFocus = function(event)
{
	if (event == null) event = window.event;
	var edit = (event.srcElement) ? event.srcElement : event.originalTarget;

	if ((!this.displayed || this.hideCauseBlur) && this.autoShow && !this.firstFocused){
		clearTimeout(this.hideTimeout);
		this.hideTimeout   = null;
		this.firstFocused  = true;
		if (this.hideCauseBlur){
			this.hideCauseBlur = false;
			this.hide();
		}
		this.showForEdit(edit);
	}
	else if (this.inputControl && this.inputControl.id != edit.id){
		this.hide();
	}
	else if (this.hideTimeout){
		clearTimeout(this.hideTimeout);
		this.hideTimeout = null;
	}
}

/**
 * Form's submit event
 */
function DPC_onFormSubmit(event){DatePickerControl.onFormSubmit(event);}
DatePickerControl.onFormSubmit = function(event)
{
	if (this.submitByKey){
		this.submitByKey = false;
		if (this.displayed && this.currentDay > 0){
			this.writeDate(this.currentDay);
			if (event == null) event = window.event;
			var theForm = (event.srcElement) ? event.srcElement : event.originalTarget;
			event.returnValue = false
			if (event.preventDefault){
				event.preventDefault();
			}
			return false;
		}
	}
}

/**
 * Window resize event.
 */
function DPC_onWindowResize(event){DatePickerControl.onWindowResize(event);}
DatePickerControl.onWindowResize = function(event)
{
	//this.relocate();
	//this.relocateButtons();
}


/**
 * Relocate buttons
 */
DatePickerControl.relocateButtons = function()
{
	var divElements = document.getElementsByTagName("div");
	for (key in divElements){
		if (divElements[key].id && divElements[key].id.indexOf(this.buttonIdPrefix) == 0){
			var calButton = divElements[key];
			var input = document.getElementById(calButton.getAttribute("datepicker_inputid"));
			var nTop = getObject.getSize("offsetTop", input);
			var nLeft = getObject.getSize("offsetLeft", input);
			calButton.style.top = (nTop + Math.floor((input.offsetHeight-calButton.offsetHeight)/2) + this.buttonOffsetY) + "px";
			var btnOffX         = Math.floor((input.offsetHeight - calButton.offsetHeight) / 2);
			if (this.buttonPosition == "in"){
				calButton.style.left = (nLeft + input.offsetWidth - calButton.offsetWidth - btnOffX + this.buttonOffsetX) + "px";
			}
			else{ // "out"
				calButton.style.left = (nLeft + input.offsetWidth + btnOffX + this.buttonOffsetX) + "px";
			}
		}
	}
}

/**
 * Relocate the calendar's frame
 */
DatePickerControl.relocate = function()
{
	if (this.displayed){
		var input = this.inputControl;
		if (input == null) return;
		var top  = getObject.getSize("offsetTop", input);
		var left = getObject.getSize("offsetLeft", input);
		this.calContainer.style.top  = top + input.offsetHeight + this.offsetY + "px";
		this.calContainer.style.left = left + this.offsetX + "px";
		if (this.calBG){ // the ugly patch for IE
			this.calBG.style.top  = this.calContainer.style.top;
			this.calBG.style.left = this.calContainer.style.left;
		}
	}
}


//-----------------------------------------------------------------------------
// Following 2 functions by: Mircho Mirev

function getObject(sId)
{
	if (bw.dom){
		this.hElement = document.getElementById(sId);
		this.hStyle = this.hElement.style;
	}
	else if (bw.ns4){
		this.hElement = document.layers[sId];
		this.hStyle = this.hElement;
	}
	else if (bw.ie){
		this.hElement = document.all[sId];
		this.hStyle = this.hElement.style;
	}
}

/*
getObject.getSize = function(sParam, hLayer)
{
	nPos = 0;
	while ((hLayer.tagName) && !( /(body|html)/i.test(hLayer.tagName))){
		nPos += eval('hLayer.' + sParam);
		if (sParam == 'offsetTop'){
			if (hLayer.clientTop){
				nPos += hLayer.clientTop;
			}
		}
		if (sParam == 'offsetLeft'){
			if (hLayer.clientLeft){
				nPos += hLayer.clientLeft;
			}
		}
		hLayer = hLayer.offsetParent;
	}
	return nPos;
}*/
getObject.getSize = function(sParam, hLayer)
{
	sl = '';
	st = ''
	var curleft = 0;
	var curtop = 0;
		
	if (hLayer.offsetParent) {
		do {
			
			sl += ' ' + hLayer.offsetLeft;
			st += ' ' + hLayer.offsetTop;
			curleft += hLayer.offsetLeft;
			curtop += hLayer.offsetTop;
		} while (hLayer = hLayer.offsetParent);
	}
	
	if (navigator.userAgent.indexOf('MSIE') != -1){
		curtop -= 15;
		curleft -= 15;
	}
	
	if (sParam == 'offsetTop'){
		return curtop;
	} else {
		return curleft;
	}
}




/**
 * Based on code by: Peter Todorov
 */
function writeLayer(ID, parentID, sText)
{
	if (document.layers){
		var oLayer;
		if(parentID){
			oLayer = eval('document.' + parentID + '.document.' + ID + '.document');
		}
		else{
			oLayer = document.layers[ID].document;
		}
		oLayer.open();
		oLayer.write(sText);
		oLayer.close();
	}
	else if(document.all){
		document.all[ID].innerHTML = sText;
	}
	else{
		document.getElementById(ID).innerHTML = sText;
	}
}

//
// Compartir es la única manera de perdurar
// EOF
