//= require jquery3
//= require popper
//= require rails-ujs
//= require turbolinks
//= require jquery
//= require jquery_ujs
//= require smart_listing
//= require bootstrap-sprockets
//= require_tree .

import QuaggaHandler from 'quagga_handler'

$(document).on('turbolinks:load', () => {
  new QuaggaHandler();
});
