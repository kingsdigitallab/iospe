// Inscriptions specific functions
require(['common'], function(common) {
  require(['app/main', 'jquery', 'leaflet', 'leaflet-groupedlayercontrol'],
    function(main, $, leaflet, lglc) {
      var $pleiadesmap = $('#pleiadesmap');

      if ($pleiadesmap.length) {
        $.ajax({
          dataType: "json",
          url: "../assets/scripts/blacksea.json",
          success: function(data) {
            drawPoint(data);
          }
        });

        function drawPoint(a) {
          for (i in a.features) {
            ancientMarker[i] = new L.marker([a.features[i].features[0]['geometry'].coordinates[1], a.features[i].features[0]['geometry'].coordinates[0]], {
              icon: marker
            });
            var link = String(a.features[i].features[0]['properties']['link'], a[i]);
            var popupContent = String("<h3>" + a.features[i]['title'] + "</h3>" +
              "<p>" + a.features[i]['description'] + "</p>" +
              "<p>" + a.features[i].features[0]['properties']['snippet'] + "</p><br/>" +
              '<a href = "' + link + '"> More Info </a>');
            ancientMarker[i].addTo(ancientLayer).bindPopup(popupContent);
          };

        }

        var map = L.map('pleiadesmap');
        map.setView([45.5, 34.5], 6);

        var LeafIcon = L.Icon.extend({
          options: {
            iconSize: [14, 14],
            iconAnchor: [7, 7],
            popupAnchor: [-3, -76]
          }
        });
        var marker = new LeafIcon({
          iconUrl: '../assets/images/map-marker.png'
        });


        var baseMap = L.tileLayer('http://{s}.tiles.mapbox.com/v3/isawnyu.map-knmctlkh/{z}/{x}/{y}.png', {
          subdomains: 'abcd'
        }).addTo(map);

        var coastOutline = L.tileLayer('http://{s}.tiles.mapbox.com/v3/isawnyu.eoupu8fr/{z}/{x}/{y}.png', {
          subdomains: 'abcd'
        });
        var road = L.tileLayer('http://{s}.tiles.mapbox.com/v3/isawnyu.awmc-roads/{z}/{x}/{y}.png', {
          subdomains: 'abcd'
        });
        var benthosWater = L.tileLayer('http://{s}.tiles.mapbox.com/v3/isawnyu.s5l5l8fr/{z}/{x}/{y}.png', {
          subdomains: 'abcd'
        });
        var inlandWater = L.tileLayer('http://{s}.tiles.mapbox.com/v3/isawnyu.awmc-inland-water/{z}/{x}/{y}.png', {
          subdomains: 'abcd'
        });
        var riverPolygons = L.tileLayer('http://{s}.tiles.mapbox.com/v3/isawnyu.9e3lerk9/{z}/{x}/{y}.png', {
          subdomains: 'abcd'
        });
        var waterCourseCenterLines = L.tileLayer('http://{s}.tiles.mapbox.com/v3/isawnyu.awmc-water-courses/{z}/{x}/{y}.png', {
          subdomains: 'abcd'
        });
        var baseOpenWaterPolygons = L.tileLayer('http://{s}.tiles.mapbox.com/v3/isawnyu.h0rdaemi/{z}/{x}/{y}.png', {
          subdomains: 'abcd'
        });
        var archaicWater = L.tileLayer('http://{s}.tiles.mapbox.com/v3/isawnyu.yyuba9k9/{z}/{x}/{y}.png', {
          subdomains: 'abcd'
        });
        var classicalWater = L.tileLayer('http://{s}.tiles.mapbox.com/v3/isawnyu.l5xc4n29/{z}/{x}/{y}.png', {
          subdomains: 'abcd'
        });
        var hellenisticWater = L.tileLayer('http://{s}.tiles.mapbox.com/v3/isawnyu.gq0ssjor/{z}/{x}/{y}.png', {
          subdomains: 'abcd'
        });
        var romanWater = L.tileLayer('http://{s}.tiles.mapbox.com/v3/isawnyu.ymnrvn29/{z}/{x}/{y}.png', {
          subdomains: 'abcd'
        });
        var lateAntiquityWater = L.tileLayer('http://{s}.tiles.mapbox.com/v3/isawnyu.t12it3xr/{z}/{x}/{y}.png', {
          subdomains: 'abcd'
        });

        var ancientLayer = new L.layerGroup().addTo(map);
        var ancientMarker = new Array;



        var baseLayers = {
          "Base Map": baseMap,
          "Coast Outline": coastOutline,
        };

        var groupedOverlays = {
          "Map Detail": {
            "Inland Water": inlandWater,
            "River Polygons": riverPolygons,
            "Water Course Center Lines": waterCourseCenterLines,
            "Base Open Water Polygons": baseOpenWaterPolygons,
            "Road": road,
            // "Archaic Water": archaicWater,
            // "Classical Water": classicalWater,
            // "Hellenistic Water": hellenisticWater,
            // "Roman Water": romanWater,
            // "Late Antiquity Water": lateAntiquityWater,
            // "Benthos Water": benthosWater,
          },
          "Markers": {
            "Ancient Sites": ancientLayer
          }
        };


        var layerControl = L.control.groupedLayers(baseLayers, groupedOverlays);
        map.addControl(layerControl);

      }
    });
});