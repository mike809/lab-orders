import QuaggaHandler from '../../app/assets/javascripts/quagga_handler';
import Quagga from 'quagga';

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

    beforeEach(() => {
      quagga_handler.codesCount.store = codesCountMap;
    })

    it('returns the code with the highest number of ocurrences', () => {
      expect(quagga_handler.codesCount.getHighestOcurrenceCode()).toBe('1');
    });
  });

  describe('Initializing the handler', () => {
    beforeEach(() => {
      quagga_handler.codesCount.increment('2');
      quagga_handler.codesCount.increment('2');
    });

    it('initializes the codes count hash with default to 0', () => {
      expect(quagga_handler.codesCount.get('1')).toBe(0);
      expect(quagga_handler.codesCount.get('2')).toBe(2);
    });

    it('counts every insertion towards its length property', () => {
      expect(quagga_handler.codesCount.size).toBe(2);
      expect(Object.keys(quagga_handler.codesCount.store).length).toBe(1);
    });
  });

  describe('Handling the codes after scanned', () => {
    const result = {
      codeResult: {
        code: '1'
      }
    };

    let windowMock = {
      location: {
        href: ''
      }
    }

    it('adds the code to the codes count hash map', () => {
      expect(quagga_handler.codesCount.size).toBe(0);
      quagga_handler.handleBarcode(windowMock, result);
      expect(quagga_handler.codesCount.size).toBe(1);
    });

    describe('When the code count reaches 20', () => {
      const highestOcurrenceCode = 'CoDe';

      beforeEach(() => {
        quagga_handler.codesCount.increment('2');

        for (var i = 0; i < 19; i++){
          quagga_handler.codesCount.increment(highestOcurrenceCode);
        }

        spyOn(Quagga, 'stop');
        quagga_handler.handleBarcode(windowMock, result);
      })

      it('changes the window location href', () => {
        expect(windowMock.location.href).toBe('/orders/CoDe/edit')
      });

      it('stops quagga', () => {
        expect(Quagga.stop.calls.count()).toBe(1);
      })
    });
  });
});