/*
	mf_timeline_render.js
	version			: 0.5.4
	last updated	: 03.12.2017
	name			: Markus Fjellheim
	description		:
		What does this do?
			This does rendering for the timeline
*/
Timeline.prototype.render = function(){ // TODO: abstract better
	// // clear
	this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
	
	// // render content
	if(this.mode == Timeline.timelineView){
		this.renderTimeline();
	}else if(this.mode == Timeline.taskView){
		this.renderTaskView();
	}else{
		Tool.printError("Timeline mode not found.");
	}
	
	// // render buttons
	this.renderButtons();
	
	// render overlay
	if(this.status == Timeline.addEventSetStart || this.status == Timeline.addEventSetEnd){
		// // grey out area outside placementRange;
		// // // left side
		var rangeStart = this.timeToCanvasCoords(this.placementRange.start);
		var rangeEnd = this.timeToCanvasCoords(this.placementRange.end);
		var color = new Color(0,0,0,0.1).toString();
		if(rangeStart > 0){
			this.drawBox(0, 0, Math.min(this.canvas.width, rangeStart), this.canvas.height, color, true);
		}
		if(rangeEnd < this.canvas.width){
			this.drawBox(Math.max(0, rangeEnd), 0, this.canvas.width, this.canvas.height, color, true);
		}
		
		// // draw selection rulers
		var startPosition = this.timeToCanvasCoords(this.startTime);
		if(this.status == Timeline.addEventSetEnd){
			var endPosition = this.timeToCanvasCoords(this.endTime);
		}
		var height = this.canvas.height * 0.3;
		// // // start
		var left = startPosition;
		var right = startPosition + this.canvas.width * 0.1;
		var color = "grey";
		if(this.status == Timeline.addEventSetEnd && right > endPosition){
			right = endPosition;
			if(this.startTime >= this.endTime){
				color = "red";
			}
		}
		if(right < left){
			right = left;
		}
		this.drawPolygon([
				right, this.canvas.height * 0.4 + height,
				left, this.canvas.height * 0.4 + height,
				left, 0 + height,
				right, 0 + height
			], color, false, 5);
		// // // end
		if(this.status == Timeline.addEventSetEnd){
			var right = endPosition;
			var left = endPosition - this.canvas.width * 0.1;
			if(left < startPosition){
				left = startPosition;
			}
			if(left > right){
				left = right;
			}
			this.drawPolygon([
					left, this.canvas.height * 0.4 + height,
					right, this.canvas.height * 0.4 + height,
					right, this.canvas.height * 0 + height,
					left, this.canvas.height * 0 + height
				], color, false, 5);
		}
	}
	
	// cursor text
	var font = "24px Arial";
	var width = Tool.widthOfString(this.cursorInfo, font);
	var height = Tool.getFontHeight(font);
	var x = this.mouseData.pos.x;
	var y = this.mouseData.pos.y;
	if(x < width * 0.5){
		x = width * 0.5;
	}else if(x > this.canvas.width - width * 0.5){
		x = this.canvas.width - width * 0.5
	}
	if(y < height * 0.5){
		y = height * 0.5;
	}else if(y > this.canvas.height - height * 0.5){
		y = this.canvas.height - height * 0.5;
	}
	this.drawText(this.cursorInfo, x, y - height * 0.3, "black", font);
	
	// // draw filter
	if(!this.isActive){
		this.drawBox(0, 0, this.canvas.width, this.canvas.height, color = Tool.rgba(255,255,255,0.5), fill = true, width = 0);
	}
}
Timeline.prototype.renderTaskView = function(){
	// calculate target positions
	calcPosition(this.canvas, null, this.tasks);
	function calcPosition(canvas, parent, tasks){
		var offset = -1;
		var parentDisplacement = 0;
		for(var i=0; i<tasks.length; i++){
			var t = tasks[i];
			if(!t.visibility){
				continue;
			}
			offset++;
			
			if(parent != null){
				t.targetPosition1 = new Vec(parent.targetPosition1.x + parent.width * 0.5 + t.width * 0.5,
					parent.targetPosition1.y + parent.height * 0.5 - t.height * 0.5 - t.height * offset);
			}else{
				//t.targetPosition1 = new Vec(canvas.width * 0.05 + t.width * 0.5, (canvas.height - t.height * 1.5) - t.height * offset);
				t.targetPosition1 = new Vec(canvas.width * 0.05 + t.width * 0.5, (canvas.height * 0.9 - t.height * 0.5) - parentDisplacement);
				parentDisplacement += t.height;
			}
			calcPosition(canvas, t, t.children);
		}
	};
	// move towards target positions
	calcMovement(this.tasks);
	function calcMovement(tasks){
		for(var i=0; i<tasks.length; i++){
			var t = tasks[i];
			calcMovement(t.children);
			
			var movementSpeed = 0.1
			t.targetPosition0 = Vec.lerp(t.targetPosition0, t.targetPosition1, movementSpeed);
			t.position = Vec.lerp(t.position, t.targetPosition0, movementSpeed);
		}
	};
	// render
	renderTask(this, this.tasks);
	function renderTask(that, tasks){
		for(var i=0; i<tasks.length; i++){
			var t = tasks[i];
			if(!t.visibility){
				continue;
			}
			renderTask(that, t.children)
			
			// background
			var color1;
			if(t.isDone){
				color1 = new Color(200,200,200);
			}else{
				color1 = new Color(100,255,100);
			}
			color2 = Color.mulRGB(color1, 0.8);
			that.drawRectOutline(t.position.x - t.width * 0.5, t.position.y - t.height * 0.5,
				t.position.x + t.width * 0.5, t.position.y + t.height * 0.5,
				color1, color2, 1);
			// name
			that.drawText(t.name, t.position.x, t.position.y, new Color(255,255,255));
		}
	};
	
	// render outline
	renderTaskOutline(this, this.tasks);
	function renderTaskOutline(that, tasks){
		for(var i=0; i<tasks.length; i++){
			var t = tasks[i];
			if(!t.visibility){
				continue;
			}
			renderTaskOutline(that, t.children)
			
			// marker
			if(t.children.length != 0 || !t.isHoveredOver || t.isDone){
				continue;
			}
			var borderWidth = 12 + Math.sin(that.tick * 0.25) * 4;
			var borderDistance = 10;
			
			that.drawBox(t.position.x - t.width * 0.5 - borderDistance, t.position.y - t.height * 0.5 - borderDistance,
				t.position.x + t.width * 0.5 + borderDistance, t.position.y + t.height * 0.5 + borderDistance, color = "yellow", false, borderWidth);
			
		}
	};
}
Timeline.prototype.renderTimeline = function(){
	// render now bar
	var nowTime = new Date().getTime();
	var pixelNow = this.timeToCanvasCoords(nowTime);
	this.drawLine(pixelNow, 0, pixelNow, this.canvas.height, new Color(255,0,0, 0.5), 3);
	
	// render events
	this.renderEvents(this.verticalRulerHeight + (this.canvas.height - this.verticalRulerHeight) * 0.5, this.verticalRulerHeight);
	
	// render date structure
	this.renderDateStructure();
	
	// render tasks in timeline
	this.renderTasksInTimeline();
}
Timeline.prototype.renderTasksInTimeline = function(){
	var boxHeight = this.canvas.height * 0.05;
	var offset = 0;
	for(var i=0; i < this.tasks.length; i++){
		var atLeastOneIsInView = false;
		var t = this.tasks[i];
		var time = this.canvasCoordsToTime(0);
		if(time == -1){
			alert("!");
			continue;
		}
		var counter = 0;
		while(true){
			counter ++;
			if(counter == 10000){
				debugger;
				break;
			}
			var range = t.getRange(time);
			if(this.timeToCanvasCoords(range.start) > this.canvas.width){
				break;
			}
			atLeastOneIsInView = true;
			var left = this.timeToCanvasCoords(range.start);
			var right = this.timeToCanvasCoords(range.end);
			var top = this.canvas.height * 0.90 - offset * 1.1 * boxHeight;
			var bottom = this.canvas.height * 0.90 - (offset * 1.1 + 1) * boxHeight;
			
			// render
			// // render box
			this.drawBox(left, bottom,
				right, top, "#005050", true, 0);
			var font = "24px Arial";
			var nameHeight = Tool.getFontHeight(font);
			var nameWidth = Tool.widthOfString(t.name, font);
			// render name
			var visibleLeft = left;
			if(left < 0){
				visibleLeft = 0;
			}
			var visibleRight = right;
			if(right > this.canvas.width){
				visibleRight = this.canvas.width;
			}
			var opacity = 1;
			if(visibleRight - visibleLeft < nameWidth){
				opacity = - 4 + 5 * (visibleRight - visibleLeft) / nameWidth;
			}
			this.drawText(t.name, (visibleLeft + visibleRight) * 0.5, (top + bottom) * 0.5 - 0.5 * nameHeight, new Color(255, 255, 255, opacity));
			//
			time = range.end + 1;
		}
		if(atLeastOneIsInView){
			offset++;
		}
	}
}
Timeline.prototype.renderButtons = function(){
	for(var i=0; i<this.buttons.length; i++){
		this.drawButton(this.buttons[i]);
	}
}
Timeline.prototype.renderDateStructure = function(){
	var offset = 0;
	// // year
	this.drawUnit(this.unitNameHeight, "YEAR", this.unitNameWidth, offset,
		function getNameFunction(date){
			return date.getFullYear();
		},
		function resetTimeFuntion(date){
			Tool.resetDateTo(date, Tool.year);
		},
		function incrementTimeFunction(date){
			Tool.incrementDateTo(date, Tool.year, 1);
		}
	);
	offset += this.unitNameHeight;
	// // month
	this.drawUnit(this.unitNameHeight, "MONTH", this.unitNameWidth, offset,
		function getNameFunction(date){
			return this.months[date.getMonth()];
		}.bind(this),
		function resetTimeFuntion(date){
			Tool.resetDateTo(date, Tool.month);
		},
		function incrementTimeFunction(date){
			Tool.incrementDateTo(date, Tool.month, 1);
		}
	);
	offset += this.unitNameHeight;
	// // week
	this.drawUnit(this.unitNameHeight, "WEEK", this.unitNameWidth, offset,
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
			Tool.resetDateTo(date, Tool.week);
		},
		function incrementTimeFunction(date){
			Tool.incrementDateTo(date, Tool.week, 1);
		}
	);
	offset += this.unitNameHeight;
	// // day
	this.drawUnit(this.unitNameHeight, "DAY", this.unitNameWidth, offset,
		function getNameFunction(date){
			return this.days[date.getDay()] + " #" + date.getDate();
		}.bind(this),
		function resetTimeFuntion(date){
			Tool.resetDateTo(date, Tool.day);
		},
		function incrementTimeFunction(date){
			Tool.incrementDateTo(date, Tool.day, 1);
		}
	);
	offset += this.unitNameHeight;
	// // hour
	this.drawUnit(this.unitNameHeight, "HOUR", this.unitNameWidth, offset,
		function getNameFunction(date){
			var hours = date.getHours().toString();
			if(hours.length == 1){
				hours = "0" + hours;
			}
			return hours + ":00";
		}.bind(this),
		function resetTimeFuntion(date){
			Tool.resetDateTo(date, Tool.hour);
		},
		function incrementTimeFunction(date){
			Tool.incrementDateTo(date, Tool.hour, 1);
		}
	);
	offset += this.unitNameHeight;
	// // minute
	this.drawUnit(this.unitNameHeight, "Minute", this.unitNameWidth, offset,
		function getNameFunction(date){
			var minutes = date.getMinutes().toString();
			if(minutes.length == 1){
				minutes = "0" + minutes;
			}
			return "" + ":" + minutes;
		}.bind(this),
		function resetTimeFuntion(date){
			Tool.resetDateTo(date, Tool.minute);
		},
		function incrementTimeFunction(date){
			Tool.incrementDateTo(date, Tool.minute, 1);
		}
	);
	offset += this.unitNameHeight;
}
Timeline.prototype.renderEvents = function(eventSpaceTop, eventSpaceBottom){
	for(var i=0; i<this.events.length; i++){
		var e = this.events[i];
		// is outside of view
		if(e.end < this.position - this.zoom * 0.5 || e.start > this.position + this.zoom * 0.5){
			continue;
		}
		// draw box
		var boxHeight = this.canvas.height * 0.3;
		var verticalPosition = e.verticalOffset * (eventSpaceTop - eventSpaceBottom) * 0.1 +
			(eventSpaceTop + eventSpaceBottom) * 0.5;
		var bottom = verticalPosition - boxHeight * 0.5;
		var top = verticalPosition + boxHeight * 0.5;
		var left = this.timeToCanvasCoords(e.start);
		var right = this.timeToCanvasCoords(e.end);
		this.drawBox(left, bottom,
			right, top,
			e.color, true, 1);
		// calcuate name placement
		var xPos, yPos, orientation, opacity;
		var font = "24px Arial";
		var nameHeight = Tool.getFontHeight(font);
		var nameWidth = Tool.widthOfString(e.name, font);
		
		var visibleLeft = Math.max(left, 0);
		var visibleRight = Math.min(right, this.canvas.width);
		var visibleLength = visibleRight - visibleLeft;
		
		var nameBoxIndex = e.getBiggestNameBoxInView(this.canvasCoordsToTime(0), this.canvasCoordsToTime(this.canvas.width));
		var nameBoxLeft, nameBoxRight;
		var visibleNameBoxLeft, visibleNameBoxRight, visibleNameBoxLength;
		if(nameBoxIndex != -1){
			nameBoxLeft = this.timeToCanvasCoords(e.nameBoxes[nameBoxIndex].start);
			nameBoxRight = this.timeToCanvasCoords(e.nameBoxes[nameBoxIndex].end);
			visibleNameBoxLeft = Math.max(nameBoxLeft, 0);
			visibleNameBoxRight = Math.min(nameBoxRight, this.canvas.width);
			visibleNameBoxLength = visibleNameBoxRight - visibleNameBoxLeft;
		}
		// name placement and orientation
		// no center position avalible || even a vertical name would not fit || the name would have to be tilted && it would fully fit at the bottom
		if(nameBoxIndex == -1 || nameHeight > visibleNameBoxLength || visibleNameBoxLength - nameHeight*0 < nameWidth && nameWidth < visibleLength){ // too little splace
			yPos = bottom + nameHeight * 0.1;
			xPos = visibleLeft + visibleLength * 0.5;
			orientation = 0;
			if(visibleLength < nameWidth){
				//opacity = - 1 + 2 * visibleLength / nameWidth;
				opacity = 0;
			}else{
				opacity = 1;
			}
		}else{
			yPos = (top + bottom) * 0.5;
			xPos = visibleNameBoxLeft + visibleNameBoxLength * 0.5;
			if(visibleNameBoxLength - nameHeight > nameWidth){
				orientation = 0;
			}else{
				orientation = Math.acos((visibleNameBoxLength - nameHeight) / nameWidth);
			}
			opacity = 1;
			xPos += nameHeight * 0.3;
		}
		
		this.drawText(e.name, xPos, yPos, Tool.rgba(255,255,255,opacity), font, alignment = "center", orientation = orientation);
	}
}
Timeline.prototype.drawUnit = function(height, unitName, unitNameWidth, verticalOffset, getNameFunction, resetTimeFuntion, incrementTimeFunction){
	// This function will render one time-unit, for example a month. height is height of the unit label, in this case "MONTH".
	// unitName is the name of the unit, for example "MONTH". VerticalOffset is how hight up from the bottom of the canvas the unit name will
	// be rendered. GetNameFunction(date) will take a date object and gives the value of that moment in time according to some time unit,
	// if the time unit is month, the value could be "january". ResetTimeFuntion resets the time back to for example the beginning of the month.
	// IncrementTimeFunction increments time by for example one month.
	
	// calculate fading
	// // calcuate approximate interval width
	var date = new Date(Timeline.getTimeNow());
	resetTimeFuntion(date);
	var time0 = date.getTime();
	incrementTimeFunction(date);
	var intervalPeriod = date.getTime() - time0;
	var periodSize = intervalPeriod / this.zoom * this.canvas.width; // [this.zoom] = time / canvas width
	// // calcuate name size
	var unitValueName = getNameFunction(date);
	var font = "24px Arial";
	var nameSize = Tool.widthOfString(unitValueName, font);
	// // calcuate opacity value
	var opacity;
	if(nameSize * 2 > periodSize){
		//opacity = 1 - (nameSize * 2 - periodSize) * 0.01;
		opacity = 2 - nameSize * 2 / periodSize;
	}else{
		opacity = 1;
	}
	
	// draw intervals
	var opacityMargin = 6;
	if(opacity > -opacityMargin){
		this.drawIntervall(
			function(right, left, date){
				// calcuate vertical position of unit value. For example day = tuesday.
				var font = "24px Arial"; // TODO: abstract this outside function
				var unitValueName = getNameFunction(date); // eksample: 'week: 5'
				this.ctx.font = font;
				var margin = this.ctx.measureText(unitValueName).width;
				var xPos = Tool.clamp(this.canvas.width * 0.5, right - margin, left + margin);
				// draw unit name
				this.drawText(unitValueName, xPos, verticalOffset + 0.3 * Tool.getFontHeight(font), Tool.rgba(0,0,0,opacity), font, "center", 0);
				// draw horizontal ruler to seperate the units
				var textOpacity = (opacity + opacityMargin) * 0.1;
				this.drawLine(right, this.verticalRulerHeight, right, this.canvas.height, Tool.rgba(0,0,0, textOpacity), 2);
				this.drawLine(right, verticalOffset, right, verticalOffset + height, Tool.rgba(0,0,0, textOpacity), 2);
			}.bind(this),
			resetTimeFuntion,
			incrementTimeFunction
		);
		// store resolution functions for later use
		this.resetTimeFuntion = resetTimeFuntion;
		this.incrementTimeFunction = incrementTimeFunction;
	}
	// unit name box
	var positions = [ // x, y, x2, y2,... coordiates.
		this.canvas.width, verticalOffset,
		this.canvas.width - unitNameWidth, verticalOffset,
		this.canvas.width - unitNameWidth, verticalOffset + height,
		this.canvas.width, verticalOffset + height
	];
	//this.drawPolygon(positions); // draw outline
	this.drawPolygon(positions, "#74984A", true); // draw fill
	// unit name
	this.drawText(unitName, this.canvas.width - unitNameWidth * 0.5, verticalOffset + 0.3 * Tool.getFontHeight(font), "black", font, "center", 0);
	// draw vertical ruler
	//this.drawLine(this.canvas.width - width - horizontalOffset, this.canvas.height, this.canvas.width - width - horizontalOffset, 0, "black", 1);
	this.drawLine(this.canvas.width, verticalOffset + height, 0, verticalOffset + height, "black", 1);
}
Timeline.prototype.drawIntervall = function(drawFunction, resetTimeFuntion, incrementTimeFunction){
	// The arguments are:
	// (function to call to print a block, function that floor a time unit for example month -> beginning of february,
	// increment function that will increment a date object by one timeunit)
	// Example: Months
	/* TODO: update this example for horizontal view
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
	
	var t = date.getTime();
	var t0;
	
	while(this.timeToCanvasCoords(t) <= this.canvas.width){
		t0 = t;
		incrementTimeFunction(date);
		t = date.getTime();
		drawFunction(this.timeToCanvasCoords(t),
			this.timeToCanvasCoords(t0),
			new Date(t0));
	}
}
Timeline.prototype.drawButton = function(button){
	if(!button.visibility){
		return;
	}
	switch(button.shape){
		case Button.circle:
			this.drawCircleOutline(
				x = button.pos.x, y = button.pos.y, r = button.radius,
				colorFill = button.color, colorOutline = Color.mulRGB(button.color, 0.8), width = 5);
			break;
		case Button.square:
			this.drawRectOutline(
				x1 = button.pos.x - button.width * 0.5, y1 = button.pos.y - button.height * 0.5,
				x2 = button.pos.x + button.width * 0.5, y2 = button.pos.y + button.height * 0.5,
				colorFill = button.color, colorOutline = Color.mulRGB(button.color, 0.8), width = 5);
			break;
	}
	this.drawText(button.name, button.pos.x, button.pos.y - 24 * 0.25, new Color(255,255,255,1));
	
}
Timeline.prototype.drawText = function(name, xPos, yPos, color = "black", font = "24px Arial", alignment = "center", orientation = 0){
	this.ctx.textAlign = alignment;
	this.ctx.font = font;
	this.ctx.rotate(-orientation);
	yPos = this.canvas.height - yPos;
	var x = xPos * Math.cos(orientation) - yPos * Math.sin(orientation);
	var y = yPos * Math.cos(orientation) + xPos * Math.sin(orientation);
	this.ctx.fillStyle = color;
	this.ctx.fillText(name, x, y);
	this.ctx.rotate(orientation);
}
Timeline.prototype.drawCircleOutline = function(x, y, r, colorFill = new Color(), colorOutline = new Color(), width = 1){
	this.ctx.beginPath();
	//this.ctx.rect(x1, this.canvas.height - y1, x2 - x1, -(y2 - y1));
	this.ctx.arc(x, this.canvas.height - y, r, 0, 2 * Math.PI);
	
	this.ctx.fillStyle = colorFill.toString();
	this.ctx.fill();
	
	this.ctx.lineWidth = width;
	this.ctx.strokeStyle = colorOutline.toString();
	this.ctx.stroke();
}
Timeline.prototype.drawRectOutline = function(x1, y1, x2, y2, colorFill = new Color(), colorOutline = new Color(), width = 1){
	this.ctx.beginPath();
	this.ctx.rect(x1, this.canvas.height - y1, x2 - x1, -(y2 - y1));
	
	this.ctx.fillStyle = colorFill.toString();
	this.ctx.fill();
	
	this.ctx.lineWidth = width;
	this.ctx.strokeStyle = colorOutline.toString();
	this.ctx.stroke();
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













