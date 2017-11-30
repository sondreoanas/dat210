/*
	mf_timeline_loop.js
	version			: 0.5.2
	last updated	: 30.11.2017
	name			: Markus Fjellheim
	description		:
		What does this do?
			This is the main loop that keeps the timeline alive
*/
Timeline.prototype.loop = function(){
	this.tick++;
	
	// check if canvas still exists
	if(this.tick % mf_timeline.fps == 0 && !document.body.contains(this.canvas)){ // check every second
		clearInterval(this.loop);
		delete mf_timeline;
		return;
	}
	
	//
	this.checkButtons();
	
	// calcuate motion
	this.position = (this.targetPosition - this.position) * 0.2 + this.position;
	
	// status
	this.handleStatus();
	
	// handle userinput by thecurrent mode
	if(this.mode == Timeline.timelineView){
		this.timelineControls();
	}else if(this.mode == Timeline.taskView){
		this.taskControls();
	}else{
		Tool.printError("Timeline mode not found.");
	}
	
	// render
	// // if the sceene is pretty much the same, don't re-render again
	if(this.mouseData.isDown || (this.mouseData.timeUp < 10 && !this.mouseData.isDown) ||
			this.tick == 1 || this.mode != Timeline.timelineView || Math.abs(this.position - this.targetPosition) > 1){
		this.render();
	}
	
	// handle userinput regardless of the current mode
	this.globalControls();
	
	// handle status
	//this.handleStatus();
	
	// endstuff
	this.endCycle();
}
Timeline.prototype.endCycle = function(){
	// mouse and touch
	// // touch timing calculations
	for(var i=0; i<this.touchList.length; i++){
		var t = this.touchList[i];
		t.x0 = t.x;
		t.y0 = t.y;
		if(t.isDown){
			t.timeDown++;
		}else if(t.timeUp != 0){
			t.timeUp++;
		}
	}
	// // mouse timing calculations
	this.mouseData.pos0 = Vec.newVec(this.mouseData.pos);
	if(this.mouseData.isDown){
		this.mouseData.timeDown++;
	}else if(this.mouseData.timeUp != 0){
		this.mouseData.timeUp++;
	}
	// //
	this.clicked = false;
	// //
	this.cancelActivationChange = false;
}
Timeline.prototype.handleStatus = function(){
	if(this.status == Timeline.standard){
		
	}else if(this.status == Timeline.addEventSetStart || this.status == Timeline.addEventSetEnd){
		this.setTimelineView();
		// detect click
		if(!this.cancelActivationChange){
			// calculate position
			var time = this.canvasCoordsToTime(this.mouseData.pos.x);
			
			var date = new Date(time);
			this.resetTimeFuntion(date);
			var t0 = date.getTime();
			this.incrementTimeFunction(date);
			var t1 = date.getTime();
			
			if(this.status == Timeline.addEventSetStart){
				this.startTime = Math.abs(t0 - time) < Math.abs(t1 - time)? t0: t1;
			}else if(this.status == Timeline.addEventSetEnd){
				this.endTime = Math.abs(t0 - time) < Math.abs(t1 - time)? t0: t1;
			}else{
				Tool.printError("\"this.status\" is not recognized.");
			}
			// detect click
			if(this.mouseClicked()){
				if(this.status == Timeline.addEventSetStart){
					this.status = Timeline.addEventSetEnd;
					//this.cancelActivationChange = true;
					this.cursorInfo = "Click to place end time.";
				}else if(this.status == Timeline.addEventSetEnd){
					if(this.startTime >= this.endTime){
						this.cursorInfo = "End needs to be after start, place end again";
					}else{
						this.cursorInfo = "";
						this.status = Timeline.standard;
						this.cancelActivationChange = true;
						this.changeViewButton.visibility = true;
						
						var range = this.taskToBePlaced.getRange();
						mf_AjaxHandler.ajaxPost({
							calendarId: this.taskToBePlaced.calendarId,
							eventName: this.taskToBePlaced.name,
							start: this.startTime,
							end: this.endTime
						}, "/addNewEvent", function(r){
							var isSuccess = JSON.parse(r).isSuccess;
							if(isSuccess == null){
								Tool.printError("Wrong format in response from url: \"/addNewTask\".\n" +
									"Expected {isSuccess: true/false}, but recieved " + JSON.parse(r) + ".");
								return -1;
							}
							if(!isSuccess){
								Tool.printError("New task could not be placed.");
								return -1;
							}
							
							mf_AjaxHandler.ajaxPost({taskId: this.taskToBePlaced.id}, "/setTaskDone", function(r){
								this.taskToBePlaced.isDone = true;
								
								this.loadTasks();
								this.loadEvents();
								//this.setTaskView();
							}.bind(this));
						}.bind(this));
					}
				}else{
					Tool.printError("\"this.status\" is not recognized.");
				}
			}
		}
	}
}
Timeline.prototype.checkButtons = function(){
	if(this.isActive && this.mouseClicked()){
		for(var i=0; i<this.buttons.length; i++){
			var button = this.buttons[i];
			if(!button.visibility){
				continue;
			}
			switch(button.shape){
				case Button.circle:
					if(Vec.lgth(Vec.sub(button.pos, this.mouseData.pos)) <= button.radius){
						button.callBack();
						this.cancelActivationChange = true;
						return;
					}
					break;
				case Button.square:
					if(Math.abs(this.mouseData.pos.x - button.pos.x) < button.width * 0.5 &&
						Math.abs(this.mouseData.pos.y - button.pos.y) < button.height * 0.5){
						button.callBack();
						this.cancelActivationChange = true;
						return;
					}
					break;
			}
		}
	}
}
Timeline.prototype.addEventStart = function(){
	this.status = Timeline.addEventSetStart;
	this.addButton.name = "Confirm start";
	this.addButton.shape = Button.square;
	this.addButton.width = 250;
	this.addButton.height = 100;
	this.addButton.callBack = this.addEventConfirmStart.bind(this);
}
Timeline.prototype.addEventConfirmStart = function(){
	this.status = Timeline.addEventSetEnd;
	this.addButton.name = "Confirm end";
	this.addButton.shape = Button.square;
	this.addButton.width = 250;
	this.addButton.height = 100;
	this.addButton.callBack = this.addEventConfirmEnd.bind(this);
}
Timeline.prototype.addEventConfirmEnd = function(){
	if(this.startTime > this.endTime){
		this.addButton.name = "Start must be after end";
		return;
	}
	this.status = Timeline.standard;
	this.addButton.name = "Add event";
	this.addButton.shape = Button.circle;
	this.addButton.radius = 60;
	this.addButton.callBack = this.addEventStart.bind(this);
	var newEvent = new mf_Event(
		start = this.startTime,
		end = this.endTime,
		name = "event nr:" + mf_Event.nrOfEvents,
		color = Tool.randomColor(1)
	);
	this.events.push(newEvent);
	this.calcuateEventCollisions();
	//mf_AjaxHandler.ajaxPostForm({start: newEvent.start, end: newEvent.end, name: newEvent.name}, "/addEvent", function(response){alert(response);});
}
Timeline.prototype.timelineControls = function(){
	// controls
	var zoomSensitivity = 2;
	var scrollSensitivity = 1;
	var deltaZoom = 0;
	var deltaScroll = 0;
	// // touch
	/*for(var i=0; i<this.touchList.length; i++){
		var t = this.touchList[i];
		if(!t.isDown){
			continue;
		}
		// zoom
		deltaZoom += (t.y - t.y0) / this.canvas.height * this.zoom * zoomSensitivity;
	}
	for(var i=0; i<this.touchList.length; i++){
		var t = this.touchList[i];
		if(!t.isDown){
			continue;
		}
		// scroll sideways
		deltaScroll -= (t.x - t.x0) / this.canvas.width * this.zoom * scrollSensitivity +
			deltaZoom / this.getNrOfTouches() * (t.x - this.canvas.width * 0.5) / this.canvas.width;
	}
	if(this.getNrOfTouches() != 0){
		deltaZoom /= this.getNrOfTouches();
		deltaScroll /= this.getNrOfTouches();
	}*/
	// // mouse
	if(this.mouseData.isDown){
		deltaZoom += (this.mouseData.pos.y - this.mouseData.pos0.y) / this.canvas.height * this.zoom * zoomSensitivity;
		deltaScroll -= (this.mouseData.pos.x - this.mouseData.pos0.x) / this.canvas.width * this.zoom * scrollSensitivity +
			deltaZoom * (this.mouseData.pos.x - this.canvas.width * 0.5) / this.canvas.width;
	}
	// // apply
	if(this.isActive){
		// // zoom
		this.zoom += deltaZoom;
		this.zoom = Tool.clamp(this.zoom, this.maxZoom, this.minZoom);
		// movement
		this.targetPosition += deltaScroll;
		this.position += deltaScroll;
	}
}
Timeline.prototype.globalControls = function(){
	// activate screen
	if(
		(
			this.mouseClicked()
		) &&
		this.status == Timeline.standard &&
		!this.cancelActivationChange){
		
		this.isActive = !this.isActive;
	}
}
Timeline.prototype.taskControls = function(){
	// check for clicks
	if(this.isActive){
		detectClick(this, this.tasks);
		function detectClick(that, tasks){
			for(var i=0; i<tasks.length; i++){
				var t = tasks[i];
				detectClick(that, t.children);
				
				if(!t.isDone && t.children.length == 0 &&
						Math.abs(that.mouseData.pos.x - t.position.x) < t.width * 0.5 &&
						Math.abs(that.mouseData.pos.y - t.position.y) < t.height * 0.5){
					t.isHoveredOver = true;
					if(that.mouseClicked()){
						that.cancelActivationChange = true;
						that.taskToBePlaced = t;
						that.status = Timeline.addEventSetStart;
						
						var range = t.getRange();
						that.position = that.targetPosition = (range.start + range.end) * 0.5;
						that.zoom = range.end - range.start;
						that.placementRange.start = range.start;
						that.placementRange.end = range.end;
						
						that.cursorInfo = "Click to place start time";
						
						that.changeViewButton.visibility = false;
					}
				}else{
					t.isHoveredOver = false;
				}
			}
		};
	}
	
	calcMovement(this.tasks);
	function calcMovement(tasks){
		for(var i=0; i<tasks.length; i++){
			var t = tasks[i];
			calcMovement(t.children);
			
			var movementSpeed = 0.1 * Math.pow(1.2, 1); // TODO: fix 1 to faster the more left
			t.targetPosition0 = Vec.lerp(t.targetPosition0, t.targetPosition1, movementSpeed);
			t.position = Vec.lerp(t.position, t.targetPosition0, movementSpeed);
		}
	};
}
