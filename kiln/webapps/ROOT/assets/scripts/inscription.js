// Inscriptions specific functions

require(['common'], function(common) {
  require(['app/main', 'highlightjs'],
    function (main, highlightjs) {

      var parse_inscription = function (query) {
        var n = query.match(/^(?:(\d?)\.)?(\d{1,3})$/);

        if (!n || !n[2]) {
          return false;
        }

        return {'pref': '' + (n[1] || '5') + '.',
                'n': n[2]};
      };

      var build_inscription_doc = function(inscription, extension) {
        var ext = extension || '.html';

        return ('' + inscription.pref +
                   inscription.n +
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

      $('pre code').each(function(i, e) {
        hljs.tabReplace = '    '; // 4 spaces
        //hljs.tabReplace = '<span class="indent">\t</span>';
        hljs.highlightBlock(e);
      });
  });
});