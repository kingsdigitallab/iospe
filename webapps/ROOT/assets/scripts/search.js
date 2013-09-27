// search specific functions

require(['common'], function(common) {
  require(['app/main', 'jquery-ui'],
    function (main, jqui) {
      var $date_slider = $( "#date-slider-range" );

      function updateDateRangeLabel() {
        var $label = $( "#date-slider-label" ),
          ui_values = $date_slider.slider('option', 'values'),
          suffix = $date_slider.data('label-suffix');

        $label.text( "" + ui_values[0] + " - " + ui_values[1] + ' ' + suffix);
      }

      $date_slider.slider({
        range: true,
        min: $date_slider.data('range-min'),
        max: $date_slider.data('range-max'),
        values: [ $date_slider.data('value-min'), $date_slider.data('value-max')],
        slide: function( event, ui ) {
          updateDateRangeLabel();
        },
        stop: function (event, ui) {
          var new_relative_location = '../../' + ui.values[0] + '/' + ui.values[1] + '/?' + $date_slider.data('query');
          console.log(new_relative_location);
          document.location.href = new_relative_location;
        }
      });

      updateDateRangeLabel();


    });
});