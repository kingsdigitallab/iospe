require(['jquery'],
  function($) {
  $('a.disabled').on('click', function(e) {
    e.preventDefault();
  });

  this.parse_inscription = function(query) {
    // Matches inscription with PEXXXXXX numbers
    // This will eventually become the default
    var n = query.match(/^(PE)(\d{7})$/);

    if (n && n[2]) {
      return {
          'corpus': n[1],
          'n': n[2],
          'suffix': ''
      }
    } else {

      // Matches inscriptions in various forms:
      // V 1 = 5.1 = v.0001
      // 5.88a
      // XXX 20 = 30.20
      var n = query.match(/^(?:(\w+)[\.\s])?(\d{1,4})\s?(\w{0,1})$/);

      if (!n || !n[2]) {
          return false;
      }

      n[1] = this.clean_corpus(n[1]);

      if (!n[1]) {
          return false;
      }

      n[2] = parseInt(n[2]);

      return {
          'corpus': '' + n[1] + '.',
          'n': n[2],
          'suffix': n[3]
      }

    }
  };

  this.clean_corpus = function(parsed_corpus) {
    if (!parsed_corpus) {
      return false;
    }

    var dictionary = [
      ['1', 'I'],
      ['2', 'II'],
      ['3', 'III'],
      //['4', 'IV'],
      ['5', 'V'],
      //['6', 'VI'],
      // ['30', 'XXX'],
      // ['40', 'XL']
    ];

    var found = dictionary.filter(function(n, i) {
      return n[0] == parsed_corpus || n[1] == parsed_corpus || n[1] == parsed_corpus.toUpperCase();
    });

    return (found && found.length > 0) ? found[0][0] : false;
  };

  this.build_inscription_doc = function(inscription, extension) {
    var ext = extension || '.html';

    return ('/' + inscription.corpus +
      inscription.n +
      inscription.suffix +
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

  this.go_to_person = function(id) {
    var $person_row = $(id).parents('tr');

    $('html, body').animate({
      scrollTop: $person_row.offset().top - 50
    }, 2000, function() {
      //
      $('tr.yellow').css('background', '').removeClass('yellow');

      $person_row.addClass('yellow').animate({
          backgroundColor: '#ffff66'
        },
        100);
    });

  }


  $('#jumpForm').on('submit',
    function(e) {
      e.preventDefault();
      var $nt = $('#numTxt'),
        query = $nt.val(),
        i = parse_inscription(query);
        console.log(i);

      $nt.removeClass('error').next('small').remove();

      if (i) {
        location.href = build_inscription_doc(i);
      } else {
        $('#numTxt', this).addClass('error').after('<small class="error">Invalid id number</small>');
      }

    });

  $('.relation_link').on('click', function(e) {
    e.preventDefault();
    console.log($(this).attr('href'));
    go_to_person($(this).attr('href'));
  });

  $('.has-tip[title]').on('mouseenter', function(e){
    e.preventDefault();
    // console.log('prevented');
  });
    return this;
});
