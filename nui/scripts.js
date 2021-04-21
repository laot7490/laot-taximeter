document.onreadystatechange = () => { /* laot#2599 */
    if (document.readyState === "complete") {
        window.addEventListener('message', function(event) {
            if (event.data.type == "gui") {
                document.body.style.display = event.data.data ? "block" : "none";

                $("#kmmetin").empty();
                $("#tutarmetin").empty();
                $("#konum").empty();

                $("#kmmetin").append( event.data.km + " KM");
                $("#tutarmetin").append( "$" + event.data.cost );
                $("#konum").append(event.data.zone);

                $(".icon").css("color", event.data.color);
            };
        });
    };
};