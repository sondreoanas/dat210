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
		router.navigate('/forgotpass_sent');
	}else{
		router.navigate();
	}	
}

cb.prototype.reset_pass = function(response){	
	if(response.success){
		mf_ajaxHandler.replaceElement(elementid = "main", url = "/getTMPL?tmpl=main_welcome", data = response.data);
	}else{
		router.navigate();
	}	
}


cb.prototype.newuser = function(response){	
	if(response.success){
		console.log(response.data)
		mf_ajaxHandler.replaceElement(elementid = "main", url = "/getTMPL?tmpl=main_welcome", data = response.data);
		//router.navigate('welcome');
	}else{
		console.log(response.data);
		console.log("failed")
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
		//router.navigate('event/edit/'+response.data.calendar_id+'/'+response.data.id);
		var start = response.data.start,
		body = response.data.end - response.data.start,
		start = start + (body/2),
		body = Math.floor( (response.data.end - response.data.start) * 1.25);

		router.navigate('home/'+start+'/'+body)
		//mf_ajaxHandler.replaceElement(elementid = "main", url = "/getTMPL?tmpl=newuser");
	}else{
		//mf_ajaxHandler.replaceElement(elementid = "login", url = "/getHTML?html=form_login");
	}	
}

cb.prototype.event_edit = function(response){	
	if(response.success){
		console.log(response.data)
		router.navigate('event/edit/'+response.data.calendar_id+'/'+response.data.id);
		//mf_ajaxHandler.replaceElement(elementid = "main", url = "/getTMPL?tmpl=newuser");
	}else{
		//mf_ajaxHandler.replaceElement(elementid = "login", url = "/getHTML?html=form_login");
	}	
}

cb.prototype.task_new = function(response){	
	if(response.success){
		//console.log(response.data)
		router.navigate('task/edit/'+response.data.id);
		//mf_ajaxHandler.replaceElement(elementid = "main", url = "/getTMPL?tmpl=newuser");
	}else{
		//mf_ajaxHandler.replaceElement(elementid = "login", url = "/getHTML?html=form_login");
	}	
}

cb.prototype.task_edit = function(response){	
	if(response.success){
		console.log(response.data)
		//router.navigate('event/edit/'+response.data.id);
		//mf_ajaxHandler.replaceElement(elementid = "main", url = "/getTMPL?tmpl=newuser");
	}else{
		//mf_ajaxHandler.replaceElement(elementid = "login", url = "/getHTML?html=form_login");
	}	
}

var cb = new cb();

