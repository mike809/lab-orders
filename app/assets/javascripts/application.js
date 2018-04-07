//= require jquery3
//= require popper
//= require rails-ujs
//= require bootstrap-sprockets
//= require quagga.min
//= require quagga_handler
//= require_tree .

$(document).ready(function(){
  $('tr[data-href]').click(function(){
    var url = $(this).data('href');
    window.open(url, '_blank');
  });
});

$(document).ready(() => { new QuaggaHandler(); });