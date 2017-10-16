var root = "http://127.0.0.1:5000";
var router = new Navigo(root);

function loadmenu(){
    if (document.readyState != "complete") mf_ajaxHandler.replaceElement(elementid = "mainmenu", url = "getTMPL?tmpl=nav&data=nav");
}


router
.on({
// FRONT
    'forgotpass': function () {
        mf_ajaxHandler.replaceElement(elementid = "login", url = "getHTML?html=form_forgotpass");        
    },
    'newuser': function () {
        mf_ajaxHandler.replaceElement(elementid = "login", url = "getHTML?html=form_newuser");        
    },
    'loggedin': function () {
        mf_ajaxHandler.replaceElement(elementid = "mainmenu", url = "getTMPL?tmpl=nav&data=nav");
        mf_ajaxHandler.replaceElement(elementid = "main", url = "getHTML?html=main_home");        
    },

// HOME
    'home': function () {
        loadmenu();
        mf_ajaxHandler.replaceElement(elementid = "main", url = "getHTML?html=main_home");        
    },

//CALENDAR
    'calendar/new': function () {
        loadmenu();
        mf_ajaxHandler.replaceElement(elementid = "main", url = "getHTML?html=main_calendar_new");
    },
    'calendar/list': function () {
        loadmenu();
        mf_ajaxHandler.replaceElement(elementid = "main", url = "getHTML?html=main_calendar_list");
    },
    'calendar/edit/:id': function (params) {
        loadmenu();
        mf_ajaxHandler.replaceElement(elementid = "main", url = "getTMPL?tmpl=main_calendar_edit&data=main_calendar_edit&id="+params.id);
    },

// EVENT
    'event/new': function () {
        loadmenu();
        mf_ajaxHandler.replaceElement(elementid = "main", url = "getHTML?html=main_event_new");
    },

// DEFAULT
    '*': function () {
        mf_ajaxHandler.replaceElement(elementid = "main", url = "getHTML?html=main_front");
    }
    })
.resolve();
