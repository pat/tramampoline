// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery-1.4.2.min
//= require modernizr-1.6.min

(function() {
  var aside    = $('#aside');
  var link     = $('#aside .register a');
  var patience = $('.patience');

  patience.css('width', aside.css('width'));

  if (link.length > 0) {
    patience.css('top', link.position().top + 20);
  }

  link.click(function() {
    if (patience.length > 0) {
      patience.toggleClass('wait');
      return false;
    }
  });

  patience.click(function() {
    patience.toggleClass('wait');
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

  $('form.paypal').submit();
})();
