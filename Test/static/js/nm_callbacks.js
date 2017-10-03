
function callBackExample(response){
	if(response.successLogin){
		mf_ajaxHandler.fillElement(elementid = "login", url = "/getHTML?html=mf_sucsess.html");
		//document.getElementById("login").innerHTML = "<h1>SUCCESS</h1>";
	}else{
		//document.getElementById("login").innerHTML = "<h1>FAIL</h1>";
		mf_ajaxHandler.replaceElement(elementid = "login", url = "/getHTML?html=mf_fail.html");
	}
}


