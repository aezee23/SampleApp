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
//= require jquery-ui
//= require bootstrap
//= require highcharts.src
//= require highcharts-3d
//= require highcharts/drilldown
//= require angular
//= require angular-ui-sortable
//= require list
//= require_tree .


$(function() {
  setTimeout(function(){
    $('div.alert').hide();
  }, 3000)

  $(".datepick").datepicker({
              changeMonth: true,
              changeYear: true,
              dateFormat: 'yy-mm-dd',
              altFormat: 'yy-mm-dd',
              minDate: '-1Y',
              maxDate: '0'
          });

  $(".datepicker").datepicker({
              changeMonth: true,
              changeYear: true,
              dateFormat: 'yy-mm-dd',
              altFormat: 'yy-mm-dd',
              maxDate: '0'
          });

  $('div.section_heading').off('click').on('click', function(){
    $(this).next('div').slideToggle();
  })
  $('div.section_heading.global').off('click');
  
  var options = {
    valueNames: [ 'name', 'pastor_name' ]
  };

  var userList = new List("members_list", options);

});
