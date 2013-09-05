define([], function() {

    return {
        get_kiln_url_language_suffix: function () {
            var language = $('body').attr('data-lang');
            return (language == 'ru')? '-ru': '';
        },
        pad: function (n, c, w) {
          var wi = w || 3,
              ci = '0',
              ni = '' + window.parseInt(n);

          return '' + Array(wi - ni.length + 1).join(ci) + ni;
        }
    };
});