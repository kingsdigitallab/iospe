// Inscriptions specific functions

require(['common', 'app/main', 'vendor/rainbow/js/rainbow'],
  function (common, main, Rainbow) {


    var parse_inscription = function (query) {
      var n = query.match(/^(b?y?z?)?\s*(\d{1,3})(\.\d)?([a-j])?$/);

      if (!n || !n[2]) {
        return false;
      }

      return {'byz': 'byz',
              'n': main.pad(n[2]),
              'sub': '' + (n[3] || ''),
              'suffix': '' + (n[4] || '')};
    };

    var build_inscription_doc = function(inscription, extension) {
      var ext = extension || '.html';

      return ('' + inscription.byz +
                 inscription.n +
                 inscription.sub +
                 inscription.suffix +
                 main.get_kiln_url_language_suffix() +
                 ext);

    };

    $(function() {
        $('#jumpForm').on('submit',
          function (e) {
            e.preventDefault();
            var $nt = $('#numTxt'),
                query = $nt.val(),
                i = parse_inscription(query);

            $nt.removeClass('error').next('small').remove();

            if (i) {
              location.href =  build_inscription_doc(i);
            } else {
              $('#numTxt', this).addClass('error').after('<small>Invalid id number</small>');
            }

          });

        $('#jumpForm .button.submit').on('click', function(e) {
          e.preventDefault();
          $('#jumpForm').trigger('submit');
        });
    });
    Rainbow.color();
});
