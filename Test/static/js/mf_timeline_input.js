/*
	mf_timeline_input.js
	version			: 0.5.2
	last updated	: 30.11.2017
	name			: Markus Fjellheim
	description		:
		What does this do?
			This manages mouse and touch user input, when the user interacts with the timeline.
		How to use it?
			TODO: ...
*/
Timeline.prototype.getNrOfTouches = function(){
	var n=0;
	for(var i=0; i<this.touchList.length; i++){
		if(this.touchList[i].isDown > 0){
			n++;
		}
	}
	return n;
}
Timeline.prototype.touchStartOneFinger = function(event){
	
	for(var i=0; i<event.touches.length; i++){
		var e = event.touches[i];
		var t = this.touchList[e.identifier];
		
		t.x = this.getTouchX(e);
		t.y = this.getTouchY(e);
		t.x0 = this.getTouchX(e);
		t.y0 = this.getTouchY(e);
		t.xR = e.radiusX;
		t.yR = e.radiusY;
		t.id = e.identifier;
		t.timeDown = 1;
		t.isDown = true;
	}
	
	if(this.isActive){
		event.preventDefault();
	}
}
Timeline.prototype.touchMoveOneFinger = function(event){
	
	for(var i=0; i<event.touches.length; i++){
		var e = event.touches[i];
		var t = this.touchList[e.identifier];
		
		t.x = this.getTouchX(e);
		t.y = this.getTouchY(e);
		t.xR = e.radiusX;
		t.yR = e.radiusY;
	}
	
	if(this.isActive){
		event.preventDefault();
	}
}
Timeline.prototype.touchEndOneFinger = function(event){
	
	for(var i=0; i<event.changedTouches.length; i++){
		var e = event.changedTouches[i];
		var t = this.touchList[e.identifier];
		t.timeUp = 1;
		t.isDown = false;
	}
	
	if(this.isActive){
		event.preventDefault();
	}
}
Timeline.prototype.getTouchX = function(e){
	return e.pageX - e.target.parentElement.offsetLeft;
}
Timeline.prototype.getTouchY = function(e){
	return this.canvas.height - (e.pageY - e.target.parentElement.offsetTop);
}
Timeline.prototype.scroll = function(event){
	if(!this.isActive){
		return;
	}
	if(event.ctrlKey){ // zoom
		this.zoom *= 1 + event.deltaY * 0.001;
	}else{ // scroll
		this.targetPosition += event.deltaY * 0.0005 * this.zoom;
	}
	
	event.preventDefault();
}
Timeline.prototype.mouseMove = function(event){
	this.mouseData.pos = new Vec(this.getTouchX(event), this.getTouchY(event));
}
Timeline.prototype.mouseDown = function(event){
	if(this.mouseData.isDown){
		return;
	}
	this.mouseData.timeDown = 1;
	this.mouseData.isDown = true;
}
Timeline.prototype.mouseUp = function(event){
	if(!this.mouseData.isDown){
		return;
	}
	this.mouseData.timeUp = 1;
	this.mouseData.isDown = false;
}
Timeline.prototype.mouseClicked = function(){
	return !this.mouseData.isDown && this.mouseData.timeUp == 1 && this.mouseData.timeDown <= mf_timeline.fps * 0.2 && // clicked for less than 0.2 seconds ...
		Vec.lgth(Vec.sub(this.mouseData.pos, this.mouseData.pos0)) < 10; // ... and didn't move much.
}
