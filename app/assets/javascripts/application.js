// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require highcharts.src
//= require highcharts-3d
//= require chartkick
//= require_tree .

$(function() {
  $("#records th a, #records .pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
  $("#records_search input").keyup(function() {
    $.get($("#records_search").attr("action"), $("#records_search").serialize(), null, "script");
    return false;
  });
});