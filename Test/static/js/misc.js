
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
    

function main_task_new_pick_interval(that){

    var monthsinyear = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
    weeksinyear = [],
    daysinyear = [],
    weeksinmonth = [],
    daysinmonth = [],
    daysinweek = ["Monday", "Tuesday", "Wednesday", "Thursday","Friday","Saturday","Sunday"],
    value = that.value,
    target = that.parentNode;

    for(i=1;i<53;i++){
        weeksinyear.push(i);
    }
    for(i=1;i<366;i++){
        daysinyear.push(i);
    }
    for(i=1;i<6;i++){
        weeksinmonth.push(i);
    }
    for(i=1;i<32;i++){
        daysinmonth.push(i);
    }


    generate = {
        "year":function(){
            var data = {
                "id": value,
                "options": ["month_year", "week_year", "day_year"],
                "labels": ["Month", "Week", "Day"],
                "value": "input"
            }
            return data;
        },
        "month_year":function(){
            var data = {
                "id": value,
                "options": ["week_month", "day_month"],
                "labels": ["Week", "Day"],
                "value": monthsinyear
            }
            return data;
        },
        "week_year":function(){
            var data = {
                "id": value,
                "options": ["day_week"],
                "labels": ["Day"],
                "value": weeksinyear
            }
            return data;
        },
        "day_year":function(){
            var data = {
                "id": value,
                "value": daysinyear
            }
            return data;
        },
        "month":function(){
            var data = {
                "id": value,
                "options": ["week_month", "day_month"],
                "labels": ["Week", "Day"],
                "value": "input"
            }
            return data;
        },
        "week_month":function(){
            var data = {
                "id": value,
                "options": ["day_week"],
                "labels": ["Day"],
                "value": weeksinmonth
            }
            return data;
        },
        "day_month":function(){
            var data = {
                "id": value,
                "value": daysinmonth
            }
            return data;
        },
        "week":function(){
            var data = {
                "id": value,
                "options": ["day_week"],
                "labels": ["Day"],
                "value": "input"
            }
            return data;
        },
        "day_week":function(){
            var data = {
                "id": value,
                "value": daysinweek
            }
            return data;
        },
        "day":function(){
            var data = {
                "id": value,
                "value": "input"
            }
            return data;
        }
    }


    if (generate[value]()){

        if(!document.getElementById("interval_container_"+parseInt(target.dataset.step))){
            var container = document.createElement("DIV");
            container.setAttribute("id","interval_container_"+parseInt(target.dataset.step));
            container.setAttribute("data-step",parseInt(target.dataset.step) + 1);
            target.appendChild(container);
        }

        mf_ajaxHandler.fillElement(elementid="interval_container_"+parseInt(target.dataset.step), url ="/getTMPL?tmpl=interval_further", data=generate[value]());

    }else{
        console.log(value)
    };

    

};

