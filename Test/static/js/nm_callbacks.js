function cb(){}


cb.prototype.login = function(response){
	if(response.successLogin){
		router.navigate('/loggedin');
	}else{
		router.navigate();
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


