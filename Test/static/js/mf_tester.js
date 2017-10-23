/*
	mf_tester.js
	
	version			: 0.1.1
	last updated	: 23.10.2017
	name			: Markus Fjellheim
	description		:
		What does this do?
			This will perform testing. Clicking buttons and filling in forms
		How to use it?
			see mf_testHandelerInstructions.txt
		What is new?
			see mf_testHandelerInstructions.txt
*/

function mf_Cursor(){
	this.pos = new Vec();
	this.targetPos = new Vec();
	
	this.vel = new Vec();
	this.acc = 50;
	
	this.noise = new Vec();
	this.noiseFactor = 0;
	
	this.img = document.createElement("img");
	this.hide();
	this.img.src = "https://images.vexels.com/media/users/3/131771/isolated/preview/052dd0c023d9db3d5244875791c71c54-pixilated-arrow-cursor-by-vexels.png";
	
	this.width = 47;
	this.height = 47;
	this.img.style.width = this.width + "px";
	this.img.style.height = this.height + "px";
	this.img.style.position = "fixed";
	this.setGraphicCoords(0,0);
	
	var body = document.getElementsByTagName("body")[0];
	body.appendChild(this.img);
}
mf_Cursor.prototype.hide = function(){
	this.img.style.display = "none";
}
mf_Cursor.prototype.show = function(){
	this.img.style.display = "inline";
}
mf_Cursor.prototype.setGraphicPos = function(pos){
	this.setGraphicCoords(pos.x, pos.y);
}
mf_Cursor.prototype.setGraphicCoords = function(x, y){
	this.pos.setCoords(x, y);
	this.img.style.left = (-this.width * 5/22 + x) + "px";
	this.img.style.top = (-this.height * 1/22 + y) + "px";
}

function mf_TestHandeler(){
	this.tick;
	this.fps;
	this.loop;
	
	this.cursor;
	this.commands;
	this.currentCommand;
	
	this.inactivity;
	
	this.recordedCommands;
	
	this.timelines;
	
	this.control;
	
	this.waitTime;
	
	this.isRunning;
	
	// command indexes
	this.click;
	this.type;
	this.timelineScroll;
	this.timelineZoom;
	this.timelineIsActive;
}
mf_TestHandeler.prototype.init = function(){
	this.tick = -1;
	this.fps = 30;
	
	this.cursor = new mf_Cursor();
	
	this.commands = [];
	this.currentCommandIndex = 0;
	this.currentCommand;
	
	this.inactivity = 0;
	
	this.recordedCommands = "var dataList = [\n";
	
	this.timelines = [];
	
	this.control = new mf_Control();
	this.control.addKeyDownEventListener(function(){
		if(this.control.ctrl.isDown && this.control.shift.isDown && this.control.s.isDown){ // start end recording
			this.control.reset(); // alerts will prevent keyup to be recognized
			if(this.isRunning){
				this.start(); // error message will appear
				return;
			}
			var speed
			while(true){
				speed = prompt("Set playspeed. Nothing will default to 10");
				if(parseFloat(speed)){
					this.start(parseFloat(speed));
					break;
				}else if(speed == ""){
					this.start();
					break;
				}else{
					alert("Wrong input. Type a number or leave field empty.");
					continue;
				}
			}
		}else if(this.control.ctrl.isDown && this.control.shift.isDown && this.control.c.isDown){ // save recording
			this.control.reset(); // alerts will prevent keyup to be recognized
			if(Tool.copyStringToClipboard(this.getRecord())){
				alert("Commands are now copied to clipboard. Paste the commands to\n\"/js/mf_testerData.js\", reload page and press" +
					"\"ctrl\" + \"shift\" + \"s\"\nto start playback.");
			}else{
				alert("Something went wrong whe copying commands to clipboard. Try running \"mf_testHandeler.getRecord()\" in the console instead.");
			}
		}
	}.bind(this));
	
	this.isRunning = false;
	
	this.waitTime = 0;
	
	// command indexes
	this.click = 0;
	this.type = 1;
	this.timelineScroll = 2;
	this.timelineZoom = 3;
	this.timelineIsActive = 4;
	
	// load data
	this.getData();
}
mf_TestHandeler.prototype.addRecordTimeline = function(timeline){
	this.timelines.push({
		timeline: timeline,
		position: timeline.targetPosition,
		zoom: timeline.zoom,
		isActive: timeline.isActive
	});
}
mf_TestHandeler.prototype.start = function(acceleration = 10, noiseFactor = 0){
	if(this.isRunning){
		var s;
		var message = "A test is already in progress. Do you want to cancel it? \"y\"/\"n\".\n(No input means yes, cancel means no)";
		while(true){
			s = prompt(message);
			if(s == "y" || s == "yes" || s == "j" || s == "ja" || s == ""){
				clearInterval(this.loop);
				console.info("The test was canceled!");
				this.endTest();
				break;
			}else if(!s || s == "n" || s == "no" || s == "nei"){
				break;
			}
			message = "Do you want to cancel the test? \"y\"/\"n\".\n(No input means yes, cancel means no)\nUnrecognized input. Try again.";
		}
		return;
	}
	this.isRunning = true;
	this.cursor.acc = acceleration;
	this.cursor.noiseFactor = noiseFactor;
	this.cursor.show();
	this.loop = setInterval(this.intervalLoop.bind(this), 1000 / this.fps);
}
mf_TestHandeler.prototype.intervalLoop = function(){
	this.tick++;
	
	// check if success
	if(this.currentCommandIndex == this.commands.length){
		clearInterval(this.loop);
		console.info("The test was completed successfully!");
		this.endTest();
		return;
	}else if(this.inactivity > 4 * this.fps){
		clearInterval(this.loop);
		console.info("The test failed due to timeout!");
		this.endTest();
		return;
	}
	
	//
	this.currentCommand = this.commands[this.currentCommandIndex];
	
	// calculate cursor behaviour
	this.calculateCursorBehaviour();
	
	// animate
	this.animate();
	
}
mf_TestHandeler.prototype.calculateCursorBehaviour = function(){
	// calculate destination
	var targetElement = document.getElementById(this.currentCommand.startId);
	if(!targetElement){
		console.warn("mf_testHandeler: cannot find element with id \"" + this.currentCommand.startId + "\".\n");
			this.inactivity++;
		return;
	}
	for(var i=0; i<this.currentCommand.path.length; i++){
		if(this.currentCommand.path[i] >= targetElement.children.length){
			console.warn("mf_testHandeler: cannot find child of element with id \"" + this.currentCommand.startId + "\".\n" +
				"(path index: " + i + ", at list element nr " + this.currentCommandIndex + " is longer than the number of children at this level)");
			this.inactivity++;
			return;
		}
		targetElement = targetElement.children[this.currentCommand.path[i]];
	}
	var rect = targetElement.getBoundingClientRect();
	this.cursor.targetPos = new Vec(rect.right * 0.8 + rect.left * 0.2, rect.top * 0.2 + rect.bottom * 0.8);
	// calculate action
	this.waitTime -= this.cursor.acc * this.fps;
	if(this.waitTime < 0){
		this.waitTime = 0;
	}
	if(this.waitTime > 0){
		return;
	}
	
	if(this.currentCommand.action == this.click){
		if(Vec.lgth(Vec.sub(this.cursor.pos, this.cursor.targetPos)) < 1){ // is closer than 1px from target
			targetElement.click();
			this.currentCommandIndex++;
		}else{
			this.inactivity = 0;
		}
	}else if(this.currentCommand.action == this.type){
		if(Vec.lgth(Vec.sub(this.cursor.pos, this.cursor.targetPos)) < 1 && this.tick % 1 == 0){ // is closer than 1px from target
			if(this.currentCommand.data == targetElement.value){ // the text is the same. Is done
				this.currentCommandIndex++;
			}else if(this.currentCommand.data.substr(0, targetElement.value.length) != targetElement.value){ // the element text is wrong. Erase
				targetElement.value = targetElement.value.substr(0, targetElement.value.length - 1);
			}else{ // the text is unfinished. Append next character
				targetElement.value += this.currentCommand.data[targetElement.value.length];
			}
		}else{
			this.inactivity = 0;
		}
	}else if(this.currentCommand.action == this.timelineScroll || this.currentCommand.action == this.timelineZoom ||
		this.currentCommand.action == this.timelineIsActive){
		
		if(Vec.lgth(Vec.sub(this.cursor.pos, this.cursor.targetPos)) < 1){ // is closer than 1px from target
			var timeline;
			for(var i=0; i<this.timelines.length; i++){
				if(this.timelines[i].timeline.canvas == targetElement){
					timeline = this.timelines[i].timeline;
					break;
				}
			}
			if (this.currentCommand.action == this.timelineScroll){
				timeline.targetPosition = this.currentCommand.data;
				this.waitTime = 100;
			}else if(this.currentCommand.action == this.timelineZoom){
				timeline.zoom = Tool.lerp(timeline.zoom, this.currentCommand.data, 0.5);
				if (Math.abs(this.currentCommand.data - timeline.zoom) < timeline.zoom / timeline.canvas.width){ // zoom is less than one pixel off
					timeline.zoom = this.currentCommand.data;
					
				}else{
					return;
				}
			}else{ // this.currentCommand.action == this.timelineIsActive){
				timeline.isActive = this.currentCommand.data;
				this.waitTime = 100;
			}
			this.currentCommandIndex++
		}else{
			this.inactivity = 0;
		}
	}else if(this.currentCommand.action == this.timelineClick){
		
	}
}
mf_TestHandeler.prototype.animate = function(){
	
	// calculate acceleration
	var difference = Vec.sub(this.cursor.targetPos, this.cursor.pos);
	
	// velocity = sqrt(2 * acceleration * distance)
	var idealVelocity;
	var difference2 = Vec.sub(difference, this.cursor.vel); // compensates for numerical integration
	if(Vec.lgth(difference2) == 0){
		idealVelocity = new Vec(); // zero vector
	}else{
		var v = Math.sqrt(2 * this.cursor.acc * Vec.lgth(difference2)); // assumes continous motion
		var v2 = this.cursor.acc * (-0.5 + Math.sqrt(0.25 + 2 * Vec.lgth(difference2) / this.cursor.acc)); // assumes discrete motion
		idealVelocity = Vec.reSize(difference2, v); // what velocity towards the target position would be the ideal at this point
	}
	var changeOfVel = Vec.sub(idealVelocity, this.cursor.vel);
	// noise
	var f = Vec.lgth(difference) * 0.1 * this.cursor.noiseFactor;
	f = Math.pow(f, 1);
	f = Math.min(f, 20);
	this.cursor.noise = Vec.add(this.cursor.noise, new Vec((Math.random()-0.5) * f, (Math.random()-0.5) * f));
	var s = 0.9;
	this.cursor.noise = Vec.mul(this.cursor.noise, s);
	changeOfVel = Vec.add(changeOfVel, this.cursor.noise);
	// if close
	if(Vec.lgth(Vec.sub(difference, this.cursor.vel)) <=  this.cursor.acc * (1 + this.cursor.noiseFactor) &&
		Vec.lgth(difference) <= this.cursor.acc * (1 + this.cursor.noiseFactor)){
		changeOfVel = Vec.sub(difference, this.cursor.vel);
	}
	// clamp
	if(Vec.lgth(changeOfVel) > this.cursor.acc * (1 + this.cursor.noiseFactor)){
		changeOfVel = Vec.reSize(changeOfVel, this.cursor.acc * (1 + this.cursor.noiseFactor));
	}
	// apply acceleration to velocity
	this.cursor.vel = Vec.add(this.cursor.vel, changeOfVel);
	// apply velocity to position
	this.cursor.pos = Vec.add(this.cursor.pos, this.cursor.vel);
	//
	this.cursor.setGraphicPos(this.cursor.pos);
}
mf_TestHandeler.prototype.endTest = function(){
	this.currentCommandIndex = 0;
	this.cursor.hide();
	this.isRunning = false;
	this.inactivity = 0;
	this.waitTime = 0;
}
mf_TestHandeler.prototype.getData = function(){
	mf_AjaxHandler.ajaxGet("/static/js/mf_testerData.js", function(responseText){
		var click = this.click;
		var type = this.type;
		var timelineScroll = this.timelineScroll;
		var timelineZoom = this.timelineZoom;
		var timelineIsActive = this.timelineIsActive;
		var dataList;
		eval(responseText); // define dataList
		if(dataList.length % 4 != 0){
			console.error("list at mf_testerData.js should have a length of a multiple of 4");
		}
		for(var i=0; i<dataList.length; i+=4){
			this.commands.push({
				action: dataList[i],
				startId: dataList[i+1],
				path: dataList[i+2],
				data: dataList[i+3]
			});
		}
	}.bind(this));
}
mf_TestHandeler.prototype.addTestListener = function(element){
	// recordings are done here, exept for timeline recordings
	
	var thisHandeler = this;
	if(element.tagName == "BUTTON"){
		element.addEventListener("click", function(){
			thisHandeler.checkTimelineChange();
			var data = thisHandeler.getIdPath(this);
			if(data == -1){
				return -1;
			}
			thisHandeler.recordedCommands += "\tclick, \"" + data.id + "\", [" + data.path.toString() + "], \"\",\n";
		});
	}else if(element.tagName == "INPUT" && (element.type == "text" || element.type == "email" || element.type == "password")){
		element.addEventListener("change", function(){
			thisHandeler.checkTimelineChange();
			var data = thisHandeler.getIdPath(this);
			if(data == -1){
				return -1;
			}
			thisHandeler.recordedCommands += "\ttype, \"" + data.id + "\", [" + data.path.toString() + "], \"" + this.value + "\",\n";
		});
	}else if(element.dataset.timeline == ""){
		element.addEventListener("mousedown", function(){
			thisHandeler.checkTimelineChange();
		});
	}
}
mf_TestHandeler.prototype.checkTimelineChange = function(){
	for(var i=0; i<this.timelines.length; i++){
		var timeLineData = this.timelines[i];
		var timeline = timeLineData.timeline;
		var data = this.getIdPath(timeline.canvas);
		if(timeLineData.position != timeline.targetPosition){
			this.recordedCommands += "\ttimelineScroll, \"" + data.id + "\", [" + data.path.toString() + "], " + timeline.targetPosition + ",\n";
			timeLineData.position = timeline.targetPosition;
		}
		if(timeLineData.zoom != timeline.zoom){
			this.recordedCommands += "\ttimelineZoom, \"" + data.id + "\", [" + data.path.toString() + "], " + timeline.zoom + ",\n";
			timeLineData.zoom = timeline.zoom;
		}
		if(timeLineData.isActive != timeline.isActive){
			this.recordedCommands += "\ttimelineIsActive, \"" + data.id + "\", [" + data.path.toString() + "], " + timeline.isActive + ",\n";
			timeLineData.isActive = timeline.isActive;
		}
	}
}
mf_TestHandeler.prototype.getRecord = function(){
	this.checkTimelineChange();
	this.recordedCommands = this.recordedCommands.substr(0, this.recordedCommands.length - 2) + "\n];"; // remove last comma and add end parenthesis and semicolon
	//console.log(this.recordedCommands);
	var result = this.recordedCommands;
	this.recordedCommands = this.recordedCommands.substr(0, this.recordedCommands.length - 3) + ",\n"; // remove end stuff and add comma
	return result;
}
mf_TestHandeler.prototype.getIdPath = function(element){
	var path = [];
	while(element.id == ""){
		if(!element.parentElement){
			console.error("could not create recording due to clicked element or any parent elements not having an id");
			return -1;
		}
		path.push(Array.prototype.slice.call(element.parentElement.children).indexOf(element));
		element = element.parentElement;
	}
	path.reverse();
	return {id: element.id, path: path};
}

mf_testHandeler = new mf_TestHandeler();


//window.addEventListener("load", mf_testHandeler.init.bind(mf_testHandeler));
//window.addEventListener("load", mf_testHandeler.start.bind(mf_testHandeler));











