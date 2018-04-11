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
    window.location.href = url;
  });

  if(window.location.href.match(/orders\/\d+\/?$/)) {
    window.print();
    // TODO: redirect to edit page after that (Find a way to go to back)
  }

  new QuaggaHandler();
});