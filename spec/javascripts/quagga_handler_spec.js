// require quagga_handler

describe('Quagga Handler', () => {
  let quagga_handler;

  beforeEach(() => {
    quagga_handler = new QuaggaHandler();
  })

  describe('Getting the highest occurence code', () => {
    const codesCountMap = {
      '1': 10,
      '2': 9,
      '3':8
    }

    it('returns the code with the highest number of ocurrences', () => {
      expect(quagga_handler.getHighestOcurrenceCode(codesCountMap)).toBe('1');
    });
  });

  describe('Initializing the handler', () => {
    beforeEach(() => {
      quagga_handler.codesCount['2'] += 1;
      quagga_handler.codesCount['2'] += 1;
    });

    it('initializes the codes count hash with default to 0', () => {
      expect(quagga_handler.codesCount['1']).toBe(0);
      expect(quagga_handler.codesCount['2']).toBe(2);
    });

    it('counts every insertion towards its length property', () => {
      expect(quagga_handler.codesCount.length).toBe(2);
      expect(Object.keys(quagga_handler.codesCount).length).toBe(1);
    });
  });

  describe('Handling the codes after scanned', () => {
    const result = {
      codeResult: {
        code: '1'
      }
    };

    it('adds the code to the codes count hash map', () => {
      expect(quagga_handler.codesCount.length).toBe(0);
      quagga_handler.handleBarcode(result);
      expect(quagga_handler.codesCount.length).toBe(1);
    });

    describe('When the code count reaches 20', () => {
      const highestOcurrenceCode = 'CoDe'

      beforeEach(() => {
        quagga_handler.codesCount['2'] += 1;

        for (var i = 0; i < 19; i++){
          quagga_handler.codesCount[highestOcurrenceCode] += 1;
        }

        spyOn(Quagga, 'stop');
        spyOn($, 'ajax');
        quagga_handler.handleBarcode(result);
      })

      it('stops quagga', () => {
        expect(Quagga.stop.calls.count()).toBe(1);
      });

      it('makes a request to the server on the highest ocurrent code', () => {
        expect($.ajax.calls.mostRecent().args[0]["url"]).toBe(`/orders/${highestOcurrenceCode}`);
      });
    });
  });
});