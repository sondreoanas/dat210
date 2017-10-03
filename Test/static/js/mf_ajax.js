function mf_AjaxHandler(){
	
}
mf_AjaxHandler.prototype.initAjax = function(){
	// load js files
	mf_init();
	// scan document for ajax templates
	var body = document.getElementsByTagName("body")[0];
	this.searchChildren(body);
	
	// check form buttons
	this.findFormButtons(body);
}
// check for form buttons
mf_AjaxHandler.prototype.findFormButtons = function(element){
	var buttons = element.getElementsByTagName("button");
	for(var i=0;i<buttons.length; i++){
		this.checkFormButton(buttons[i]);
	}
}
mf_AjaxHandler.prototype.checkFormButton = function(button){
	if(button.dataset.formid){
		if(!button.dataset.callback){
			console.error("button " + button.id + " is missing 'data-callback' attribute. It needs a callback function to recieve and handle " +
				"the response from the server.");
			return -1;
		}
		button.addEventListener("click", function(){
			var form = document.getElementById(button.dataset.formid);
			if(!form){
				console.error("No form of id \"" + button.dataset.formid + "\" could not be found.");
				return -1;
			}
			var inputs = form.getElementsByTagName("input");
			var url = "/" + form.action.split("/").pop() + "?";
			
			if(url == "/?"){
				console.error("The from \"" + form.id + "\" must have an action attribute.");
				return -1;
			}
			
			for(var i=0; i<inputs.length; i++){
				url += inputs[i].name + "=" + inputs[i].value;
				if(i != inputs.length - 1){
					url += "&";
				}
			}
			this.ajax(url, function(responseText){
				var callback = eval(button.dataset.callback);
				callback(JSON.parse(responseText));
			}.bind(this));
		}.bind(this));
	}
}
// search element and all children for ajax templates
mf_AjaxHandler.prototype.searchChildren = function(element){
	if(!this.findAjaxData(element)){
		for(var i=0; i<element.children.length; i++){
			var child = element.children[i];
			this.searchChildren(child);
		}
	}
}
mf_AjaxHandler.prototype.findAjaxData = function(element){
	if(element.dataset.fill){
		if(element.dataset.fill == "/timeline"){ // load "mf_timeline.js"
			mf_addTimeline(element);
		}else{ // load in other content
			this.ajax(element.dataset.fill, function(responseText){
				this.loadInContent(element, JSON.parse(responseText));
			}.bind(this));
			// loading graphic?
			element.innerHTML = "loading...";
		}
		
		return true;
	}else{
		return false;
	}
}

// Fill element width data.
// data is of format {template:someTemplate, data:someData}
mf_AjaxHandler.prototype.fillElement = function(elementId, html){
	var element = document.getElementById(elementId);
	this.loadInContent(element, {data:{}, template: html});
}
mf_AjaxHandler.prototype.loadInContent = function(element, data){
	data.template = templater(data.template, data.data);
	element.innerHTML = data.template;
	// check children
	for(var i=0; i<element.children.length; i++){
		var child = element.children[i];
		this.searchChildren(child);
	}
	// check buttons
	this.findFormButtons(element);
}
mf_AjaxHandler.prototype.ajax = function(address, callback){
	var xhttp = new XMLHttpRequest();
		xhttp.onreadystatechange = function() {
			if(this.readyState == 4 && this.status == 200){
				callback(this.responseText);
			}
		}
		xhttp.open("GET", address, true);
		xhttp.send();
}

var mf_ajaxHandler = new mf_AjaxHandler();
window.addEventListener("load", mf_ajaxHandler.initAjax.bind(mf_ajaxHandler));

/*var form = document.getElementById("form id");
var inputs = form.getElementByType("input");
inputs[2].value;*/







