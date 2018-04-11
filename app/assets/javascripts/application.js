//= require jquery3
//= require popper
//= require rails-ujs
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .

import QuaggaHandler from 'quagga_handler'

$(document).on('turbolinks:load', () => {
  $('tr[data-href]').click((event) => {
    var url = $(event.currentTarget).data('href');
    window.open(url, '_blank');
  });

  new QuaggaHandler();
});