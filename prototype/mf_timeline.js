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
// Timeline
function Timeline(container){
	//this.zoom = 10; // how much time is visible
	//this.position = 0; // what time is centered
	//this.targetPosition = this.position; // what day is centered
	this.zoom = 1000 * 60 * 60 * 24 * 10; // 10 days // how much time is visible
	this.position = new Date().getTime() + 1000 * 60 * 60 * 24 * 0.5; // what time is centered // "+" starts half a day behind
	this.targetPosition = this.position; // what day is centered
	
	this.loop = setInterval(this.render.bind(this), 1000/mf_timeline.fps);
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
	
	this.days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
	this.months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
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
Timeline.prototype.render = function(){
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
	this.position = (this.targetPosition - this.position) * 0.2 + this.position
	
	// render
	var maxRender = 100;
	// // minutes
	if(this.utcToDays(this.zoom) < (maxRender * 2) / (24 * 60)){ // 24 * 60 minutes per day
		this.drawIntervall(
			function(top, bottom, date){
				this.drawVLine(1, 25, this.canvas.width * 0.5, top);
				this.drawText(date.getMinutes(), this.canvas.width * 0.45, (top + bottom) * 0.5, 24, "center");
			}.bind(this),
			function(date){
				date.setMilliseconds(0);
				date.setSeconds(0);
			},
			function(date){
				date.setTime(date.getTime() + 1000 * 60);
			}
		);
	}
	// // hours
	if(this.utcToDays(this.zoom) < maxRender / 24){ // 24 hours per day
		this.drawIntervall(
			function(top, bottom, date){
				this.drawVLine(2, 50, this.canvas.width * 0.5, top);
				this.drawText(date.getHours(), this.canvas.width * 0.4, (top + bottom) * 0.5 + 600000000 / this.zoom, 24, "center");
			}.bind(this),
			function(date){
				date.setMilliseconds(0);
				date.setSeconds(0);
				date.setMinutes(0);
			},
			function(date){
				date.setTime(date.getTime() + 1000 * 60 * 60);
			}
		);
	}
	// // days
	if(this.utcToDays(this.zoom) < maxRender / 1){ // 1 / 1 day per day
		this.drawIntervall(
			function(top, bottom, date){
				this.drawVLine(3, 100, this.canvas.width * 0.5, top);
				this.drawText(this.days[date.getDay()], this.canvas.width * 0.5, (top + bottom) * 0.5, 24, "center");
				this.drawText(date.getDate(), this.canvas.width * 0.6, (top + bottom) * 0.5, 24, "right");
			}.bind(this),
			function(date){
				date.setMilliseconds(0);
				date.setSeconds(0);
				date.setMinutes(0);
				date.setHours(0);
			},
			function(date){
				date.setDate(date.getDate() + 1);
			}
		);
	}
	// weeks
	if(this.utcToDays(this.zoom) < maxRender * 7){ // 1 / 7 weeks per day
		this.drawIntervall(
			function(top, bottom, date){
				this.drawVLine(4, 150, this.canvas.width * 0.5, top);
				
				this.drawText("week: " + getWeekNumber(date), this.canvas.width * 0.9, (top + bottom) * 0.5, 24, "right");
				
				function getWeekNumber(date){
					var date2 = new Date(date.getTime());
					date2.setMilliseconds(0);
					date2.setSeconds(0);
					date2.setMinutes(0);
					date2.setHours(0);
					date2.setDate(1);
					date2.setMonth(0);
					return Math.floor((date.getTime() - date2.getTime()) / 1000 / 60 / 60 / 24 / 7) + 1;
				}
			}.bind(this),
			function(date){
				date.setMilliseconds(0);
				date.setSeconds(0);
				date.setMinutes(0);
				date.setHours(0);
				date.setDate(date.getDate() - (date.getDay() + 6) % 7);
			},
			function(date){
				date.setDate(date.getDate() + 7);
			}
		);
	}
	// // months
	if(this.utcToDays(this.zoom) < maxRender * 31){ // 1 / 31 months per day
		this.drawIntervall(
			function(top, bottom, date){
				this.drawVLine(5, 200, this.canvas.width * 0.5, top);
				this.drawText(this.months[date.getMonth()], this.canvas.width * 0.9, top, 24, "right");
			}.bind(this),
			function(date){
				date.setMilliseconds(0);
				date.setSeconds(0);
				date.setMinutes(0);
				date.setHours(0);
				date.setDate(1);
			},
			function(date){
				date.setMonth(date.getMonth() + 1);
			}
		);
	}
	// // years
	if(this.utcToDays(this.zoom) < maxRender * 365){ // 1 / 31 months per day
		this.drawIntervall(
			function(top, bottom, date){
				this.drawVLine(6, 250, this.canvas.width * 0.5, top);
				this.drawText(date.getFullYear(), this.canvas.width * 0.95, top, 24, "right");
			}.bind(this),
			function(date){
				date.setMilliseconds(0);
				date.setSeconds(0);
				date.setMinutes(0);
				date.setHours(0);
				date.setDate(1);
				date.setMonth(0);
			},
			function(date){
				date.setFullYear(date.getFullYear() + 1);
			}
		);
	}
	
	// endstuff
	// // save last touch positions
	for(var i=0; i<this.touchList.length; i++){
		var t = this.touchList[i];
		t.x0 = t.x;
		t.y0 = t.y;
	}
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
Timeline.prototype.drawText = function(string, xPos, yPos, fontSize = 24, alignment = "center"){
	this.ctx.textAlign = alignment;
	this.ctx.font = fontSize + "px Arial";
	this.ctx.fillText(string, xPos, this.canvas.height - yPos);
}
Timeline.prototype.drawVLine = function(width, length, xPos, yPos){
	this.ctx.beginPath();
	this.ctx.moveTo(xPos - length, this.canvas.height - yPos);
	this.ctx.lineTo(xPos + length, this.canvas.height - yPos);
	
	this.ctx.strokeStyle = "#AAAAAA";
	this.ctx.lineWidth = width;
	this.ctx.stroke();
}
Timeline.prototype.utcToDays = function(utc){
	return utc / 1000 / 60 / 60 / 24;
}

// Button
function Button(){
	
}






