
function main_event_new_init_flatpicker(){

    var form_event_start = flatpickr("#form_event_start", {
        enableTime: true,
        time_24hr: true, 
        minDate: "today",
        dateFormat: "Z",
        altInput: true,
        altFormat: "F j, Y H:i"

    });

    var form_event_end = flatpickr("#form_event_end", {
        enableTime: true,
        time_24hr: true, 
        minDate: "today",
        dateFormat: "Z",
        altInput: true,
        altFormat: "F j, Y H:i"
    });

    form_event_start.element.addEventListener("change", function(){
    
        form_event_end.set("minDate", form_event_start.element.value);    
        console.log(form_event_start.selectedDates);   
        console.log(new Date(form_event_start.selectedDates[0]).getTime());
    
    
    });
    form_event_end.element.addEventListener("change", function(){
    
        form_event_start.set("maxDate", form_event_end.element.value);   
        console.log(form_event_end.selectedDates);   
        console.log(new Date(form_event_end.selectedDates[0]).getTime());
    
    });

};



function navSelect(){

    function recursUp(element){
        if (element.classList.contains("root")){
            element.classList.remove("open");
        }else{
            target = element.parentNode.parentNode;
            target.classList.add("open", "selected");
            recursUp(target);
        };
    };

    function cleanUp(){
        var selected_elements = document.getElementsByClassName("selected"),
        open_elements = document.getElementsByClassName("open");
        while(selected_elements.length > 0){
            selected_elements[0].classList.remove("selected");
        };
        while(selected_elements.length > 0){
            open_elements[0].classList.remove("open");
        };
    };

    function closeUp(){
        var root_elements = document.getElementsByClassName("root");
        for(var i=0;i<root_elements.length;i++){
            if (root_elements[i].classList.contains("open")) root_elements[i].classList.remove("open");
        }
    }

    var nav_elements = document.getElementsByClassName("button_nav");

    for(var i=0,len=nav_elements.length;i<len;i++){
        nav_elements[i].addEventListener("click", function(e){
            e.stopPropagation();
            var target = this.parentNode;
            if (target.classList.contains("isparent")){
                closeUp();
                target.classList.toggle("open");
            }else{
                cleanUp();
                target.classList.add("selected");
                recursUp(target);
            };    
        });
    };

    document.addEventListener("click",function(){
        closeUp();
    });
    
}