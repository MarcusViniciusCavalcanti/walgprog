$(function () {

    console.log("Carregou Página");

    $("#institution_state").on( "click", function() {
        console.log("Selecionau Estado");
        var state_id = $(this).val();
        $.ajax({
            method: "GET",
            url: "/admins/states/" + state_id + "/cities",
            success: function(data){
                $('#institution_city').html("");
                $.each(data['cities'], function (index, city) {
                    $('#institution_city').append($('<option>', {
                        value: city['id'],
                        text: city['name']
                    }));
                });
            }
        });
    });
});