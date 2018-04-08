class QuaggaHandler {
  constructor() {
    this.initializeCodesCount();
    this.loadQuagga();
  }

  initializeCodesCount() {
    const handler = {
      get(target, name) {
        if(name == 'length') { return this.size || 0 }
        return Object.prototype.hasOwnProperty.call(target, name) ? target[name] : 0;
      },
      set(target, name, value) {
        if(this.size === undefined) {
          this.size = 1;
        } else {
          this.size += 1;
        }
        target[name] = value;
        return true;
      }
    };
    this.codesCount = new Proxy({}, handler);
  }

  getHighestOcurrenceCode(codesCount) {
    return Object.keys(codesCount).reduce(function (a, b) {
      return (codesCount[a] > codesCount[b]) ? a : b;
    });
  }

  handleBarcode(result) {
    const lastCode = result.codeResult.code;
    this.codesCount[lastCode] += 1;

    if (this.codesCount.length > 20) {
      const code = this.getHighestOcurrenceCode(this.codesCount);
      this.initializeCodesCount();

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