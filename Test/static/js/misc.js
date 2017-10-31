
function main_task_new_add_todo(){

    var name = document.getElementById("form_todo_name").value, 
    ul = document.getElementById("task_new_todo_list"),
    pos = ul.dataset.pos,
    data = {"pos": pos,"name":name};

    mf_ajaxHandler.addLastChild(elementId="task_new_todo_list", url="/getTMPL?tmpl=todo_list", data=data);

    ul.dataset.pos++;

};

function main_task_new_remove_todo(pos){

    mf_ajaxHandler.removeElement(elementid="todo_li_nr_"+pos);

    var ul = document.getElementById("task_new_todo_list");

    //ul.dataset.pos--;
    
    };
    

