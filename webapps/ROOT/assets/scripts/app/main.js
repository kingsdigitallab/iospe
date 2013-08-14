define([], function() {

    var get_kiln_url_language_suffix = function () {
        var language = $('body').attr('data-lang');
        return (language == 'ru')? '-ru': '';
    };

    $(function() {
        //$('h2').css('color', '#f00');
    });
});