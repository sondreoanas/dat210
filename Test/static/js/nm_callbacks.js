
function callBackExample(response){
	if(response.successLogin){
		mf_ajaxHandler.fillElement(elementid = "login", html = "<h1>SUCCESS</h1>");
		//document.getElementById("login").innerHTML = "<h1>SUCCESS</h1>";
	}else{
		//document.getElementById("login").innerHTML = "<h1>FAIL</h1>";
		mf_ajaxHandler.fillElement(elementid = "login", html = "<h1>FAIL</h1>");
	}
}


