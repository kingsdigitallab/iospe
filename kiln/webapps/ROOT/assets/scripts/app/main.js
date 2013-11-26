define([], function() {
  $('a.disabled').on('click', function(e) {
    e.preventDefault();
  });

  this.parse_inscription = function(query) {
    var n = query.match(/^(?:(\w+)[\.\s])?(\d{1,3})$/);

    if (!n || !n[2]) {
      return false;
    }

    n[1] = this.clean_corpus(n[1]);

    if (!n[1]) {
      return false;
    }

    return {
      'pref': '' + n[1] + '.',
      'n': n[2]
    };
  };

  this.clean_corpus = function(parsed_corpus) {
    var dictionary = [
      //['3', 'IIV'],
      //['4', 'IV'],
      ['5', 'V']//,
      //['6', 'VI'],
    ];

    var found = dictionary.filter(function(n, i) {
      return n[0] == parsed_corpus || n[1] == parsed_corpus || n[1]== parsed_corpus.toUpperCase();
    });

    return (found && found.length > 0)? found[0][0]: false;
  };

  this.build_inscription_doc = function(inscription, extension) {
    var ext = extension || '.html';

    return ('/' + inscription.pref +
      inscription.n +
      this.get_kiln_url_language_suffix() +
      ext);

  };

  this.get_kiln_url_language_suffix = function() {
    var language = $('body').attr('data-lang');
    return (language == 'ru') ? '-ru' : '';
  };

  this.pad = function(n, c, w) {
    var wi = w || 3,
      ci = c || '0',
      ni = '' + window.parseInt(n);

    return '' + Array(wi - ni.length + 1).join(ci) + ni;
  };



  $('#jumpForm').on('submit',
    function(e) {
      e.preventDefault();
      var $nt = $('#numTxt'),
        query = $nt.val(),
        i = parse_inscription(query);

      $nt.removeClass('error').next('small').remove();

      if (i) {
        location.href = build_inscription_doc(i);
      } else {
        $('#numTxt', this).addClass('error').after('<small>Invalid id number</small>');
      }

    });

  $('#jumpForm .button.submit').on('click', function(e) {
    e.preventDefault();
    $('#jumpForm').trigger('submit');
  });

  return this;
});