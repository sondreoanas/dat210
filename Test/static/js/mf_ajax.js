/*
	mf_ajax.js
	
	version			: 0.3.0
	last updated	: 28.10.2017
	name			: Markus Fjellheim
	description		:
		What does this do?
			This will manage ajax calls from the html
		How to use it?
			TODO: ...
		What is new?
			...
*/


function mf_AjaxHandler(){
	
}
mf_AjaxHandler.loadEvent = new Event("onFullLoad");
mf_AjaxHandler.nrOfCallsInProgress = 0;
mf_AjaxHandler.evaluateScriptQue = [];
mf_AjaxHandler.root = null;
mf_AjaxHandler.prototype.initAjax = function(){
	// root
	if(root){
		mf_AjaxHandler.root = root;
	}else{
		mf_AjaxHandler.root = "http://127.0.0.1:5000";
	}
	
	// start recording
	mf_testHandeler.init();
	// load js files
	mf_init();
	// scan document for ajax templates
	var body = document.getElementsByTagName("body")[0];
	this.searchElement(body);
	

}
mf_AjaxHandler.prototype.checkButton = function(button){
	if(button.dataset.formid){ // form
		if(!button.dataset.callback){
			Tool.printError("button " + button.id + " is missing 'data-callback' attribute. It needs a callback function to recieve and handle " +
				"the response from the server.");
			return -1;
		}
		//var 
		button.addEventListener("click", function(e){
			e.preventDefault();
			var form = document.getElementById(button.dataset.formid);
			if(!form){
				Tool.printError("no form of id: \"" + button.dataset.formid + "\" is found.");
				return -1;
			}
			mf_AjaxHandler.ajaxPostForm(form, form.action, function(responseText){
				var callback = eval(button.dataset.callback);
				if(!callback){
					Tool.printError("No function with name: \"" + button.dataset.callback + "\" is found.");
				}
				callback(JSON.parse(responseText));
			}.bind(this));
		}.bind(this));
	}else if(button.dataset.target){ // fill/replace
		if(button.dataset.fill == null &&
			button.dataset.replace == null &&
			button.dataset.before == null &&
			button.dataset.after == null &&
			button.dataset.remove == null &&
			button.dataset.addfirstchild == null &&
			button.dataset.addlastchild == null ){
			Tool.printError("button " + button.id + " is missing 'data-fill/replace/before/after/remove/addfirstchild' attribute." +
				"It needs a target to fill/replace/before/after/remove/addfirstchild.");
			return -1;
		}
		if(button.tagName == "BUTTON"){
			button.addEventListener("click", action.bind(this));
		}else if(button.tagName == "SELECT"){
			button.addEventListener("change", action.bind(this));
		}
		button.addEventListener("click", action.bind(this));
		function action(e){
			e.preventDefault();
			var targetId = button.dataset.target;
			if(button.dataset.fill != null){
				this.fillElement(targetId, button.dataset.fill);
			}else if(button.dataset.replace != null){
				this.replaceElement(targetId, button.dataset.replace);
			}else if(button.dataset.before != null){
				this.placeBeforeElement(targetId, button.dataset.before);
			}else if(button.dataset.after != null){
				this.placeAfterElement(targetId, button.dataset.after);
			}else if(button.dataset.remove != null){
				this.removeElement(targetId, button.dataset.remove); // TODO: remove second argument? test
			}else if(button.dataset.addfirstchild != null){
				this.addFirstChild(targetId, button.dataset.addfirstchild);
			}else if(button.dataset.addlastchild != null){
				this.addLastChild(targetId, button.dataset.addlastchild);
			}else{
				Tool.printError("Markus 1 did something wrong, ask him to fix it.");
			}
		}
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
	mf_testHandeler.addTestListener(element);
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
	if(element.tagName == "SCRIPT" && element.dataset.run == ""){
		var code = element.innerHTML;
		mf_AjaxHandler.evaluateScriptQue.push(code);
		return false;
	}
	if(element.dataset.timeline == "" || !element.dataset.target && (element.dataset.fill || element.dataset.replace)){
		if(element.dataset.timeline == ""){ // load "mf_timeline.js"
			var index = mf_addTimeline(element);
			if(element.dataset.position || element.dataset.zoom){
				var pos = parseFloat(element.dataset.position);
				var zoom = parseFloat(element.dataset.zoom);
				if(!pos){
					Tool.printError("Element with id \"" + element.id + "\" is missing/wrong format data-position=\"someNumber\" attribute.");
				}
				if(!zoom){
					Tool.printError("Element with id \"" + element.id + "\" is missing/wrong format data-zoom=\"someNumber\" attribute.");
				}
				mf_timeline.timelines[index].position = pos;
				mf_timeline.timelines[index].targetPosition = pos;
				mf_timeline.timelines[index].zoom = zoom;
			}
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
mf_AjaxHandler.prototype.addLastChild = function(elementId, url, data = null){
	if(!this.checkDomLoaded(this.addLastChild, elementId, url, data)){
		return;
	}
	if(!elementId){Tool.printError("Missing argument \"elementId\"", 2);return -1;}
	if(!url){Tool.printError("Missing argument \"url\"", 2);return -1;}
	var element = document.getElementById(elementId);
	if(!element){
		Tool.printError("no element of id: \"" + elementId + "\" is found.");
		return -1;
	}
	this.addLastChildArgElement(element, url, data);
}
mf_AjaxHandler.prototype.addLastChildArgElement = function(element, url, data = null){
	if(!this.checkDomLoaded(this.addLastChildArgElement, element, url, data)){
		return;
	}
	var dummy = document.createElement("DIV");
	element.append(dummy);
	this.replaceElementArgElement(dummy, url, data);
}
mf_AjaxHandler.prototype.addFirstChild = function(elementId, url, data = null){
	if(!this.checkDomLoaded(this.addFirstChild, elementId, url, data)){
		return;
	}
	if(!elementId){Tool.printError("Missing argument \"elementId\"", 2);return -1;}
	if(!url){Tool.printError("Missing argument \"url\"", 2);return -1;}
	var element = document.getElementById(elementId);
	if(!element){
		Tool.printError("no element of id: \"" + elementId + "\" is found.");
		return -1;
	}
	this.addFirstChildArgElement(element, url, data);
}
mf_AjaxHandler.prototype.addFirstChildArgElement = function(element, url, data = null){
	if(!this.checkDomLoaded(this.addFirstChildArgElement, element, url, data)){
		return;
	}
	var dummy = document.createElement("DIV");
	element.insertBefore(dummy, element.firstChild);
	this.replaceElementArgElement(dummy, url, data);
}
mf_AjaxHandler.prototype.removeElement = function(elementId){
	if(!this.checkDomLoaded(this.removeElement, elementId)){
		return;
	}
	if(!elementId){Tool.printError("Missing argument \"elementId\"", 2);return -1;}
	var element = document.getElementById(elementId);
	if(!element){
		Tool.printError("no element of id: \"" + elementId + "\" is found.");
		return -1;
	}
	element.parentElement.removeChild(element);
}
mf_AjaxHandler.prototype.placeAfterElement = function(elementId, url, data = null){
	if(!this.checkDomLoaded(this.placeAfterElement, elementId, url, data)){
		return;
	}
	if(!elementId){Tool.printError("Missing argument \"elementId\"", 2);return -1;}
	if(!url){Tool.printError("Missing argument \"url\"", 2);return -1;}
	var element = document.getElementById(elementId);
	if(!element){
		Tool.printError("no element of id: \"" + elementId + "\" is found.");
		return -1;
	}
	this.placeAfterElementArgElement(element, url, data);
}
mf_AjaxHandler.prototype.placeAfterElementArgElement = function(element, url, data = null){
	if(!this.checkDomLoaded(this.placeAfterElementArgElement, element, url, data)){
		return;
	}
	var dummy = document.createElement("DIV");
	this.loadInContent(dummy, url, function(){
		// empty dummy into parent of element
		var parent = element.parentElement;
		if(!parent){
			console.warn("\"" + url + "\" was not placed after element with id \"" + element.id + "\", due to load confict");
			return -1;
		}
		
		var elementsToCheck = [];
		while(dummy.children.length > 0){
			var child = dummy.children[0];
			parent.insertBefore(child, element.nextSibling);
			elementsToCheck.push(child);
		}
		
		// check children
		for(var i=0; i<elementsToCheck.length; i++){
			this.searchElement(elementsToCheck[i]);
		}
	}.bind(this), data);
}
mf_AjaxHandler.prototype.placeBeforeElement = function(elementId, url, data = null){
	if(!this.checkDomLoaded(this.placeBeforeElement, elementId, url, data)){
		return;
	}
	if(!elementId){Tool.printError("Missing argument \"elementId\"", 2);return -1;}
	if(!url){Tool.printError("Missing argument \"url\"", 2);return -1;}
	var element = document.getElementById(elementId);
	if(!element){
		Tool.printError("no element of id: \"" + elementId + "\" is found.");
		return -1;
	}
	this.placeBeforeElementArgElement(element, url, data);
}
mf_AjaxHandler.prototype.placeBeforeElementArgElement = function(element, url, data = null){
	if(!this.checkDomLoaded(this.placeBeforeElementArgElement, element, url, data)){
		return;
	}
	var dummy = document.createElement("DIV");
	this.loadInContent(dummy, url, function(){
		// empty dummy into parent of element
		var parent = element.parentElement;
		if(!parent){
			console.warn("\"" + url + "\" was not placed before element with id \"" + element.id + "\", due to load confict");
			return -1;
		}
		
		var elementsToCheck = [];
		while(dummy.children.length > 0){
			var child = dummy.children[0];
			parent.insertBefore(child, element);
			elementsToCheck.push(child);
		}
		
		// check children
		for(var i=0; i<elementsToCheck.length; i++){
			this.searchElement(elementsToCheck[i]);
		}
	}.bind(this), data);
}
mf_AjaxHandler.prototype.replaceElement = function(elementId, url, data = null){
	if(!this.checkDomLoaded(this.replaceElement, elementId, url, data)){
		return;
	}
	if(!elementId){Tool.printError("Missing argument \"elementId\"", 2);return -1;}
	if(!url){Tool.printError("Missing argument \"url\"", 2);return -1;}
	var element = document.getElementById(elementId);
	if(!element){
		Tool.printError("no element of id: \"" + elementId + "\" is found.");
		return -1;
	}
	this.replaceElementArgElement(element, url, data);
}
mf_AjaxHandler.prototype.replaceElementArgElement = function(element, url, data = null){
	if(!this.checkDomLoaded(this.replaceElementArgElement, element, url, data)){
		return;
	}
	this.loadInContent(element, url, function(){
		// empty element into parent of element
		var parent = element.parentElement;
		if(!parent){
			console.warn("element with id \"" + element.id + "\", was not replaced with \"" + url + "\" due to load confict");
			return -1;
		}
		
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
	}.bind(this), data);
}
mf_AjaxHandler.prototype.fillElement = function(elementId, url, data = null){
	if(!this.checkDomLoaded(this.fillElement, elementId, url, data)){
		return;
	}
	if(!elementId){Tool.printError("Missing argument \"elementId\"", 2);return -1;}
	if(!url){Tool.printError("Missing argument \"url\"", 2);return -1;}
	var element = document.getElementById(elementId);
	if(!element){
		Tool.printError("no element of id: \"" + elementId + "\" is found.");
		return -1;
	}
	this.fillElementArgElement(element, url, data);
}
mf_AjaxHandler.prototype.fillElementArgElement = function(element, url, data = null){
	if(!this.checkDomLoaded(this.fillElementArgElement, element, url, data)){
		return;
	}
	this.loadInContent(element, url, function(){
		// check children
		this.searchChildren(element);
	}.bind(this), data);
}
mf_AjaxHandler.prototype.loadInContent = function(element, url, callback, data = null){
	//
	mf_AjaxHandler.nrOfCallsInProgress++;
	//
	mf_AjaxHandler.ajaxGet(url, function(responseText){
		var responce = JSON.parse(responseText); // responce = {template: someTemplate, data: somedata}
		if(data){
			responce.data = data;
		}
		responce.template = templater(responce.template, responce.data);
		//notification(responce.notification);
    
		while(element.firstChild){
			element.removeChild(element.firstChild);
		}

		element.innerHTML = responce.template;

/*

		var parser = new DOMParser();
		// delete children of element
		while(element.firstChild){
			element.removeChild(element.firstChild);
		}
		// fill element with new children
		var dummy = parser.parseFromString(responce.template, "text/html").body;
		for(var i=0;i<dummy.children.length; i++){
			element.appendChild(dummy.children[i]);
		}

*/

		callback();
		//
		this.checkDoneAjaxLoadingAndDecrement();
	}.bind(this), function callbackFail(){
		this.checkDoneAjaxLoadingAndDecrement();
	});
	// loading graphic?
	element.innerHTML = "loading...";
}
mf_AjaxHandler.ajaxGet = function(address, callback, callbackFail){
	var xhttp = new XMLHttpRequest();

	xhttp.onreadystatechange = function(){
		if(this.readyState == 4){
			if(this.status == 200){
				callback(this.responseText);
			}else{
				if(callbackFail){
					callbackFail();
				}
			}
		}
	};
	xhttp.open("GET", mf_AjaxHandler.addRoot(address), true);
	xhttp.send();
}
mf_AjaxHandler.ajaxPost = function(data, address, callback){
	var xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function(){
		if(this.readyState == 4 && this.status == 200){
			callback(this.responseText);
		}
	};
	xhttp.open("post", mf_AjaxHandler.addRoot(address), true);
	xhttp.setRequestHeader("Content-type", "application/json");
	
	xhttp.send(JSON.stringify(data));
}
mf_AjaxHandler.ajaxPostForm = function(form, address, callback){
	var xhttp = new XMLHttpRequest();
	xhttp.onreadystatechange = function(){
		if(this.readyState == 4 && this.status == 200){
			callback(this.responseText);
		}
	};
	xhttp.open("post", mf_AjaxHandler.addRoot(address), true);
	//xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	var formData = new FormData(form);
	xhttp.send(formData);
}
mf_AjaxHandler.addRoot = function(address){
	/*if(address[0] !== "/"){
		address = "/" + address;
	}*/
	/*var escRoot = mf_AjaxHandler.root.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&"); // https://stackoverflow.com/questions/3446170/escape-string-for-use-in-javascript-regex
	var re = new RegExp("^(" + escRoot + ")");
	address = address.replace(re,"");*/
	
	/*for(var i=mf_AjaxHandler.root.length - 1; i>=0; i++){
		if(address.charAt(0) === mf_AjaxHandler.root.charAt(i)){
			address = address.substr(1);
		}else{
			break;
		}
	}*/
	
	
	//return mf_AjaxHandler.root + address; // TODO: mf_AjaxHandler.root with root when merged with nils
	
	if(mf_AjaxHandler.root == address.substr(0, mf_AjaxHandler.root.length)){
		return address;
	}else{
		if(address[0] !== "/"){
			address = "/" + address;
		}
		return mf_AjaxHandler.root + address;
	}
	
}
mf_AjaxHandler.prototype.checkDomLoaded = function(callback){
	if(document.readyState === "complete"){
		return true;
	}else{
		window.addEventListener('load', (function(that, args){
			return function(){
				callback.apply(that, Array.prototype.slice.call(args, 1));
			};
		})(this, arguments));
		return false;
	}
}
mf_AjaxHandler.prototype.checkDoneAjaxLoadingAndDecrement = function(){
	mf_AjaxHandler.nrOfCallsInProgress--;
	if(mf_AjaxHandler.nrOfCallsInProgress == 0){
		window.dispatchEvent(mf_AjaxHandler.loadEvent);
	}
	while(mf_AjaxHandler.evaluateScriptQue.length > 0){
		eval(mf_AjaxHandler.evaluateScriptQue.shift());
	}
}

var mf_ajaxHandler = new mf_AjaxHandler();
window.addEventListener("load", mf_ajaxHandler.initAjax.bind(mf_ajaxHandler));






