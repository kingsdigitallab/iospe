// search specific functions

require(['common'], function(common) {
  require(['app/main', 'jquery', 'jquery-ui', 'URIjs/URI'],
    function(main, $, jqui, URI) {
      function update_date_range_label(values) {
        var $date_slider = $("#date-slider-range"),
          $label = $("#date-slider-label"),
          suffix = $date_slider.data('label-suffix');

        $label.text("" + values[0] + " - " + values[1] + ' ' + suffix);
      }

      function setup_date_slider() {
        var $date_slider = $("#date-slider-range");

        $date_slider.slider({
          range: true,
          min: $date_slider.data('range-min'),
          max: $date_slider.data('range-max'),
          values: [$date_slider.data('value-min'), $date_slider.data('value-max')],
          step: 25,

          create: function() {
            update_date_range_label($(this).slider('values'));
          },

          slide: function(event, ui) {
            update_date_range_label(ui.values);
          },

          stop: function(event, ui) {
            var new_relative_location = '../../' + ui.values[0] + '/' + ui.values[1] + '/?' + $date_slider.data('query');
            document.location.href = new_relative_location;
          }
        });
      }


      function prepare_search_form() {
        var $search_form = $('#search_form');

        $search_form.on('submit', function(e) {
          var query = "text:" + $('input[name=fq\\:text]', $search_form).val(),
            params = URI.parseQuery(URI.parse(document.location.href).query),
            new_query_string = '';

          e.preventDefault();

          if (params.fq === undefined) {
            params.fq = [query];
          } else if ($.isArray(params.fq)) {
            params.fq.push(query);
          } else {
            params.fq = [params.fq, query];
          }

          new_query_string = $.param(params, true);

          // $params function encodes colons
          // new_query_string = new_query_string.replace("%3A", ':');

          document.location.href = "?" + new_query_string;
        });
      }

      $(document).ready(function() {
        prepare_search_form();
        setup_date_slider();
      });



    });
});