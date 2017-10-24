var root = "http://127.0.0.1:5000";
var router = new Navigo(root);

function loadmenu(){
    if (document.readyState != "complete") mf_ajaxHandler.replaceElement(elementid = "mainmenu", url = "/getTMPL?tmpl=nav&data=nav");
}


router
.on({
// FRONT
    'login': function () {
        mf_ajaxHandler.replaceElement(elementid = "main", url = "/getHTML?html=main_login");        
    },
    'forgotpass': function () {
        mf_ajaxHandler.replaceElement(elementid = "main", url = "/getHTML?html=main_forgotpass");        
    },
    'newuser': function () {
        mf_ajaxHandler.replaceElement(elementid = "main", url = "/getHTML?html=main_newuser");        
    },
    'loggedin': function () {
        mf_ajaxHandler.replaceElement(elementid = "mainmenu", url = "/getTMPL?tmpl=nav&data=nav");
        mf_ajaxHandler.replaceElement(elementid = "main", url = "/getHTML?html=main_home");        
    },
    'welcome': function () {

    },
    'loggedout': function () {
        mf_ajaxHandler.replaceElement(elementid = "main", url = "/getTMPL?tmpl=main_loggedout&data=loggout");
    },

// HOME
    'home': function () {
        loadmenu();
        mf_ajaxHandler.replaceElement(elementid = "main", url = "/getHTML?html=main_home");        
    },

//CALENDAR
    'calendar/new': function () {
        loadmenu();
        mf_ajaxHandler.replaceElement(elementid = "main", url = "/getHTML?html=main_calendar_new");
    },
    'calendar/list': function () {
        loadmenu();
        mf_ajaxHandler.replaceElement(elementid = "main", url = "/getHTML?html=main_calendar_list");
    },
    'calendar/edit/:id': function (params) {
        loadmenu();
        mf_ajaxHandler.replaceElement(elementid = "main", url = "/getTMPL?tmpl=main_calendar_edit&data=calendar_edit&id="+params.id);
    },

// EVENT
    'event/new': function () {
        loadmenu();
        mf_ajaxHandler.replaceElement(elementid = "main", url = "/getHTML?html=main_event_new");
    },
    'event/list': function () {
        loadmenu();
        mf_ajaxHandler.replaceElement(elementid = "main", url = "/getHTML?html=main_event_list");
    },
    'event/edit/:id': function (params) {
        loadmenu();
        mf_ajaxHandler.replaceElement(elementid = "main", url = "/getTMPL?tmpl=main_event_edit&data=event_edit&id="+params.id);
    },

// DEFAULT
    '*': function () {
        mf_ajaxHandler.replaceElement(elementid = "main", url = "/getHTML?html=main_login");
    }
    })
.resolve();
