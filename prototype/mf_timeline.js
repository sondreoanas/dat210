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
	this.start = start; // Unix milliseconds
	this.end = end; // Unix milliseconds
	this.nameBoxes = [{start:start, end:end}]; // list of x and y coordinates of possible name placements. Coordiantes are in Unix milliseconds
	this.name = name;
	this.color = color;
	this.horizontalOffset = 0;
	this.collisionGroup = []; // all colliding events
}
Event.nrOfEvents = 0;
Event.prototype.getBiggestNameBoxInView = function(top, bottom){
	// return index of the biggest index. -1 if none exist.
	var biggestIndex = -1;
	var biggestSize = 0;
	for(var i=0; i<this.nameBoxes.length; i++){
		var start = this.nameBoxes[i].start;
		var end = this.nameBoxes[i].end;
		start = Math.max(start, top);
		end = Math.min(end, bottom);
		var size = end - start;
		if(size > biggestSize){
			biggestSize = size;
			biggestIndex = i;
		}
	}
	return biggestIndex;
}
Event.prototype.clipNameBoxes = function(otherStart, otherEnd){
	// will clip, remove or split nameBoxes by the range given as the argument.
	var originalLength = this.nameBoxes.length;
	for(var i=0; i<originalLength; i++){
		var bStart = this.nameBoxes[i].start;
		var bEnd = this.nameBoxes[i].end;
		if(otherEnd < bStart || bEnd < otherStart){ // no collision
			continue;
		}
		if(otherStart < bStart){
			if(bEnd < otherEnd){ // nameBox is completely inside the other Event
				this.nameBoxes.splice(i, 1);
				i--;
				originalLength--;
				continue;
			}else{
				this.nameBoxes[i].start = otherEnd;
				continue;
			}
		}else{
			if(bEnd <= otherEnd){
				this.nameBoxes[i].end = otherStart;
				continue;
			}else{
				this.nameBoxes[i].end = otherStart;
				this.nameBoxes.push({start:otherEnd, end:bEnd});
				continue;
			}
		}
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
			start = new Date(2017, 8, 19, -11, 0).getTime(),
			end = new Date(2017, 8, 20, -11, 0).getTime(),
			name = "Prepare for exam",
			color = "turquoise"
		),
		new Event(
			start = new Date(2017, 8, 20, 9, 0).getTime(),
			end = new Date(2017, 8, 20, 13, 0).getTime(),
			name = "Exam",
			color = "blue"
		)
	];
	
	
	var str = "var rdn = [";
	for(var i=0; i<200; i++){
		str += i==0? "" : ",";
		str += Math.random();
	}
	str += "];";
	//console.log(str);
	
	var rdn = [0.32091453606388765,0.03206568377567365,0.3582179991756387,0.6919647023359796,0.9277414709881198,0.1878549956056026,0.9056281703927045,0.4626597451558703,0.5603963111769608,0.08769583685026228,0.7476976797361483,0.15133994929167915,0.4812818863149493,0.5935659110966249,0.3105901148557275,0.7238256921925468,0.8253647252690817,0.8352167281954577,0.6826171756934569,0.05211486372678453,0.8747450708549991,0.15166559154583892,0.45201576834383395,0.5575859848337765,0.17369986234531143,0.9274806156723976,0.7004275231734771,0.00226869919390027,0.32858180623740174,0.848748269698046,0.7770070190666452,0.26799323751491344,0.9822197669458366,0.9845105162511418,0.7695170988977229,0.8322995943024287,0.8896724661456432,0.08380532116394113,0.15389161516315686,0.39152371497892213,0.9187531083963374,0.5474927481591381,0.4500478734352087,0.3270705445782336,0.7256600585646922,0.9811885726281304,0.6659078195992849,0.2512703169992314,0.3643836639967972,0.3147959775647937,0.9549722668254184,0.23420852824479876,0.25487780136528104,0.7304896433900245,0.03999929739561048,0.02614203380097324,0.5123379877984102,0.14694742844321618,0.28224368177486325,0.0005717396430620081,0.11948223333779895,0.761102396058158,0.012529662477431591,0.14097423650072405,0.47343452697815724,0.263679491511259,0.09638919764876208,0.0582333916363631,0.6634555069744275,0.5444733878098607,0.39184290175790437,0.19024180256613898,0.05549863219884199,0.9928477582268154,0.5285475769054433,0.42784166883181474,0.7586026325584181,0.6032173344120284,0.1858102557288317,0.4765120707691066,0.8514278469194196,0.5896723535572421,0.7434457525527942,0.7216953574743372,0.3595161937442324,0.5628305488572791,0.0008395672460932424,0.560791117384166,0.376861815885561,0.3351901136099673,0.22556003893286158,0.7128174390010737,0.3019321775668322,0.7066722947189927,0.7737224538162835,0.6371952817188353,0.3753928499607191,0.7870533423775159,0.8114543609320384,0.786566703427489,0.5018160952054622,0.9610271151800713,0.290880115271305,0.9967969391681728,0.11169989330827823,0.08480474899449919,0.6646640535424471,0.32758077986829215,0.03894345354763962,0.5183790710694218,0.5460349405237099,0.7460481848904692,0.7632632178502687,0.8646618336497505,0.5164221414259629,0.9585963152232895,0.5737211854275002,0.5794242637290241,0.31007507775216014,0.5303529890943663,0.19386005529774875,0.6720988744291712,0.24357631516840428,0.8180806949086219,0.9276035376288725,0.717384298007997,0.42761950789830205,0.2723558619886739,0.6810900667188267,0.1349126994865868,0.06659100494582271,0.5873446109201699,0.4831039944618536,0.04106353536959828,0.28548481980172324,0.9466083598114006,0.4907976175377595,0.38594697040386805,0.3579374934171824,0.58183723261734,0.8615560961875963,0.06481501626329234,0.4713223845862782,0.4803742092877754,0.18982265415977717,0.34251041884602085,0.5056774142119413,0.42401322916370665,0.4077466131565164,0.8017810637586136,0.04916610917777664,0.7494972355457852,0.18222981625973067,0.867662124357546,0.7811952722712492,0.26401771517655614,0.6631435512657844,0.4153301670462275,0.48076560975462046,0.0033216550319603577,0.6602784212759316,0.8589224462901395,0.6987097854455528,0.13371064721961967,0.2114954930329871,0.138442866876489,0.30637531300433474,0.271054250665411,0.9315865668074672,0.5490010820797617,0.5438181413476193,0.5929372747971187,0.9671730734198702,0.39049792443901055,0.5371380026193171,0.4103452890187307,0.06769911482994817,0.7838268429818469,0.14372902162549583,0.863848863515033,0.2378638641488593,0.044866301313351675,0.039815862695010695,0.308117831886215,0.8600651610205416,0.2840144294867344,0.8218627321041876,0.2432903708362768,0.4145398188035678,0.013500493218422616,0.5951741938574022,0.9196628754992722,0.5623302072069456,0.8448115786490631,0.4154645990550636,0.514147869764914,0.9673763364403436,0.8031230688978386,0.7789393590522597,0.0077992653276159896]
	
	
	var origo = new Date().getTime();
	for(var i=0; i<30; i++){
		//var radius = Math.pow(Math.random(), 2) * 1000 * 60 * 60 * 24 * 5 + 1000 * 60;
		var radius = Math.pow(rdn[i * 2], 0.5) * 1000 * 60 * 60 * 24 * 2 + 1000 * 60;
		//var t = origo + (0.5 - Math.random()) * 1000 * 60 * 60 * 24 * 100;
		var t = origo + (0.5 - rdn[i * 2 + 1]) * 1000 * 60 * 60 * 24 * 100;
		this.events.push(new Event(
			start = new Date(t - radius).getTime(),
			end = new Date(t + radius).getTime(),
			name = "event nr:" + Event.nrOfEvents,
			color = Tool.randomColor(1)
		));
	}
	//
	this.calcuateEventCollisions();
}
Timeline.prototype.calcuateEventCollisions = function(event){
	// reset all
	for(var i=0; i<this.events.length; i++){
		var e = this.events[i];
		e.horizontalOffset = 0;
		e.nameBoxes = [{start:e.start, end:e.end}];
		e.collisionGroup = [e];
	}
	// horizontal offset
	/*var isDone;
	while(!isDone){
		isDone = true;
		for(var i=0; i<this.events.length; i++){
			var e1 = this.events[i];
			for(var j=i+1; j<this.events.length; j++){
				var e2 = this.events[j];
				if(e1.end > e2.start && e1.start < e2.end){ // is colliding
					// offset calculation
					if(e1.horizontalOffset == e2.horizontalOffset){ // has same offset
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
	}*/
	// // create collision groups
	var collisionGroups = []; // 2d array of colliding objects
	for(var i=0; i<this.events.length; i++){
		var e1 = this.events[i];
		for(var j=i+1; j<this.events.length; j++){
			var e2 = this.events[j];
			if(e1.end > e2.start && e1.start < e2.end){ // is colliding
				// remove old group(s)
				var index;
				if((index = collisionGroups.indexOf(e1.collisionGroup)) != -1){
					collisionGroups.splice(index, 1);
				}
				if((index = collisionGroups.indexOf(e2.collisionGroup)) != -1){
					collisionGroups.splice(index, 1);
				}
				// create new group
				var newGroup = e1.collisionGroup;
				if(e2.collisionGroup != e1.collisionGroup){
					newGroup = newGroup.concat(e2.collisionGroup);
				}
				// assign group
				for(var k=0; k<newGroup.length; k++){
					newGroup[k].collisionGroup = newGroup;
				}
				collisionGroups.push(newGroup);
			}
		}
	}
	// // calculate offset
	for(var i=0; i<collisionGroups.length; i++){
		var group = collisionGroups[i];
		for(var j=0; j<group.length; j++){
			group[j].horizontalOffset = j - (group.length - 1) * 0.5;
		}
	}
	// name boxes
	for(var i=0; i<this.events.length; i++){
		var e1 = this.events[i];
		for(var j=i+1; j<this.events.length; j++){
			var e2 = this.events[j];
			if(e1.end > e2.start && e1.start < e2.end){ // is colliding
				// name box calculation
				if(e1.id > e2.id){ // highest id is on top
					e2.clipNameBoxes(e1.start, e1.end);
				}else{
					e1.clipNameBoxes(e2.start, e2.end);
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
		var horizontalPosition = e.horizontalOffset * (this.canvas.width - horizontalRulerWidth) * 0.05 +
			horizontalRulerWidth + (this.canvas.width - horizontalRulerWidth) * 0.5;
		this.drawBox(horizontalPosition - boxWidth * 0.5, this.timeToCanvasCoords(e.end),
			horizontalPosition + boxWidth * 0.5, this.timeToCanvasCoords(e.start),
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
		
		// calcuate yPos
		var nameBoxIndex = e.getBiggestNameBoxInView(this.canvasCoordsToTime(this.canvas.height), this.canvasCoordsToTime(0));
		if(nameBoxIndex != -1){
			max = this.timeToCanvasCoords(e.nameBoxes[nameBoxIndex].start);
			min = this.timeToCanvasCoords(e.nameBoxes[nameBoxIndex].end);
			if(max < top){
				top = max;
			}
			if(min > bottom){
				bottom = min;
			}
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
		// draw name
		this.drawText(e.name, horizontalPosition, yPos, Tool.rgba(255,255,255,opacity), font, alignment = "center", orientation = 0)
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
Timeline.prototype.canvasCoordsToTime = function(coords){ // TODO: rename to 'pixels to time'
	return this.zoom * (0.5 - coords / this.canvas.height) + this.position;
}
Timeline.prototype.timeToCanvasCoords = function(time){ // TODO: rename to 'time to pixels'
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
Tool.randomColor = function(brightness = Math.random()){
	var r = Math.random() * 256;
	var g = Math.random() * 256;
	var b = Math.random() * 256;
	var f = brightness / (r + g + b) * 255;
	r *= f;
	g *= f;
	b *= f;
	return "rgba(" + Math.floor(r) + "," + Math.floor(g) + "," + Math.floor(b) + ",1)";
}







