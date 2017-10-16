flatpickr(".eventDatetime", {
    enableTime: true,
    time_24hr: true, 
    mode: "range",
    minDate: "today",
    disable: [
        function(date) {
            // disable every multiple of 8
            return !(date.getDate() % 8);
        }
    ]
});