This is a documentation for the map app in iospe website.
—————————————————

Files Location:

javascript: iospe/kiln/webapps/ROOT/assets/scripts/map.js
map marker: iospe/kiln/webapps/ROOT/assets/images/map-marker.png
data: iospe/kiln/webapps/ROOT/assets/scripts/blacksea.json

—————————————————

.JS File Explanation:

map.setView([45.5, 34.5], 6);  (Line 28) 
change ‘[45.5, 34.5]’ to move the start point of the map.
change ‘6’ to set different zoom level.

var baseMap… (line 40-79)
map tiles (available via http://awmc.unc.edu/wordpress/tiles/map-tile-information) is loaded into the map in this section.

var baseLayers… (line 86-108)
add or remove layers in the layer control.
baseLayers will be added as radio option, groupedOverlays will be added as check box.

$.ajax… (line 6-12)
data (a .json file) is loaded in this section. If the data file has been replaced, make sure to update the url in this section.

var LeafIcon… (line 30-37)
the marker file is loaded and altered in this section. If the marker file has been replaced, make sure to update the url.
