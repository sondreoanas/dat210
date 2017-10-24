/*
	mf_ajax.js
	
	version			: 0.0.0
	last updated	: 23.10.2017
	name			: Markus Fjellheim
	description		:
		What does this do?
			This will manage ajax calls from the html
		How to use it?
			TODO: ...
		What is new?
			...
*/

function mf_Control(){
	this.keys = [];
	
	this.keyCodeLog = [];
	
	document.addEventListener("keydown", this.keyDown.bind(this));
	document.addEventListener("keyup", this.keyUp.bind(this));
	
	this.keyDownCallBacks = [];
	this.keyUpCallBacks = [];
	
	this.n1 = new mf_Key(49);
	this.keys.push(this.n1);
	this.n2 = new mf_Key(50);
	this.keys.push(this.n2);
	this.n3 = new mf_Key(51);
	this.keys.push(this.n3);
	this.n4 = new mf_Key(52);
	this.keys.push(this.n4);
	this.n5 = new mf_Key(53);
	this.keys.push(this.n5);
	this.n6 = new mf_Key(54);
	this.keys.push(this.n6);
	this.n7 = new mf_Key(55);
	this.keys.push(this.n7);
	this.n8 = new mf_Key(56);
	this.keys.push(this.n8);
	this.n9 = new mf_Key(57);
	this.keys.push(this.n9);
	this.n0 = new mf_Key(48);
	this.keys.push(this.n0);
	this.q = new mf_Key(81);
	this.keys.push(this.q);
	this.w = new mf_Key(87);
	this.keys.push(this.w);
	this.e = new mf_Key(69);
	this.keys.push(this.e);
	this.r = new mf_Key(82);
	this.keys.push(this.r);
	this.t = new mf_Key(84);
	this.keys.push(this.t);
	this.y = new mf_Key(89);
	this.keys.push(this.y);
	this.u = new mf_Key(85);
	this.keys.push(this.u);
	this.i = new mf_Key(73);
	this.keys.push(this.i);
	this.o = new mf_Key(79);
	this.keys.push(this.o);
	this.p = new mf_Key(80);
	this.keys.push(this.p);
	this.a = new mf_Key(65);
	this.keys.push(this.a);
	this.s = new mf_Key(83);
	this.keys.push(this.s);
	this.d = new mf_Key(68);
	this.keys.push(this.d);
	this.f = new mf_Key(70);
	this.keys.push(this.f);
	this.g = new mf_Key(71);
	this.keys.push(this.g);
	this.h = new mf_Key(72);
	this.keys.push(this.h);
	this.j = new mf_Key(74);
	this.keys.push(this.j);
	this.k = new mf_Key(75);
	this.keys.push(this.k);
	this.l = new mf_Key(76);
	this.keys.push(this.l);
	this.z = new mf_Key(90);
	this.keys.push(this.z);
	this.x = new mf_Key(88);
	this.keys.push(this.x);
	this.c = new mf_Key(67);
	this.keys.push(this.c);
	this.v = new mf_Key(86);
	this.keys.push(this.v);
	this.b = new mf_Key(66);
	this.keys.push(this.b);
	this.n = new mf_Key(78);
	this.keys.push(this.n);
	this.m = new mf_Key(77);
	this.keys.push(this.m);
	this.ctrl = new mf_Key(17);
	this.keys.push(this.ctrl);
	this.shift = new mf_Key(16);
	this.keys.push(this.shift);
}
function mf_Key(keyCode){
	this.isDown = false;
	this.timeDown = 0;
	this.timeUp = 0;
	this.keyCode = keyCode;
}
mf_Control.prototype.addKeyDownEventListener = function(callback){
	this.keyDownCallBacks.push(callback);
}
mf_Control.prototype.addKeyUpEventListener = function(callback){
	this.keyUpCallBacks.push(callback);
}
mf_Control.prototype.keyDown = function(event){
	for(var i=0; i<this.keys.length; i++){
		if(this.keys[i].keyCode == event.keyCode){
			this.keys[i].isDown = true;
			this.keys[i].timeDown = 1;
		}
	}
	this.keyCodeLog.push(event.keyCode);
	for(var i=0; i<this.keyDownCallBacks.length; i++){
		this.keyDownCallBacks[i]();
	}
}
mf_Control.prototype.keyUp = function(){
	for(var i=0; i<this.keys.length; i++){
		if(this.keys[i].keyCode == event.keyCode){
			this.keys[i].isDown = false;
			this.keys[i].timeUp = 1;
		}
	}
	for(var i=0; i<this.keyUpCallBacks.length; i++){
		this.keyUpCallBacks[i]();
	}
}
mf_Control.prototype.reset = function(){
	for(var i=0; i<this.keys.length; i++){
		this.keys[i].isDown = false;
		this.keys[i].timeUp = 0;
		this.keys[i].timeDown = 0;
	}
}
mf_Control.prototype.update = function(){
	for(var i=0; i<this.keys.length; i++){
		if(this.keys[i].isDown){
			this.keys[i].timeDown++;
		}else{
			this.keys[i].timeUp++;
		}
	}
}
mf_Control.prototype.getKeyNames = function(){
	// usage: Press keys in order. Then call this function, and code for copy paste in constructor will be generated.
	
	var names = prompt("give key names. Example \"tab,q,w,e,r,t,y,u,i,o,p,enter,caps,a,s\"");
	names = names.split(",");
	
	var result = "";
	for(var i=0; i<Math.min(names.length, this.keyCodeLog.length); i++){
		result += "\tthis." + names[i] + " = new mf_Key(" + this.keyCodeLog[i] + ");\n\tthis.keys.push(this." + names[i] + ");\n"
	}
	
	console.log(result);
}




