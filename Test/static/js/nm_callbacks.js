function cb(){}

cb.prototype.login = function(response){
	if(response.success){
		router.navigate('/loggedin');
	}else{
		router.navigate();
	}
}

cb.prototype.forgotpass = function(response){	
	if(response.success){
		router.navigate();
	}else{
		router.navigate();
	}	
}

cb.prototype.newuser = function(response){	
	if(response.success){
		console.log(response.data)
		//mf_ajaxHandler.replaceElement(elementid = "main", url = "/getTMPL?tmpl=main_welcome");
	}else{
		router.navigate();
	}	
}

cb.prototype.calendar_new = function(response){	
	if(response.success){
		console.log(response.data)
		router.navigate('calendar/edit/'+response.data.id);
		//mf_ajaxHandler.replaceElement(elementid = "main", url = "/getTMPL?tmpl=newuser");
	}else{
		//mf_ajaxHandler.replaceElement(elementid = "login", url = "/getHTML?html=form_login");
	}	
}

cb.prototype.calendar_edit = function(response){	
	if(response.success){
		console.log(response.data)
		router.navigate('calendar/edit/'+response.data.id);
		//mf_ajaxHandler.replaceElement(elementid = "main", url = "/getTMPL?tmpl=newuser");
	}else{
		//mf_ajaxHandler.replaceElement(elementid = "login", url = "/getHTML?html=form_login");
	}	
}

cb.prototype.event_new = function(response){	
	if(response.success){
		console.log(response.data)
		router.navigate('event/edit/'+response.data.id);
		//mf_ajaxHandler.replaceElement(elementid = "main", url = "/getTMPL?tmpl=newuser");
	}else{
		//mf_ajaxHandler.replaceElement(elementid = "login", url = "/getHTML?html=form_login");
	}	
}

cb.prototype.event_edit = function(response){	
	if(response.success){
		console.log(response.data)
		router.navigate('event/edit/'+response.data.id);
		//mf_ajaxHandler.replaceElement(elementid = "main", url = "/getTMPL?tmpl=newuser");
	}else{
		//mf_ajaxHandler.replaceElement(elementid = "login", url = "/getHTML?html=form_login");
	}	
}

var cb = new cb();


