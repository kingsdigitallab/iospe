//The build will inline common dependencies into this file.

//For any third party dependencies, like jQuery, place them in the lib folder.

//Configure loading modules from the lib directory,
//except for 'app' ones, which are in a sibling
//directory.
requirejs.config({
    baseUrl: "assets/scripts/",
    paths: {
        rainbow: "vendor/rainbow/js/rainbow"
    }
});

require(['app/main'],
  function (main) {
    //$('h3').css('color', '#00f');
});