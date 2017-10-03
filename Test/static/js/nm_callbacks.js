function cb(){}


cb.prototype.login = function(response){
	if(response.successLogin){
		
		mf_ajaxHandler.replaceElement(elementid = "front", url = "getHTML?html=main_home");
		//mf_ajaxHandler.fillElement(elementid = "login", url = "/getHTML?html=mf_sucsess.html");
		//document.getElementById("login").innerHTML = "<h1>SUCCESS</h1>";
	}else{
		//document.getElementById("login").innerHTML = "<h1>FAIL</h1>";
		mf_ajaxHandler.replaceElement(elementid = "login", url = "getHTML?html=form_login");
		
	}
}

cb.prototype.newuser = function(response){
	
	if(response.success){
		mf_ajaxHandler.replaceElement(elementid = "newuser", url = "getTMPL?tmpl=newuser");
	}else{
		mf_ajaxHandler.replaceElement(elementid = "login", url = "getHTML?html=form_login");
	}

	
}

var cb = new cb();


