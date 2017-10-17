

window.addEventListener('onFullLoad', function (e) { 
    
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

    
}, false);

