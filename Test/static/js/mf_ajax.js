window.addEventListener("load", initAjax);
function mf_AjaxHandler(){
	this.hasLoadedTimeline = false;
}
var mf_ajaxHandler = new mf_AjaxHandler();

function initAjax(){
	var body = document.getElementsByTagName("body")[0];
	searchChildren(body);
}
function searchChildren(element){
	if(!findAjaxData(element)){
		for(var i=0; i<element.children.length; i++){
			var child = element.children[i];
			searchChildren(child);
		}
	}
}
function findAjaxData(element){
	if(element.dataset.ajax){
		if(element.dataset.ajax == "/timeline"){ // load "mf_timeline.js"
			if(!mf_ajaxHandler.hasLoadedTimeline){
				ajax("/static/js/mf_timeline.js", function(responseText){
					eval(responseText);
					init();
					addTimeline(element);
				});
				mf_ajaxHandler.hasLoadedTimeline = true;
			}else{
				addTimeline(element)
			}
		}else{ // load in other content
			ajax(element.dataset.ajax, function(responseText){
				loadInContent(element, JSON.parse(responseText));
			});
		}
		// loading graphic?
		element.innerHTML = "loading...";
		
		return true;
	}else{
		return false;
	}
}
function loadInContent(element, data){


	data.template = templater(data.template, data.data);
	element.innerHTML = data.template;
	// check children
	for(var i=0; i<element.children.length; i++){
		var child = element.children[i];
		searchChildren(child);
	}
}
function ajax(address, callback){
	var xhttp = new XMLHttpRequest();
		xhttp.onreadystatechange = function() {
			if(this.readyState == 4 && this.status == 200){
				callback(this.responseText);
			}
		}
		xhttp.open("GET", address, true);
		xhttp.send();
}


/*var form = document.getElementById("form id");
var inputs = form.getElementByType("input");
inputs[2].value;*/







