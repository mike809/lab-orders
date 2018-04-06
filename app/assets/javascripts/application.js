//= require jquery3
//= require popper
//= require rails-ujs
//= require bootstrap-sprockets
//= require quagga.min
//= require_tree .

$(document).ready(function(){
  $('tr[data-href]').click(function(){
    var url = $(this).data('href');
    window.open(url, '_blank');
  });
});

class QuaggaHandler {

  constructor() {
    this.resultCount = 0;
    this.initializeCodesCount();
    this.loadQuagga();
  }

  initializeCodesCount() {
    let handler = {
      get: function (target, name) {
        if(!target.hasOwnProperty(name)) target[name] = 0
        return target[name];
      }
    };
    this.codesCount = new Proxy({}, handler);
  }

  getHighestOcurrenceCode() {
    return Object.keys(this.codesCount).reduce(
      (a, b) =>
      this.codesCount[a] > this.codesCount[b] ? a : b
    );
  }

  handleBarcode(result) {
    var lastCode = result.codeResult.code;
    this.codesCount[lastCode]++;
    this.resultCount++;
   
    if (this.resultCount > 20) {
      let code = this.getHighestOcurrenceCode();
      this.initializeCodesCount();
      this.resultCount = 0;

      Quagga.stop();
      
      $.ajax({
        type: "POST",
        url: '/order/' + code,
        data: { }
      });
    }
  }

  loadQuagga() {
    if ($('#barcode-scanner').length > 0 && navigator.mediaDevices && typeof navigator.mediaDevices.getUserMedia === 'function') {
      if (Quagga.initialized == undefined) {
        Quagga.onDetected(this.handleBarcode.bind(this));
      }

      Quagga.init({
        inputStream: {
          name: "Live",
          type: "LiveStream",
          numOfWorkers: navigator.hardwareConcurrency,
          target: document.querySelector('#barcode-scanner')
        },
        decoder: {
          readers: ['code_39_reader']
        }
      }, function (err) {
        if (err) {
          console.log(err);
          return;
        }
        Quagga.initialized = true;
        Quagga.start();
      });

    }
  };
}

$(document).ready(() => {  new QuaggaHandler() });