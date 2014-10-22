
$(function() {

    $("form").on('click', '.add_fields', function (event) {
        var time = new Date().getTime();
        var regexp = new RegExp($(this).data('id'), 'g');
        $(this).before($(this).data('fields').replace(regexp, time));
       event.preventDefault();
        if ($(this).hasClass('geopoint')) {
          enforcePointsLimit();
        }
    });

    $("form").on('click', '.remove_fields', function (event) {
        event.preventDefault();
        var id = $(this).attr("id");
        //console.log($(this));
        //console.log($(this).parent().parent().prev('.destroyer'));
        $(this).parent().parent().prev('.destroyer').val('1');
        $(this).closest('.fields').remove();
        if ($(this).hasClass('geopoint')) {
          enforcePointsLimit();
        }





    });


});
