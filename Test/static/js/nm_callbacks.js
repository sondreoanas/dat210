function cb(){}


cb.prototype.login = function(response){
	if(response.successLogin){
		router.navigate('/loggedin');
	}else{
<<<<<<< HEAD
		router.navigate();
=======
		//document.getElementById("login").innerHTML = "<h1>FAIL</h1>";
		mf_ajaxHandler.replaceElement(elementid = "login", url = "getHTML?html=form_login");
>>>>>>> origin/nils
	}
}

cb.prototype.newuser = function(response){	
	if(response.success){
		mf_ajaxHandler.replaceElement(elementid = "newuser", url = "getTMPL?tmpl=newuser");
	}else{
		router.navigate();
	}	
}

cb.prototype.calendar_new = function(response){	
	if(response.success){

		mf_ajaxHandler.replaceElement(elementid = "newuser", url = "getTMPL?tmpl=newuser");

	}else{
		mf_ajaxHandler.replaceElement(elementid = "login", url = "getHTML?html=form_login");
	}	
}

var cb = new cb();


