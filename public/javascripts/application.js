(function() {
  var aside    = $('aside');
  var link     = $('aside .register a');
  var patience = $('.patience');

  patience.css('width', aside.css('width'));
  patience.css('top', link.position().top + 20);

  link.click(function() {
    if (patience.length > 0) {
      patience.toggleClass('wait');
      return false;
    }
  });
  
  if(!Modernizr.input.placeholder) {
    $("input").each(function() {
      if($(this).val() == "" && $(this).attr("placeholder") != "") {
        $(this).val($(this).attr("placeholder"));
        $(this).focus(function() {
          if ($(this).val() == $(this).attr("placeholder"))
            $(this).val("");
        });
        $(this).blur(function() {
          if($(this).val() == "")
            $(this).val($(this).attr("placeholder"));
        });
      }
    });
  }
})();
