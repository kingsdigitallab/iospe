//The build will inline common dependencies into this file.

//For any third party dependencies, like jQuery, place them in the lib folder.

//Configure loading modules from the lib directory,
//except for 'app' ones, which are in a sibling
//directory.
requirejs.config({
    // for debug purposes
    urlArgs: "bust=" + (new Date()).getTime(),
    baseUrl: "/assets/scripts",
    paths: {
        "jquery": "vendor/jquery/dist/jquery",
        "jquery-ui": "vendor/jquery-ui/jquery-ui.min",
        "highlightjs": "vendor/highlightjs/highlight.pack",
        "purl": "vendor/purl/purl",
        "app": "app",
        "leaflet": "vendor/leaflet/dist/leaflet",
        "leaflet-groupedlayercontrol": "vendor/leaflet-groupedlayercontrol/dist/leaflet.groupedlayercontrol.min",

    },
    shim: {
        "jquery-ui": {
            exports: "$",
            deps: [
            'jquery'
            ]
        },
    }
});

