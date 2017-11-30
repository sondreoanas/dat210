/*
	mf_Tool.js
	
	version			: 0.2.3
	last updated	: 30.11.2017
	name			: Markus Fjellheim
	description		:
		What does this do?
			This is various tools used multiple places in other files
*/

// Tool
function Tool(){
	
}
Tool.rgba = function(r, g, b, a){
	return "rgba(" + Math.floor(r) + "," + Math.floor(g) + "," + Math.floor(b) + "," + a + ")";
}
Tool.randomColor = function(brightness = Math.random()){ // TODO: move to color class
	var r = Math.random() * 256;
	var g = Math.random() * 256;
	var b = Math.random() * 256;
	var f = brightness / (r + g + b) * 255;
	r *= f;
	g *= f;
	b *= f;
	return "rgba(" + Math.floor(r) + "," + Math.floor(g) + "," + Math.floor(b) + ",1)";
}
Tool.clamp = function(value, max, min){
	if(max < min){
		return (max + min) * 0.5;
	}
	if(value > max){
		return max;
	}
	if(value < min){
		return min;
	}
	return value;
}
Tool.softCenter = function(value, range, slope){
	// will make values closer to 0 roughly within range. 'slope' is the slope of the derivative at value = 0.
	return value * ((1 - 1 / (1 + Math.pow(Math.abs(value / range),5))) * (1 - slope) + slope);
}
Tool.softRange = function(value, range, slope){
	// will clamp the value in between +- range. The slope tells the derivative of the function at value = 0.
	return range * value / (range / slope + Math.abs(value));
}
Tool.unixMillisecondsToDays = function(utc){
	return utc / 1000 / 60 / 60 / 24;
}
Tool.getFontHeight = function(font){
	return parseInt(font);
}
Tool.widthOfString = function(string, font){
	var canvas = document.createElement("canvas");
	var ctx = canvas.getContext("2d");
	ctx.font = font;
	return ctx.measureText(string).width;
}
Tool.lerp = function(v1, v2, f){
	return v1 + (v2 - v1) * f;
}
Tool.copyStringToClipboard = function(string){
	var textArea = document.createElement("textarea");
	
	textArea.value = string;
	document.body.appendChild(textArea);
	textArea.select();
	try {
		var successful = document.execCommand('copy');
		document.body.removeChild(textArea);
		if(successful){
			return true;
		}else{
			return false;
		}
	} catch (err) {
		return false;
		document.body.removeChild(textArea);
	}
}
Tool.modulus = function(v, m){
	return v - Math.floor(v / m) * m;
}
Tool.millisecond = 0;
Tool.second = 1;
Tool.minute = 2;
Tool.hour = 3;
Tool.day = 4;
Tool.week = 5;
Tool.month = 6;
Tool.year = 7;
Tool.getResetDateOf = function(date, resolution){
	var retDate = new Date(date.getTime());
	return Tool.resetDateTo(retDate, resolution);
}
Tool.getIncrementDateOf = function(date, resolution, steps){
	var retDate = new Date(date.getTime());
	return Tool.incrementDateTo(retDate, resolution, steps);
}
Tool.resetDateTo = function(date, resolution){
	// Will reset the date to the resolution.
	// Example: var startOfWeek = Tool.resetDateTo(new Date(), Tool.week);
	if(resolution == Tool.millisecond){
		
	}else if(resolution == Tool.second){
		date.setMilliseconds(0);
	}else if(resolution == Tool.minute){
		date.setMilliseconds(0);
		date.setSeconds(0);
	}else if(resolution == Tool.hour){
		date.setMilliseconds(0);
		date.setSeconds(0);
		date.setMinutes(0);
	}else if(resolution == Tool.day){
		date.setMilliseconds(0);
		date.setSeconds(0);
		date.setMinutes(0);
		date.setHours(0);
	}else if(resolution == Tool.week){
		date.setMilliseconds(0);
		date.setSeconds(0);
		date.setMinutes(0);
		date.setHours(0);
		date.setDate(date.getDate() - (date.getDay() + 6) % 7);
	}else if(resolution == Tool.month){
		date.setMilliseconds(0);
		date.setSeconds(0);
		date.setMinutes(0);
		date.setHours(0);
		date.setDate(1);
	}else if(resolution == Tool.year){
		date.setMilliseconds(0);
		date.setSeconds(0);
		date.setMinutes(0);
		date.setHours(0);
		date.setDate(1);
		date.setMonth(0);
	}else{
		Tool.printError("Resolution \"" + resolution + "\" not recognized.", 1);
		return -1;
	}
	return date;
}
Tool.incrementDateTo = function(date, resolution, steps = 1){
	// Example: var twoWeeksFromNow = Tool.incrementDate(new Date(), Tool.week, 2);
	if(resolution == Tool.millisecond){
		date.setTime(date.getTime() + 1 * steps);
	}else if(resolution == Tool.second){
		date.setTime(date.getTime() + 1000 * steps);
	}else if(resolution == Tool.minute){
		date.setTime(date.getTime() + 1000 * 60 * steps);
	}else if(resolution == Tool.hour){
		date.setTime(date.getTime() + 1000 * 60 * 60 * steps);
	}else if(resolution == Tool.day){
		date.setDate(date.getDate() + steps);
	}else if(resolution == Tool.week){
		date.setDate(date.getDate() + 7 * steps);
	}else if(resolution == Tool.month){
		date.setMonth(date.getMonth() + steps);
	}else if(resolution == Tool.year){
		date.setFullYear(date.getFullYear() + steps);
	}else{
		Tool.printError("Resolution \"" + resolution + "\" not recognized.", 1);
		return -1;
	}
	return date;
}
Tool.daysSinceEpoch = function(time){
	var startOfDay = Tool.resetDateTo(new Date(time), Tool.day).getTime();
	return Math.round(startOfDay / (1000 * 60 * 60 * 24));
}
Tool.weeksSinceEpoch = function(time){
	var startOfWeek = Tool.resetDateTo(new Date(time), Tool.week).getTime();
	return Math.round((startOfWeek / (1000 * 60 * 60 * 24) + 4) / 7);
}
Tool.monthsSinceEpoch = function(time){
	var dateTime = new Date(time);
	return (dateTime.getFullYear() - 1970) * 12 + dateTime.getMonth();
}
Tool.getNextInterval = function(fromTime, detectInProgress, interval){
	/*
	interval = {
		yearInterval: {start: new Date("2018"), modulus = 2},
		monthInterval: null,
		monthNrInYear: null,
		weekInterval: {start: new Date("this week"), modulus = 2},
		weekNrInMonth: null,
		weekNrInYear: null,
		dayInterval: {start: new Date("today"), modulus = 2},
		dayNrInWeek: null,
		dayNrInMonth: 5,
		dayNrInYear: null
	}
	*/
	
	// input check
	// missing arguments
	if(arguments.length != 3){
		Tool.printError("Wrong number of arguments. Expected 3, got " + arguments.length + ".");
		return -1;
	}
	// // multiple intervals
	if((interval.yearInterval != null) + (interval.monthInterval != null) + (interval.weekInterval != null) + (interval.dayInterval != null) != 1){
		Tool.printError("There must be exactly one interval as input.", 1);
		return -1;
	}
	// // redundant information
	// // // information outside of interval scope
	if(interval.weekInterval != null && interval.monthNrInYear != null){
		Tool.printError("\"monthNrInYear\" shoud be null if weekInterval is set.", 1);
		return -1;
	}
	if(interval.dayInterval != null){
		if(interval.weekNrInMonth != null){
			Tool.printError("\"weekNrInMonth\" shoud be null if dayInterval is set.", 1);
			return -1;
		}
		if(interval.weekNrInYear != null){
			Tool.printError("\"weekNrInYear\" shoud be null if dayInterval is set.", 1);
			return -1;
		}
	}
	// // // multiple attributes describing the same
	if(interval.monthInterval != null && interval.monthNrInYear != null){
		Tool.printError("\"monthInterval\" and \"monthNrInYear\" cannot both be set.", 1);
		return -1;
	}
	if((interval.weekInterval != null) + (interval.weekNrInMonth != null) + (interval.weekNrInYear != null) > 1){
		Tool.printError("Maximum one week attribute should be set.", 1);
		return -1;
	}
	if((interval.dayInterval != null) + (interval.dayNrInWeek != null) + (interval.dayNrInMonth != null) + (interval.dayNrInYear != null) > 1){
		Tool.printError("Maximum one day attribute should be set.", 1);
		return -1;
	}
	// // // conflicting attributes
	if(interval.dayNrInYear != null &&
			(interval.weekInterval != null || interval.weekNrInMonth != null || interval.weekNrInYear != null
			|| interval.monthInterval != null || interval.monthNrInYear != null)){
		Tool.printError("If \"dayNrInYear\" is set, no week or month attributes should be set.", 1);
		return -1;
	}
	if(interval.dayNrInMonth != null && (interval.weekInterval != null || interval.weekNrInMonth != null || interval.weekNrInYear != null)){
		Tool.printError("If \"dayNrInMonth\" is set, no week attributes should be set.", 1);
		return -1;
	}
	if(interval.weekNrInYear != null && (interval.monthInterval != null || interval.monthNrInYear != null)){
		Tool.printError("If \"weekNrInYear\" is set, no month attributes should be set.", 1);
		return -1;
	}
	// // missing dependencies
	if(interval.weekNrInMonth != null &&  interval.monthInterval == null && interval.monthNrInYear == null){
		Tool.printError("\"monthInterval\" or \"monthNrInYear\" must be set to use \"weekNrInMonth\".", 1);
		return -1;
	}
	if(interval.weekNrInYear != null && interval.yearInterval == null){
		Tool.printError("\"yearInterval\" must be set to use \"weekNrInYear\"", 1);
		return -1;
	}
	if(interval.dayNrInMonth != null && interval.monthInterval == null && interval.monthNrInYear == null){
		Tool.printError("\"monthInterval\" or \"monthNrInYear\" must be set to use \"dayNrInMonth\".", 1);
		return -1;
	}
	if(interval.dayNrInYear != null && interval.yearInterval == null){
		Tool.printError("\"yearInterval\" must be set to use \"dayNrInYear\"", 1);
		return -1;
	}
	
	//
	if(fromTime instanceof Date){
		fromTime = fromTime.getTime();
	}
	var fromTimeOriginal = fromTime;
	for(var i=0; i<2; i++){
		// make the year correct
		var correctYear;
		if(interval.yearInterval != null){
			var startOfYear = Tool.resetDateTo(new Date(fromTime), Tool.year);
			var restYear = Tool.modulus(interval.yearInterval.start.getFullYear() - startOfYear.getFullYear(), interval.yearInterval.modulus);
			correctYear = Tool.getIncrementDateOf(startOfYear, Tool.year, restYear);
		}
		// make the month correct
		var correctMonth;
		if(interval.monthInterval != null){
			var startOfMonth = Tool.resetDateTo(new Date(fromTime), Tool.month);
			var restMonth = Tool.modulus(Tool.monthsSinceEpoch(interval.monthInterval.start) - Tool.monthsSinceEpoch(fromTime), interval.monthInterval.modulus);
			correctMonth = Tool.getIncrementDateOf(startOfMonth, Tool.month, restMonth);
		}else if(interval.monthNrInYear != null){
			correctMonth = Tool.getIncrementDateOf(correctYear, Tool.month, interval.monthNrInYear);
		}
		// make the week correct
		var correctWeek;
		if(interval.weekInterval != null){
			var startOfWeek = Tool.resetDateTo(new Date(fromTime), Tool.week);
			var restWeek = Tool.modulus(Tool.weeksSinceEpoch(interval.weekInterval.start) - Tool.weeksSinceEpoch(fromTime), interval.weekInterval.modulus);
			correctWeek = Tool.getIncrementDateOf(startOfWeek, Tool.week, restWeek);
		}else if(interval.weekNrInMonth != null){
			correctWeek = Tool.getResetDateOf(correctMonth, Tool.week);
			correctWeek = Tool.getIncrementDateOf(correctWeek, Tool.week, interval.weekNrInMonth);
		}else if(interval.weekNrInYear != null){
			var firstWeekEndingInCorrectYear = Tool.getResetDateOf(correctYear, Tool.week);
			if(firstWeekEndingInCorrectYear.getFullYear() != correctYear.getFullYear()){
				correctWeek = Tool.getIncrementDateOf(firstWeekEndingInCorrectYear, Tool.week, interval.weekNrInYear + 1);
			}else{
				correctWeek = Tool.getIncrementDateOf(firstWeekEndingInCorrectYear, Tool.week, interval.weekNrInYear);
			}
		}
		/*if(interval.weekNrInYear != null && correctWeek.getFullYear() != correctYear.getFullYear()){
			correctWeek = Tool.getIncrementDateOf(correctWeek, Tool.week, 1);
		}*/
		// make the day correct
		var correctDay;
		if(interval.dayInterval != null){
			var startOfDay = Tool.resetDateTo(new Date(fromTime), Tool.day);
			var restDay = Tool.modulus(Tool.daysSinceEpoch(interval.dayInterval.start) - Tool.daysSinceEpoch(fromTime), interval.dayInterval.modulus);
			correctDay = Tool.getIncrementDateOf(startOfDay, Tool.day, restDay);
		}else if(interval.dayNrInWeek != null){
			if(interval.weekNrInMonth != null){
				// does this weekday exist in this month the first week of this month? If not, increment week by 1
				var firstWeekOfMonth = Tool.getResetDateOf(correctMonth, Tool.week);
				var thisWeekDayInFirstWeek = Tool.getIncrementDateOf(firstWeekOfMonth, Tool.day, interval.dayNrInWeek);
				if(thisWeekDayInFirstWeek.getMonth() != correctMonth.getMonth()){
					correctWeek = Tool.getIncrementDateOf(correctWeek, Tool.week, 1);
				}
			}
			correctDay = Tool.getIncrementDateOf(correctWeek, Tool.day, interval.dayNrInWeek);
		}else if(interval.dayNrInMonth != null){
			correctDay = Tool.getIncrementDateOf(correctMonth, Tool.day, interval.dayNrInMonth);
		}else if(interval.dayNrInYear != null){
			correctDay = Tool.getIncrementDateOf(correctYear, Tool.day, interval.dayNrInYear);
		}
		
		// check if the found entry in the interval is in the past
		var foundStartTime;
		var foundEndTime;
		if(correctDay != null){
			foundEndTime = Tool.getIncrementDateOf(correctDay, Tool.day , 1).getTime();
			foundStartTime = correctDay.getTime();
		}else if(correctWeek != null){
			foundEndTime = Tool.getIncrementDateOf(correctWeek, Tool.week , 1).getTime();
			foundStartTime = correctWeek.getTime();
		}else if(correctMonth != null){
			foundEndTime = Tool.getIncrementDateOf(correctMonth, Tool.month , 1).getTime();
			foundStartTime = correctMonth.getTime();
		}else if(correctYear != null){
			foundEndTime = Tool.getIncrementDateOf(correctYear, Tool.year , 1).getTime();
			foundStartTime = correctYear.getTime();
		}else{
			Tool.printError("No return date was found");
			return false;
		}
		if(fromTimeOriginal > (detectInProgress? foundEndTime : foundStartTime)){
			if(interval.dayInterval != null){
				fromTime = Tool.getIncrementDateOf(correctDay, Tool.day, interval.dayInterval.modulus).getTime();
			}else if(interval.weekInterval != null){
				fromTime = Tool.getIncrementDateOf(correctWeek, Tool.week, interval.weekInterval.modulus).getTime();
			}else if(interval.monthInterval != null){
				fromTime = Tool.getIncrementDateOf(correctMonth, Tool.month, interval.monthInterval.modulus).getTime();
			}else if(interval.yearInterval != null){
				fromTime = Tool.getIncrementDateOf(correctYear, Tool.year, interval.yearInterval.modulus).getTime();
			}else{
				Tool.printError("No interval found");
				return -1;
			}
			continue;
		}else{
			break;
		}
	}
	if(i >= 2){
		Tool.printError("Too many iterations were run");
		return -1;
	}
	
	return {start: foundStartTime, end: foundEndTime};
}
Tool.printError = function(message, level = 0){
	// level >= 0
	// Prints out an error with stack trace. The level is how many functions up the stack will start.
	// Standard is one level above where the function is called
	console.error(message + "\n" + Tool.getStackTrace(level + 1));
}
Tool.getStackTrace = function(level = 0){
	var error = Error().stack.split("\n");
	error.splice(1, level + 1);
	return error.join("\n");
}
Tool.copyArray = function(array){
	var newArray = [];
	for(var i=0; i<array.length; i++){
		newArray.push(array[i]);
	}
	return newArray;
}
// Color
function Color(r, g, b, a = 1){ // TODO: integrate random color here
	this.r = r;
	this.g = g;
	this.b = b;
	this.a = a;
}
Color.prototype.toString = function(){
	return "rgba(" + Math.floor(Math.min(Math.max(this.r, 0), 255)) + "," +
		Math.floor(Math.min(Math.max(this.g, 0), 255)) + "," +
		Math.floor(Math.min(Math.max(this.b, 0), 255)) + "," +
		Math.min(Math.max(this.a, 0), 1) + ")";
}
Color.add = function(c1, c2){
	return new Color(c1.r + c2.r, c1.g + c2.g, c1.b + c2.b, c1.a + c2.a);
}
Color.sub = function(c1, c2){
	return new Color(c1.r - c2.r, c1.g - c2.g, c1.b - c2.b, c1.a - c2.a);
}
Color.addRGB = function(c1, c2){
	return new Color(c1.r + c2.r, c1.g + c2.g, c1.b + c2.b, (c1.a + c2.a) * 0.5);
}
Color.subRGB = function(c1, c2){
	return new Color(c1.r - c2.r, c1.g - c2.g, c1.b - c2.b, (c1.a + c2.a) * 0.5);
}
Color.mulRGB = function(c, m){
	return new Color(c.r * m, c.g * m, c.b * m, c.a);
}










































