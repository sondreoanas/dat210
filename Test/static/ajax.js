window.addEventListener("load", initAjax);
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
		var xhttp = new XMLHttpRequest();
		xhttp.onreadystatechange = function() {
			if(this.readyState == 4 && this.status == 200){
				loadIntContent(element, this.responseText);
			}
		}
		xhttp.open("GET", element.dataset.ajax, true);
		xhttp.send();
		return true;
	}else{
		return false;
	}
}
function loadIntContent(element, html){
	alert(html);
}




