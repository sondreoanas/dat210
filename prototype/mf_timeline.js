/*
	mf_timeline.js
	
	version			: 0.1
	last updated	: 12.09.2017
	start date		: 10.09.2017
	name			: Markus Fjellheim
	description		:
		What does this do?
			This will make a window for displaying events in a calendar.
		How to use it?
			In the header, point to this file "<script src='mf_timeline.js'></script>".
			All divs with class 'mf_timeline' will turn into a calendar window.
			(Not yet implemented)The div's ids is used to communicate with the window.
*/

function mf_TimelineHandler(){
	this.loops;
	this.fps;
	this.timelines;
}
window.onload = function (){
	mf_timeline = new mf_TimelineHandler();
	mf_timeline.loops = {};
	mf_timeline.fps = 30;
	mf_timeline.timelines = [];
	
	var arr = document.getElementsByClassName("mf_timeline");
	for(var i=0; i<arr.length; i++){
		var newTimeline = new Timeline(arr[i]);
		mf_timeline.timelines.push(newTimeline);
	}
}
// Event
function Event(start, end, name, color){
	this.id = Event.nrOfEvents;
	Event.nrOfEvents++;
	this.start = start;
	this.end = end;
	this.name = name;
	this.color = color;
	this.horizontalOffset = 0;
}
Event.nrOfEvents = 0;
// Timeline
function Timeline(container){
	//this.zoom = 10; // how much time is visible
	//this.position = 0; // what time is centered
	//this.targetPosition = this.position; // what day is centered
	this.zoom = 1000 * 60 * 60 * 24 * 10; // 10 days // how much time is visible
	this.position = new Date().getTime() + 1000 * 60 * 60 * 24 * 0.5; // what time is centered // "+" starts half a day behind
	this.targetPosition = this.position; // what day is centered
	
	this.tick = 0;
	this.loop = setInterval(this.loop.bind(this), 1000/mf_timeline.fps);
	this.container = container;
	this.id = container.id;
	this.touchList = [];
	
	this.canvas = document.createElement("canvas");
	//this.canvas.style.border = "1px solid black";
	var style = getComputedStyle(container);
	this.canvas.width = container.clientWidth
		- parseFloat(style.paddingRight) - parseFloat(style.paddingLeft);
	this.canvas.height = container.clientHeight
		- parseFloat(style.paddingTop) - parseFloat(style.paddingBottom);
	container.appendChild(this.canvas);
	
	this.ctx = this.canvas.getContext("2d");
	
	// pc
	container.addEventListener("mousewheel", this.scroll.bind(this), false);
	// mobile
	container.addEventListener("touchstart", this.touchStart.bind(this), false);
	container.addEventListener("touchmove", this.touchMove.bind(this), false);
	container.addEventListener("touchend", this.touchEnd.bind(this), false);
	
	this.days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
	this.months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
	
	// dummydata
	this.events = [
		new Event(
			start = new Date(2017, 8, 17, 0, 0).getTime(),
			end = new Date(2017, 8, 19, 0, 0).getTime(),
			name = "LAN",
			color = "red"
		),
		new Event(
			start = new Date(2017, 8, 18, 0, 0).getTime(),
			end = new Date(2017, 8, 20, 0, 0).getTime(),
			name = "Festival",
			color = "green"
		),
		new Event(
			start = new Date(2017, 8, 20, 9, 0).getTime(),
			end = new Date(2017, 8, 20, 13, 0).getTime(),
			name = "Exam",
			color = "blue"
		)
	];
	// calculate horizontalOffsets
	this.horizontalOffsets = [];
	var nrOfOffsets = 10;
	var offsets = [];
	for(var i=0; i<nrOfOffsets; i++){
		offsets.push(i);
	}
	for(var i=0; i<10; i++){
		var random = Math.random();
		if(i == 0){
			random = 0.5;
		}
		var offset = offsets.splice(Math.floor(random * offsets.length), 1);
		this.horizontalOffsets.push(offset / nrOfOffsets);
	}
	//
	this.calcuateEventOffset();
}
Timeline.prototype.calcuateEventOffset = function(event){
	for(var i=0; i<this.events.length; i++){
		this.events[i].horizontalOffset = 0;
	}
	var isDone;
	while(!isDone){
		isDone = true;
		for(var i=0; i<this.events.length; i++){
			var e1 = this.events[i];
			for(var j=i+1; j<this.events.length; j++){
				var e2 = this.events[j];
				// is outside of view
				if(e1.end > e2.start && e1.start < e2.end && // is colliding and...
					e1.horizontalOffset == e2.horizontalOffset){ // ...has same offset
					if(e1.id < e2.id){
						e2.horizontalOffset++;
					}else{
						e1.horizontalOffset++;
					}
					isDone = false;
				}
			}
		}
	}
}
Timeline.prototype.touchStart = function(event){
	outer:
	for(var i=0; i<event.touches.length; i++){
		var e = event.touches[i];
		for(var j=0; j<this.touchList.length; j++){
			var t = this.touchList[j];
			if(e.identifier == t.id){
				continue outer;
			}
		}
		
		if(this.touchList.length >= 2){ // maximum 2
			return;
		}
		this.touchList.push({
			x: e.clientX - e.target.parentElement.offsetLeft,
			y: this.canvas.height - (e.clientY - e.target.parentElement.offsetTop),
			x0: e.clientX - e.target.parentElement.offsetLeft,
			y0: this.canvas.height - (e.clientY - e.target.parentElement.offsetTop),
			xR: e.radiusX,
			yR: e.radiusY,
			id: e.identifier
		});
	}
	
	if(this.touchList.length == 2){
		event.preventDefault();
	}
}
Timeline.prototype.touchMove = function(event){
	for(var i=0; i<event.touches.length; i++){
		var e = event.touches[i];
		for(var j=0; j<this.touchList.length; j++){
			var t = this.touchList[j];
			if(e.identifier == t.id){
				t.x = e.clientX - e.target.parentElement.offsetLeft;
				t.y = this.canvas.height - (e.clientY - e.target.parentElement.offsetTop);
				t.xR = e.radiusX;
				t.yR = e.radiusY;
			}
		}
	}
	
	if(this.touchList.length == 2){
		event.preventDefault();
	}
}
Timeline.prototype.touchEnd = function(event){
	for(var i=0; i<event.changedTouches.length; i++){
		var e = event.changedTouches[i];
		for(var j=0; j<this.touchList.length; j++){
			var t = this.touchList[j];
			if(e.identifier == t.id){
				this.touchList.splice(j, 1);
				j--;
			}
		}
	}
	
	event.preventDefault();
}
Timeline.prototype.scroll = function(event){
	if(event.ctrlKey){ // zoom
		this.zoom *= 1 + event.deltaY * 0.001;
	}else{ // scroll
		this.targetPosition += event.deltaY * 0.001 * this.zoom;
	}
	
	event.preventDefault();
}
Timeline.prototype.loop = function(){
	this.tick++;
	// clear
	this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
	
	// debug
	for(var i=0; i<this.touchList.length; i++){
		var t = this.touchList[i];
		this.drawText ("id: " + t.id + " yPos: " + t.y, t.x, t.y);
		//this.drawText ("x", t.x, t.y);
	}
	
	// calcuate touchMotion
	if(this.touchList.length == 2){
		// movement
		var t0 = this.touchList[0];
		var t1 = this.touchList[1];
		var deltaY = ((t0.y - t0.y0) + (t1.y - t1.y0)) * 0.5; // average of vertical motion of the two fingers
		deltaY *= 1 / this.canvas.height * this.zoom; // make propotional to zoom and screen size
		this.targetPosition += deltaY;
		this.position += deltaY;
		
		// zoom
		// // Y
		var differenceY = (t0.y - t0.y0) - (t1.y - t1.y0);
		differenceY;
		if(t0.y > t1.y){
			differenceY *= -1;
		}
		differenceY *= 1 / this.canvas.height * this.zoom;
		this.zoom += differenceY * 2;
		// // X
		var differenceX = (t0.x - t0.x0) - (t1.x - t1.x0);
		differenceX;
		if(t0.x > t1.x){
			differenceX *= -1;
		}
		differenceX *= 1 / this.canvas.height * this.zoom;
		this.zoom += differenceX * 2;
	}
	// calcuate motion
	this.position = (this.targetPosition - this.position) * 0.2 + this.position;
	
	// render
	this.render();
	
	// endstuff
	// // save last touch positions
	for(var i=0; i<this.touchList.length; i++){
		var t = this.touchList[i];
		t.x0 = t.x;
		t.y0 = t.y;
	}
}
Timeline.prototype.render = function(){
	var unitNameHeight = 100;
	
	var yearWidth = 30;
	var monthWidth = 30;
	var weekWidth = 30;
	var dayWidth = 30;
	var hourWidth = 30;
	var minuteWidth = 30;
	
	var horizontalRulerWidth = yearWidth + monthWidth + weekWidth + dayWidth + hourWidth + minuteWidth;
	
	var maxRender = 100;
	
	var accumulatedWidth = 0;
	
	// draw events
	for(var i=0; i<this.events.length; i++){
		var e = this.events[i];
		// is outside of view
		if(e.end < this.position - this.zoom * 0.5 || e.start > this.position + this.zoom * 0.5){
			continue;
		}
		//
		
		var boxWidth = this.canvas.width * 0.3;
		var horizontalPosition = this.horizontalOffsets[e.horizontalOffset] * (this.canvas.width - boxWidth - horizontalRulerWidth);
		this.drawBox(horizontalRulerWidth + horizontalPosition, this.timeToCanvasCoords(e.end),
			horizontalRulerWidth + boxWidth + horizontalPosition, this.timeToCanvasCoords(e.start),
			e.color, true, 1);
		var font = "24px Arial";
		var top = this.timeToCanvasCoords(e.start) - parseInt(font);
		var bottom = this.timeToCanvasCoords(e.end) + parseInt(font) * 0.2;
		if(top > this.canvas.height){
			top = this.canvas.height;
		}
		if(bottom < 0){
			bottom = 0;
		}
		
		var yPos = (top + bottom) * 0.5;
		
		// opacity
		var font = "24px Arial";
		var nameSize = parseInt(font);
		// // calcuate opacity value
		var opacity;
		if(nameSize > top - bottom){
			opacity = 2 - nameSize / (top - bottom < 1e-10 ? 1e-10: top - bottom);
		}else{
			opacity = 1;
		}
		
		this.drawText(e.name, horizontalRulerWidth + boxWidth * 0.5 + horizontalPosition, yPos, Tool.rgba(255,255,255,opacity), font, alignment = "center", orientation = 0)
	}
	
	// draw date structure
	// // year
	this.drawUnit(yearWidth, "YEAR", unitNameHeight, 0, horizontalRulerWidth,
		function getNameFunction(date){
			return date.getFullYear();
		},
		function resetTimeFuntion(date){
			date.setMilliseconds(0);
			date.setSeconds(0);
			date.setMinutes(0);
			date.setHours(0);
			date.setDate(1);
			date.setMonth(0);
		},
		function incrementTimeFunction(date){
			date.setFullYear(date.getFullYear() + 1);
		}
	);
	// // month
	this.drawUnit(monthWidth, "MONTH", unitNameHeight, yearWidth, horizontalRulerWidth,
		function getNameFunction(date){
			return this.months[date.getMonth()];
		}.bind(this),
		function resetTimeFuntion(date){
			date.setMilliseconds(0);
			date.setSeconds(0);
			date.setMinutes(0);
			date.setHours(0);
			date.setDate(1);
		},
		function incrementTimeFunction(date){
			date.setMonth(date.getMonth() + 1);
		}
	);
	// // week
	this.drawUnit(weekWidth, "WEEK", unitNameHeight, yearWidth + monthWidth, horizontalRulerWidth,
		function getNameFunction(date){
			var date2 = new Date(date.getTime());
			date2.setMilliseconds(0);
			date2.setSeconds(0);
			date2.setMinutes(0);
			date2.setHours(0);
			date2.setDate(1);
			date2.setMonth(0);
			var weekNumber =  Math.floor((date.getTime() - date2.getTime()) / 1000 / 60 / 60 / 24 / 7) + 1;
			
			return "week " + weekNumber;
		}.bind(this),
		function resetTimeFuntion(date){
			date.setMilliseconds(0);
			date.setSeconds(0);
			date.setMinutes(0);
			date.setHours(0);
			date.setDate(date.getDate() - (date.getDay() + 6) % 7);
		},
		function incrementTimeFunction(date){
			date.setDate(date.getDate() + 7);
		}
	);
	// // day
	this.drawUnit(dayWidth, "DAY", unitNameHeight, yearWidth + monthWidth + weekWidth, horizontalRulerWidth,
		function getNameFunction(date){
			return this.days[date.getDay()] + " #" + date.getDate();
		}.bind(this),
		function resetTimeFuntion(date){
			date.setMilliseconds(0);
			date.setSeconds(0);
			date.setMinutes(0);
			date.setHours(0);
		},
		function incrementTimeFunction(date){
			date.setDate(date.getDate() + 1);
		}
	);
	// // hour
	this.drawUnit(hourWidth, "HOUR", unitNameHeight, yearWidth + monthWidth + weekWidth + dayWidth, horizontalRulerWidth,
		function getNameFunction(date){
			var hours = date.getHours().toString();
			if(hours.length == 1){
				hours = "0" + hours;
			}
			return hours + ":00";
		}.bind(this),
		function resetTimeFuntion(date){
			date.setMilliseconds(0);
			date.setSeconds(0);
			date.setMinutes(0);
		},
		function incrementTimeFunction(date){
			date.setTime(date.getTime() + 1000 * 60 * 60);
		}
	);
	// // minute
	this.drawUnit(minuteWidth, "Minute", unitNameHeight, yearWidth + monthWidth + weekWidth + dayWidth + hourWidth, horizontalRulerWidth,
		function getNameFunction(date){
			var minutes = date.getMinutes().toString();
			if(minutes.length == 1){
				minutes = "0" + minutes;
			}
			return "" + ":" + minutes;
		}.bind(this),
		function resetTimeFuntion(date){
			date.setMilliseconds(0);
			date.setSeconds(0);
		},
		function incrementTimeFunction(date){
			date.setTime(date.getTime() + 1000 * 60);
		}
	);
}
Timeline.prototype.drawUnit = function(width, unitName, unitNameHeight, horizontalOffset, horizontalRulerWidth, getNameFunction, resetTimeFuntion, incrementTimeFunction){
	// calculate fading
	// // calcuate approximate interval width
	var date = new Date();
	resetTimeFuntion(date);
	var time0 = date.getTime();
	incrementTimeFunction(date);
	var intervalPeriod = date.getTime() - time0;
	var periodSize = intervalPeriod / this.zoom * this.canvas.height; // [this.zoom] = time / canvas height
	// // calcuate name size
	var unitValueName = getNameFunction(date);
	var font = "24px Arial";
	this.canvas.font = font;
	var nameSize = this.ctx.measureText(unitValueName).width;;
	// // calcuate opacity value
	var opacity;
	if(nameSize * 2 > periodSize){
		//opacity = 1 - (nameSize * 2 - periodSize) * 0.01;
		opacity = 2 - nameSize * 2 / periodSize;
	}else{
		opacity = 1;
	}
	
	// draw intervals
	if(opacity > 0){
		this.drawIntervall(
			function(top, bottom, date){
				// calcuate vertical position of unit value. For example day = tuesday.
				var font = "24px Arial"; // TODO: abstract this outside function
				var unitValueName = getNameFunction(date); // eksample: 'week: 5'
				this.ctx.font = font;
				var margin = this.ctx.measureText(unitValueName).width;
				var yPos = this.clamp(this.canvas.height * 0.5, top - margin, bottom + margin);
				// draw unit name
				this.drawText(unitValueName, parseInt(font) + horizontalOffset, yPos, Tool.rgba(0,0,0,opacity), font, "center", Math.PI * 0.5);
				// draw horizontal ruler to seperate the units
				this.drawLine(horizontalRulerWidth, bottom, this.canvas.width, bottom, Tool.rgba(0,0,0,opacity), 1);
				this.drawLine(horizontalOffset, bottom, horizontalOffset + width, bottom, Tool.rgba(0,0,0,opacity), 1);
			}.bind(this),
			resetTimeFuntion,
			incrementTimeFunction
		);
	}
	// unit name box
	var positions = [ // x, y, x2, y2,... coordiates.
		horizontalOffset, this.canvas.height,
		horizontalOffset, this.canvas.height - unitNameHeight,
		horizontalOffset + width, this.canvas.height - unitNameHeight,
		horizontalOffset + width, this.canvas.height
	];
	//this.drawPolygon(positions); // draw outline
	this.drawPolygon(positions, "#74984A", true); // draw fill
	// unit name
	this.drawText(unitName, parseInt(font) + horizontalOffset, this.canvas.height - unitNameHeight * 0.5, "black", font, "center", Math.PI * 0.5);
	// draw vertical ruler
	//this.drawLine(this.canvas.width - width - horizontalOffset, this.canvas.height, this.canvas.width - width - horizontalOffset, 0, "black", 1);
	this.drawLine(horizontalOffset + width, this.canvas.height, horizontalOffset + width, 0, "black", 1);
}
Timeline.prototype.drawIntervall = function(drawFunction, resetTimeFuntion, incrementTimeFunction){
	// function to call to print a block, function that floor a time object to desired unit, increment function that will add a desiret time unit
	// Example: Months
	/*
	this.drawIntervall(
		function(top, bottom, date){ // this will be called for each month block
			drawVerticalLine(verticalPos, top);
			drawText(date.getDate(), (top + bottom) * 0.5);
		}.bind(this),
		function(date){ // floor date to closest month
			date.setMilliseconds(0);
			date.setSeconds(0);
			date.setMinutes(0);
			date.setHours(0);
			date.setDate(1);
		},
		function(date){
			date.setMonth(date.getMonth() + 1); // increment by one month
		}
	);
	*/
	
	var debugMakeScreenSmallerFactor = 1;
	
	var center = this.position + this.zoom * 0.5;
	
	var date = new Date(center - this.zoom);
	resetTimeFuntion(date);
	
	var yPos = center - date.getTime();
	yPos *= 1 / this.zoom * this.canvas.height * debugMakeScreenSmallerFactor;
	var yPos0;
	var time0 = date.getTime();
	for(var i=0; yPos >= this.canvas.height * (1 - debugMakeScreenSmallerFactor); i++){
		yPos0 = yPos;
		yPos -= (date.getTime() - time0) / this.zoom * this.canvas.height * debugMakeScreenSmallerFactor;
		
		if(i != 0){
			drawFunction(yPos0, yPos, new Date(time0));
		}
		
		time0 = date.getTime();
		incrementTimeFunction(date);
	}
}
Timeline.prototype.timeToCanvasCoords = function(time){
	return -(time - this.position) / this.zoom * this.canvas.height + this.canvas.height * 0.5;
}
Timeline.prototype.drawText = function(string, xPos, yPos, color = "black", font = "24px Arial", alignment = "center", orientation = 0){
	this.ctx.textAlign = alignment;
	this.ctx.font = font;
	this.ctx.rotate(-orientation);
	yPos = this.canvas.height - yPos;
	var x = xPos * Math.cos(orientation) - yPos * Math.sin(orientation);
	var y = yPos * Math.cos(orientation) + xPos * Math.sin(orientation);
	this.ctx.fillStyle = color;
	this.ctx.fillText(string, x, y);
	this.ctx.rotate(orientation);
}
Timeline.prototype.drawBox = function(x1, y1, x2, y2, color = "black", fill = false, width = 1){
	this.ctx.beginPath();
	this.ctx.lineWidth = width;
	if(fill){
		this.ctx.fillStyle = color;
	}else{
		this.ctx.strokeStyle = color;
	}
	
	this.ctx.rect(x1, this.canvas.height - y1, x2 - x1, -(y2 - y1));
	
	if(fill){
		this.ctx.fill();
	}else{
		this.ctx.stroke();
	}
}
Timeline.prototype.drawVLine = function(width, length, xPos, yPos){
	this.ctx.beginPath();
	this.ctx.moveTo(xPos - length, this.canvas.height - yPos);
	this.ctx.lineTo(xPos + length, this.canvas.height - yPos);
	
	this.ctx.strokeStyle = "#AAAAAA";
	this.ctx.lineWidth = width;
	this.ctx.stroke();
}
Timeline.prototype.drawLine = function(x1, y1, x2, y2, color = "black", width = 1){
	this.ctx.beginPath();
	this.ctx.moveTo(x1, this.canvas.height - y1);
	this.ctx.lineTo(x2, this.canvas.height - y2);
	this.ctx.strokeStyle = color;
	this.ctx.lineWidth = width;
	this.ctx.stroke();
}
Timeline.prototype.drawPolygon = function(corners, color = "black", fill = false, width = 1){
	if(corners.length == 0){
		return;
	}
	this.ctx.beginPath();
	this.ctx.moveTo(corners[0], this.canvas.height - corners[1]);
	for (var i = 3; i < corners.length; i += 2){
		this.ctx.lineTo(corners[i-1], this.canvas.height - corners[i]);
	}
	if(fill){
		this.ctx.fillStyle = color;
	}else{
		this.ctx.strokeStyle = color;
	}
	this.ctx.lineWidth = width;
	if(fill){
		this.ctx.fill();
	}else{
		this.ctx.stroke();
	}
}
Timeline.prototype.utcToDays = function(utc){
	return utc / 1000 / 60 / 60 / 24;
}
Timeline.prototype.softRange = function(value, range, slope){
	// will clamp the value in between +- range. The slope tells the derivative of the function at value = 0.
	return range * value / (range / slope + Math.abs(value));
}
Timeline.prototype.softCenter = function(value, range, slope){
	// will make values closer to 0 roughly within range. 'slope' is the slope of the derivative at value = 0.
	return value * ((1 - 1 / (1 + Math.pow(Math.abs(value / range),5))) * (1 - slope) + slope);
}
Timeline.prototype.clamp = function(value, max, min){
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
// Button
function Button(){
	
}
// Tool
function Tool(){
	
}
Tool.rgba = function(r, g, b, a){
	return "rgba(" + r + "," + g + "," + b + "," + a + ")";
}







