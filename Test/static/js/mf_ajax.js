function mf_AjaxHandler(){
	
}
mf_AjaxHandler.prototype.initAjax = function(){
	// load js files
	mf_init();
	// scan document for ajax templates
	var body = document.getElementsByTagName("body")[0];
	this.searchElement(body);
}
// check for form buttons
mf_AjaxHandler.prototype.findFormButtons = function(element){
	var buttons = Array.prototype.slice.call(element.getElementsByTagName("button"));
	if(element.tagName == "BUTTON"){
		buttons.push(element);
	}
	for(var i=0;i<buttons.length; i++){
		this.checkButton(buttons[i]);
	}
}
mf_AjaxHandler.prototype.checkButton = function(button){
	if(button.dataset.formid){ // form
		if(!button.dataset.callback){
			console.error("button " + button.id + " is missing 'data-callback' attribute. It needs a callback function to recieve and handle " +
				"the response from the server.");
			return -1;
		}
		button.addEventListener("click", function(){
			var form = document.getElementById(button.dataset.formid);
			this.ajaxPost(form, form.action, function(responseText){
				var callback = eval(button.dataset.callback);
				callback(JSON.parse(responseText));
			}.bind(this));
		}.bind(this));
	}else if(button.dataset.target){ // fill/replace
		if(!(button.dataset.fill || button.dataset.replace)){
			console.error("button " + button.id + " is missing 'data-target' attribute. It needs a target to fill/replace.");
			return -1;
		}
		button.addEventListener("click", function(){
			var targetId = button.dataset.target;
			if(button.dataset.fill){
				this.fillElement(targetId, button.dataset.fill);
			}else{ // button.dataset.replace
				this.replaceElement(targetId, button.dataset.replace);
			}
		}.bind(this));
	}
}
// check Element content
mf_AjaxHandler.prototype.searchChildren = function(element){
	// check children
	for(var i=0; i<element.children.length; i++){
		var child = element.children[i];
		this.searchElement(child);
	}
}
// search element and all children for ajax templates
mf_AjaxHandler.prototype.searchElement = function(element){
	// search buttons
	//this.findFormButtons(element);
	this.checkButton(element);
	// search children
	if(!this.findAjaxData(element)){
		for(var i=0; i<element.children.length; i++){
			var child = element.children[i];
			this.searchElement(child);
		}
	}
}
mf_AjaxHandler.prototype.findAjaxData = function(element){
	if(!element.dataset.target && (element.dataset.fill || element.dataset.replace)){
		if(element.dataset.fill == "/timeline" || element.dataset.replace == "/timeline"){ // load "mf_timeline.js"
			mf_addTimeline(element);
		}else{ // load in other content
			if(element.dataset.fill){
				this.fillElementArgElement(element, element.dataset.fill);
			}else{ // element.dataset.replace
				this.replaceElementArgElement(element, element.dataset.replace);
			}
		}
		
		return true;
	}else{
		return false;
	}
}
// Fill element width data.
// data is of format {template:someTemplate, data:someData}
mf_AjaxHandler.prototype.replaceElement = function(elementId, url){
	var element = document.getElementById(elementId);
	this.replaceElementArgElement(element, url);
}
mf_AjaxHandler.prototype.replaceElementArgElement = function(element, url){
	this.loadInContent(element, url, function(){
		// empty element into parent
		var parent = element.parentElement;
		
		var elementsToCheck = [];
		while(element.children.length > 0){
			var child = element.children[0];
			parent.insertBefore(child, element);
			elementsToCheck.push(child);
		}
		parent.removeChild(element);
		
		// check children
		for(var i=0; i<elementsToCheck.length; i++){
			this.searchElement(elementsToCheck[i]);
		}
		}.bind(this));
}
mf_AjaxHandler.prototype.fillElement = function(elementId, url){
	var element = document.getElementById(elementId);
	this.fillElementArgElement(element, url);
}
mf_AjaxHandler.prototype.fillElementArgElement = function(element, url){
	this.loadInContent(element, url, function(){		
		// check children
		this.searchChildren(element);
	}.bind(this));
}
mf_AjaxHandler.prototype.loadInContent = function(element, url, callback){
	this.ajaxGet(url, function(responseText){
		var data = JSON.parse(responseText);
		data.template = templater(data.template, data.data);
		element.innerHTML = data.template;
		callback();
	}.bind(this));
	// loading graphic?
	element.innerHTML = "loading...";
}
mf_AjaxHandler.prototype.ajaxGet = function(address, callback){
	var xhttp = new XMLHttpRequest();
		xhttp.onreadystatechange = function() {
			if(this.readyState == 4 && this.status == 200){
				callback(this.responseText);
			}
		}
		xhttp.open("GET", address, true);
		xhttp.send();
}
mf_AjaxHandler.prototype.ajaxPost = function(form, address, callback){
	var xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function() {
		if(this.readyState == 4 && this.status == 200){
			callback(this.responseText);
		}
	}
	xhttp.open("post", address, true);
	//xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	var formData = new FormData(form);
	xhttp.send(formData);
}

var mf_ajaxHandler = new mf_AjaxHandler();
window.addEventListener("load", mf_ajaxHandler.initAjax.bind(mf_ajaxHandler));

/*var form = document.getElementById("form id");
var inputs = form.getElementByType("input");
inputs[2].value;*/







