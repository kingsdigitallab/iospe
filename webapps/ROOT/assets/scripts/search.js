// search specific functions

require(['common'], function(common) {
  require(['app/main', 'jquery-ui', 'purl'],
    function (main, jqui, purl) {
      function update_date_range_label() {
        var $date_slider = $( "#date-slider-range" ),
          $label = $( "#date-slider-label" ),
          ui_values = $date_slider.slider('option', 'values'),
          suffix = $date_slider.data('label-suffix');

        $label.text( "" + ui_values[0] + " - " + ui_values[1] + ' ' + suffix);
      }

      function setup_date_slider() {
        var $date_slider = $( "#date-slider-range" );

        $date_slider.slider({
          range: true,
          min: $date_slider.data('range-min'),
          max: $date_slider.data('range-max'),
          values: [ $date_slider.data('value-min'), $date_slider.data('value-max')],

          slide: function( event, ui ) {
            update_date_range_label();
          },

          stop: function (event, ui) {
            var new_relative_location = '../../' + ui.values[0] + '/' + ui.values[1] + '/?' + $date_slider.data('query');
            console.log(new_relative_location);
            document.location.href = new_relative_location;
          }
        });

        update_date_range_label();

      }

      setup_date_slider();


      function prepare_search_form() {
        var $search_form = $('#search_form'),
          old_query  = $search_form.data('query');


        $search_form.on('submit', function(e) {
          var query = $('input[name=q]', $search_form).val(),
            params = purl(document.location.href).param(),
            new_query_string = '';

          e.preventDefault();

          if (params.q === undefined) {
            params.q = [query];
          } else if ($.isArray(params.q)) {
            params.q.push(query);
          } else {
            params.q = [params.q, query];
          }

          new_query_string = $.param(params, true);

          // $params function encodes colons
          new_query_string = new_query_string.replace("%3A", ':');

          console.log(new_query_string);

          document.location.href = "?" + new_query_string;
        });
      }

      prepare_search_form();


    });
});