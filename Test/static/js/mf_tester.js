/*
	mf_tester.js
	
	version			: 0.0.1
	last updated	: 16.10.2017
	name			: Markus Fjellheim
	description		:
		What does this do?
			This will perform testing. Clicking buttons and filling in forms
		How to use it?
			TODO: ...
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
	
	// command indexes
	this.click;
	this.type;
}
mf_TestHandeler.prototype.init = function(){
	this.tick = -1;
	this.fps = 30;
	
	this.cursor = new mf_Cursor();
	
	this.commands = [];
	this.currentCommandIndex = 0;
	this.currentCommand;
	
	this.inactivity = 0;
	
	this.recordedCommands = "[\n";
	
	// command indexes
	this.click = 0;
	this.type = 1;
	
	// load data
	this.getData();
}
mf_TestHandeler.prototype.start = function(acceleration = 10, noiseFactor = 0){
	this.cursor.acc = acceleration;
	this.cursor.noiseFactor = noiseFactor;
	this.cursor.show();
	this.loop = setInterval(this.loop.bind(this), 1000 / this.fps);
}
mf_TestHandeler.prototype.loop = function(){
	this.tick++;
	
	// check if success
	if(this.currentCommandIndex == this.commands.length){
		clearInterval(this.loop);
		console.info("The test was completed successfully!");
		this.cursor.hide();
		return;
	}else if(this.inactivity > 4 * this.fps){
		clearInterval(this.loop);
		console.info("The test failed due to timeout!");
		this.cursor.hide();
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
	switch(this.currentCommand.action){
		case this.click:
			if(Vec.lgth(Vec.sub(this.cursor.pos, this.cursor.targetPos)) < 1){ // is closer than 1px from target
				targetElement.click();
				this.currentCommandIndex++;
			}else{
				this.inactivity = 0;
			}
			break;
		case this.type:
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
			break;
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
mf_TestHandeler.prototype.getData = function(){
	mf_AjaxHandler.ajaxGet("/static/js/mf_testerData.js", function(responseText){
		var click = this.click;
		var type = this.type;
		var dataList = eval(responseText);
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
	var thisHandeler = this;
	if(element.tagName == "BUTTON"){
		element.addEventListener("click", function(){
			var data = thisHandeler.getIdPath(this);
			if(data == -1){
				return -1;
			}
			thisHandeler.recordedCommands += "\tclick, \"" + data.id + "\", [" + data.path.toString() + "], \"\",\n";
		});
	}else if(element.tagName == "INPUT" && (element.type == "text" || element.type == "email" || element.type == "password")){
		element.addEventListener("change", function(){
			var data = thisHandeler.getIdPath(this);
			if(data == -1){
				return -1;
			}
			thisHandeler.recordedCommands += "\ttype, \"" + data.id + "\", [" + data.path.toString() + "], \"" + this.value + "\",\n";
		});
	}
}
mf_TestHandeler.prototype.getRecord = function(){
	this.recordedCommands = this.recordedCommands.substr(0, this.recordedCommands.length - 2) + "\n]"; // remove last comma and add end parenthesis
	console.log(this.recordedCommands);
	this.recordedCommands = this.recordedCommands.substr(0, this.recordedCommands.length - 2) + ",\n"; // remove end parethesis and add comma
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











