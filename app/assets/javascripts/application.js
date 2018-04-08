//= require jquery3
//= require popper
//= require rails-ujs
//= require bootstrap-sprockets
//= require turbolinks
//= require quagga.min
//= require quagga_handler
//= require_tree .

$(document).on('turbolinks:load', () => {
  $('tr[data-href]').click((event) => {
    var url = $(event.currentTarget).data('href');
    window.open(url, '_blank');
  });

  new QuaggaHandler();
});