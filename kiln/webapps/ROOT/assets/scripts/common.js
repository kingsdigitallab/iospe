//The build will inline common dependencies into this file.

//For any third party dependencies, like jQuery, place them in the lib folder.

//Configure loading modules from the lib directory,
//except for 'app' ones, which are in a sibling
//directory.
requirejs.config({
    // for debug purposes
    // urlArgs: "bust=" + (new Date()).getTime(),
    baseUrl: "/assets/scripts",
    paths: {
        "jquery": "vendor/jquery/dist/jquery.min",
        "jquery-ui": "vendor/jquery-ui/jquery-ui.min",
        "highlightjs": "vendor/highlightjs/highlight.pack",
        "URIjs": "vendor/URIjs/src",
        "app": "app",
        "leaflet": "vendor/leaflet/dist/leaflet",
        "leaflet-groupedlayercontrol": "vendor/leaflet-groupedlayercontrol/dist/leaflet.groupedlayercontrol.min"
    },
    shim: {
        "jquery": {
            exports: "$",
        },
        "jquery-ui": {
            exports: "$",
            deps: [
                'jquery'
            ]
        },
        "leaflet-groupedlayercontrol": {
            deps: ['leaflet']
        }
    }
});