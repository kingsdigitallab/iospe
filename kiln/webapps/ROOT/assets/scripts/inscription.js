// Inscriptions specific functions

require(['common'], function(common) {
  require(['jquery', 'app/main', 'highlightjs'],
    function ($, main, highlightjs) {

      $('pre code').each(function(i, e) {
        hljs.tabReplace = '    '; // 4 spaces
        //hljs.tabReplace = '<span class="indent">\t</span>';
        hljs.highlightBlock(e);
      });
  });
});