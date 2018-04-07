class QuaggaHandler {
  constructor() {
    this.resultCount = 0;
    this.initializeCodesCount();
    this.loadQuagga();
  }

  initializeCodesCount() {
    const handler = {
      get(target, name) {
        return Object.prototype.hasOwnProperty.call(target, name) ? target[name] : 0;
      },
    };
    this.codesCount = new Proxy({}, handler);
  }

  getHighestOcurrenceCode() {
    return Object.keys(this.codesCount).reduce(function (a, b) {
      return (this.codesCount[a] > this.codesCount[b]) ? a : b;
    });
  }

  handleBarcode(result) {
    const lastCode = result.codeResult.code;
    this.codesCount[lastCode] += 1;
    this.resultCount += 1;

    if (this.resultCount > 20) {
      const code = this.getHighestOcurrenceCode();
      this.initializeCodesCount();
      this.resultCount = 0;

      Quagga.stop();

      $.ajax({
        type: 'GET',
        url: `/orders/${code}`
      });
    }
  }

  haveAccessToUserMedia() {
    return navigator.mediaDevices && typeof navigator.mediaDevices.getUserMedia === 'function';
  }

  bindToModal() {
    $('#barcode-scanner-modal').on('show.bs.modal', () => {
      if (Quagga.initialized == undefined) {
        Quagga.onDetected(this.handleBarcode.bind(this));
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