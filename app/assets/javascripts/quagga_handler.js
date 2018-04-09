'use strict';

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var QuaggaHandler = function () {
  function QuaggaHandler() {
    _classCallCheck(this, QuaggaHandler);

    this.initializeCodesCount();
    this.loadQuagga();
  }

  _createClass(QuaggaHandler, [{
    key: 'initializeCodesCount',
    value: function initializeCodesCount() {
      var handler = {
        get: function get(target, name) {
          if (name == 'length') {
            return this.size || 0;
          }
          return Object.prototype.hasOwnProperty.call(target, name) ? target[name] : 0;
        },
        set: function set(target, name, value) {
          if (this.size === undefined) {
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
  }, {
    key: 'getHighestOcurrenceCode',
    value: function getHighestOcurrenceCode(codesCount) {
      return Object.keys(codesCount).reduce(function (a, b) {
        return codesCount[a] > codesCount[b] ? a : b;
      });
    }
  }, {
    key: 'handleBarcode',
    value: function handleBarcode(result) {
      var lastCode = result.codeResult.code;
      this.codesCount[lastCode] += 1;

      if (this.codesCount.length > 20) {
        var code = this.getHighestOcurrenceCode(this.codesCount);
        this.initializeCodesCount();

        Quagga.stop();

        $.ajax({
          type: 'PUT',
          url: '/orders/' + code
        });
      }
    }
  }, {
    key: 'haveAccessToUserMedia',
    value: function haveAccessToUserMedia() {
      return navigator.mediaDevices && typeof navigator.mediaDevices.getUserMedia === 'function';
    }
  }, {
    key: 'bindToModal',
    value: function bindToModal() {
      var _this = this;

      $('#barcode-scanner-modal').on('show.bs.modal', function () {
        if (Quagga.initialized == undefined) {
          Quagga.onDetected(_this.handleBarcode.bind(_this));
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
        }, function (err) {
          if (err) {
            console.log(err);
            return;
          }
          Quagga.initialized = true;
          Quagga.start();
        });
      });

      $('#barcode-scanner-modal').on('hide.bs.modal', function () {
        Quagga.stop();
      });
    }
  }, {
    key: 'loadQuagga',
    value: function loadQuagga() {
      if ($('#barcode-scanner-modal').length && this.haveAccessToUserMedia()) {
        this.bindToModal();
      }
    }
  }]);

  return QuaggaHandler;
}();
