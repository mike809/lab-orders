
import Quagga from 'quagga';

class QuaggaHandler {
  constructor() {
    this.initializeCodesCount();
    this.loadQuagga();
  }

  initializeCodesCount() {
    this.codesCount = {
      store: {},
      size: 0,

      increment(value) {
        this.store[value] = this.get(value) + 1;
        this.size += 1;
      },

      get(value) {
        return this.store[value] || 0;
      },

      getHighestOcurrenceCode() {
        const codes = this.store;
        return Object.keys(codes).reduce(function (a, b) {
          return (codes[a] > codes[b]) ? a : b;
        });
      }
    };
  }

  handleBarcode(_window, result) {
    const lastCode = result.codeResult.code;
    this.codesCount.increment(lastCode);

    if (this.codesCount.size > 20) {
      const code = this.codesCount.getHighestOcurrenceCode();
      this.initializeCodesCount();

      Quagga.stop();
      _window.location.href = `/orders/${code}/edit`
    }
  }

  haveAccessToUserMedia() {
    return navigator.mediaDevices && typeof navigator.mediaDevices.getUserMedia === 'function';
  }

  bindToModal() {
    $('#barcode-scanner-modal').on('show.bs.modal', () => {
      if (Quagga.initialized == undefined) {
        Quagga.onDetected(this.handleBarcode.bind(this, window));
      }

      Quagga.init({
        inputStream: {
          name: 'Live',
          type: 'LiveStream',
          numOfWorkers: navigator.hardwareConcurrency,
          target: document.querySelector('#barcode-scanner')
        },
        decoder: {
          readers: ['code_39_reader']
        }
      }, err => {
        if (err) {
          console.log(err);
          return;
        }
        Quagga.initialized = true;
        Quagga.start();
      });
    });

    $('#barcode-scanner-modal').on('hide.bs.modal', () => {
      Quagga.stop();
    });
  }

  loadQuagga() {
    if ($('#barcode-scanner-modal').length && this.haveAccessToUserMedia()) {
      this.bindToModal();
    }
  }
}

export default QuaggaHandler;