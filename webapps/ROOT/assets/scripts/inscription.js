// Inscriptions specific functions

require(['./base'],
  function (base) {

    var build_inscription_id = function (n) {
      return 'byz' + ('0' * (3 - n.length)) + n;
    };

    var parse_inscription_id = function (val) {
      var n = val.match(/^(\d{1,3})(\.\d)?([a-j])?$/);
      return n;
    };

    $(function() {
        $('#jumpForm').on('submit',
          function (e) {
            e.preventDefault();
            var n = $('#numTxt').val();
            n = parse_inscription_id(n);

            if (n) {
              location.href = '.' + build_inscription_id(n) + base.get_kiln_url_language_suffix() + '.html';
            } else {
              $('#numTxt', this).text('Invalid id number');
            }

          });

        $('#jumpForm .button.submit').on('click', function(e) {
          e.preventDefault();
          $('#jumpForm').trigger('submit');
        });
    });
});
