/*
	mf_ajax.js
	
	version			: 1.0.3
	last updated	: 31.10.2017
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
	// this function is initialized when the index page of the application starts for the first time.
	
	// root
	if(root){
		mf_AjaxHandler.root = root;
	}else{
		mf_AjaxHandler.root = "http://127.0.0.1:5000";
	}
	
	// start recording
	mf_testHandeler.init(); // all elements will be recorded for testing later
	// load js files
	mf_init(); // the timeline handeler is initilized
	// scan document for ajax templates
	var body = document.getElementsByTagName("body")[0];
	this.searchElement(body);
}
mf_AjaxHandler.prototype.checkButton = function(button){
	// The function will add look for dataset attributes on the input element and add eventlisteners for ajax calls.
	
	if(button.dataset.formid){ // form
		if(!button.dataset.callback){
			Tool.printError("button " + button.id + " is missing 'data-callback' attribute. It needs a callback function to recieve and handle " +
				"the response from the server.");
			return -1;
		}
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
				response = JSON.parse(responseText);
				callback(response);
				if(response.notifications){
					notifications.retrieve(response.notifications);
				}
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
				Tool.printError("Markus F did something wrong, ask him to fix it.");
			}
		}
	}
}
// check Element content
mf_AjaxHandler.prototype.searchChildren = function(element){
	// See searchElement() for more information
	
	// check children
	for(var i=0; i<element.children.length; i++){
		var child = element.children[i];
		this.searchElement(child);
	}
}
// search element and all children for ajax templates
mf_AjaxHandler.prototype.searchElement = function(element){
	// This function will scan all elements recursively to find html with data-xxx elements
	
	// It is important that the tester puts its own listener to html elements first,
	// or the elements may be removed before a recording is made
	mf_testHandeler.addTestListener(element);
	// Search for buttons
	this.checkButton(element);
	// Search children
	if(!this.findAjaxData(element)){
		for(var i=0; i<element.children.length; i++){
			var child = element.children[i];
			this.searchElement(child);
		}
	}
}
mf_AjaxHandler.prototype.findAjaxData = function(element){
	// If element has data-load, ajax calls will be made to fill in more content.
	// If element has data-timeline, a timeline will fill the element.
	
	// not backwards compatability warning
	if(!element.dataset.target && (element.dataset.fill || element.dataset.replace)){
		Tool.printError("Element with id \"" + element.id + "\" has a data-fill attribute but no target. " +
			"This is not supported as of version 1.0.0. If you want to load data on load, try \"data-load\" instad. " +
			"See \"html/htmlAjaxInstructions.txt\" for more info."
		);
		return false;
	}
	//
	if(element.tagName == "SCRIPT" && element.dataset.run == ""){
		var code = element.innerHTML;
		mf_AjaxHandler.evaluateScriptQue.push(code);
		return false;
	}
	if(element.dataset.timeline == "" || element.dataset.load){
		if(element.dataset.timeline == ""){ // load "mf_timeline.js"
			var index = mf_addTimeline(element);
			if(element.dataset.position || element.dataset.zoom){
				var pos = parseFloat(element.dataset.position);
				var zoom = parseFloat(element.dataset.zoom);
				if(!pos){
					Tool.printError("Element with id \"" + element.id + "\" is missing or has wrongly formatted data-position=\"someNumber\" attribute.");
				}
				if(!zoom){
					Tool.printError("Element with id \"" + element.id + "\" is missing or has wrongly formatted data-zoom=\"someNumber\" attribute.");
				}
				mf_timeline.timelines[index].position = pos;
				mf_timeline.timelines[index].targetPosition = pos;
				mf_timeline.timelines[index].zoom = zoom;
			}
		}else{ // load in other content
			if(element.dataset.load){
				this.fillElementArgElement(element, element.dataset.load);
			}else{
				Tool.printError("Markus F did something wrong, ask him to fix it.");
				return false;
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
	// See html/htmlAjaxInstructions.txt for usecase.
	
	if(!this.checkDomLoaded(this.addLastChild, elementId, url, data)){
		return;
	}
	if(!elementId){Tool.printError("Missing argument \"elementId\"", 1);return -1;}
	if(!url){Tool.printError("Missing argument \"url\"", 1);return -1;}
	var element = document.getElementById(elementId);
	if(!element){
		Tool.printError("no element of id: \"" + elementId + "\" is found.");
		return -1;
	}
	this.addLastChildArgElement(element, url, data);
}
mf_AjaxHandler.prototype.addLastChildArgElement = function(element, url, data = null){
	// See html/htmlAjaxInstructions.txt for usecase.
	
	if(!this.checkDomLoaded(this.addLastChildArgElement, element, url, data)){
		return;
	}
	var dummy = document.createElement("DIV");
	element.append(dummy);
	this.replaceElementArgElement(dummy, url, data);
}
mf_AjaxHandler.prototype.addFirstChild = function(elementId, url, data = null){
	// See html/htmlAjaxInstructions.txt for usecase.
	
	if(!this.checkDomLoaded(this.addFirstChild, elementId, url, data)){
		return;
	}
	if(!elementId){Tool.printError("Missing argument \"elementId\"", 1);return -1;}
	if(!url){Tool.printError("Missing argument \"url\"", 1);return -1;}
	var element = document.getElementById(elementId);
	if(!element){
		Tool.printError("no element of id: \"" + elementId + "\" is found.");
		return -1;
	}
	this.addFirstChildArgElement(element, url, data);
}
mf_AjaxHandler.prototype.addFirstChildArgElement = function(element, url, data = null){
	// See html/htmlAjaxInstructions.txt for usecase.
	
	if(!this.checkDomLoaded(this.addFirstChildArgElement, element, url, data)){
		return;
	}
	var dummy = document.createElement("DIV");
	element.insertBefore(dummy, element.firstChild);
	this.replaceElementArgElement(dummy, url, data);
}
mf_AjaxHandler.prototype.removeElement = function(elementId){
	// See html/htmlAjaxInstructions.txt for usecase.
	
	if(!this.checkDomLoaded(this.removeElement, elementId)){
		return;
	}
	if(!elementId){Tool.printError("Missing argument \"elementId\"", 1);return -1;}
	var element = document.getElementById(elementId);
	if(!element){
		Tool.printError("no element of id: \"" + elementId + "\" is found.");
		return -1;
	}
	element.parentElement.removeChild(element);
}
mf_AjaxHandler.prototype.placeAfterElement = function(elementId, url, data = null){
	// See html/htmlAjaxInstructions.txt for usecase.
	
	if(!this.checkDomLoaded(this.placeAfterElement, elementId, url, data)){
		return;
	}
	if(!elementId){Tool.printError("Missing argument \"elementId\"", 1);return -1;}
	if(!url){Tool.printError("Missing argument \"url\"", 1);return -1;}
	var element = document.getElementById(elementId);
	if(!element){
		Tool.printError("no element of id: \"" + elementId + "\" is found.");
		return -1;
	}
	this.placeAfterElementArgElement(element, url, data);
}
mf_AjaxHandler.prototype.placeAfterElementArgElement = function(element, url, data = null){
	// See html/htmlAjaxInstructions.txt for usecase.
	
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
	// See html/htmlAjaxInstructions.txt for usecase.
	
	if(!this.checkDomLoaded(this.placeBeforeElement, elementId, url, data)){
		return;
	}
	if(!elementId){Tool.printError("Missing argument \"elementId\"", 1);return -1;}
	if(!url){Tool.printError("Missing argument \"url\"", 1);return -1;}
	var element = document.getElementById(elementId);
	if(!element){
		Tool.printError("no element of id: \"" + elementId + "\" is found.");
		return -1;
	}
	this.placeBeforeElementArgElement(element, url, data);
}
mf_AjaxHandler.prototype.placeBeforeElementArgElement = function(element, url, data = null){
	// See html/htmlAjaxInstructions.txt for usecase.
	
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
	// See html/htmlAjaxInstructions.txt for usecase.
	
	if(!this.checkDomLoaded(this.replaceElement, elementId, url, data)){
		return;
	}
	if(!elementId){Tool.printError("Missing argument \"elementId\"", 1);return -1;}
	if(!url){Tool.printError("Missing argument \"url\"", 1);return -1;}
	var element = document.getElementById(elementId);
	if(!element){
		Tool.printError("no element of id: \"" + elementId + "\" is found.");
		return -1;
	}
	this.replaceElementArgElement(element, url, data);
}
mf_AjaxHandler.prototype.replaceElementArgElement = function(element, url, data = null){
	// See html/htmlAjaxInstructions.txt for usecase.
	
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
	// See html/htmlAjaxInstructions.txt for usecase.
	
	if(!this.checkDomLoaded(this.fillElement, elementId, url, data)){
		return;
	}
	if(!elementId){Tool.printError("Missing argument \"elementId\"", 1);return -1;}
	if(!url){Tool.printError("Missing argument \"url\"", 1);return -1;}
	var element = document.getElementById(elementId);
	if(!element){
		Tool.printError("no element of id: \"" + elementId + "\" is found.");
		return -1;
	}
	this.fillElementArgElement(element, url, data);
}
mf_AjaxHandler.prototype.fillElementArgElement = function(element, url, data = null){
	// See html/htmlAjaxInstructions.txt for usecase.
	
	if(!this.checkDomLoaded(this.fillElementArgElement, element, url, data)){
		return;
	}
	this.loadInContent(element, url, function(){
		// check children
		this.searchChildren(element);
	}.bind(this), data);
	
}
mf_AjaxHandler.prototype.loadInContent = function(element, url, callback, data = null){
	// Element will be filled with content in url. Example url = "/getHTML?html=someContent".
	// In the example above, the element will be filled with someContent.
	// "data" is optional, if it is provided will data be used in the templater instead of the data
	// in the server response.
	
	//
	mf_AjaxHandler.nrOfCallsInProgress++;
	//
	mf_AjaxHandler.ajaxGet(url, function(responseText){
		var response = JSON.parse(responseText); // response = {template: someTemplate, data: somedata}
		if(data){
			response.data = data;
		}
		if(response.notifications){
			notifications.retrieve(response.notifications);
		}
		response.template = templater(response.template, response.data);
		//notification(response.notification);
    
		while(element.firstChild){
			element.removeChild(element.firstChild);
		}

		element.innerHTML = response.template;

/*

		var parser = new DOMParser();
		// delete children of element
		while(element.firstChild){
			element.removeChild(element.firstChild);
		}
		// fill element with new children
		var dummy = parser.parseFromString(response.template, "text/html").body;
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
	// "address" is the address the http requst is requesting. "Callback" will recieve the response from the server.
	// "CallbackFail" is called if an error occurs.
	
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
	// "data" is a javascript object that will be packed into a json object and sent.
	// "address" is the address the http requst is requesting. "Callback" will recieve the response from the server.
	
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
	// "form" is an html form that will be sent as a FormData object.
	// "address" is the address the http requst is requesting. "Callback" will recieve the response from the server.
	
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
	// This will add the root to an address if it is missing it.
	// Example: "/static/js/mf_testerData.js" -> "http://127.0.0.1:5000/static/js/mf_testerData.js"
	
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
	// It will check if the dom is loaded, if the dom is loaded, it will return true
	// If the dom is not loaded, it will return false, and call the callback function with additional arguments
	// when the dom is loaded.
	
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
	// This function checks will decrement the mf_AjaxHandler.nrOfCallsInProgress counter,
	// if the counter reaches 0, it will dispatch the custom event "onFullLoad" and call all scripts
	// loaded with ajax.
	
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





