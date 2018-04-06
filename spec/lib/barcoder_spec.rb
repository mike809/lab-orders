require 'spec_helper'

describe Barcoder do
  subject { described_class.new(param) }

  describe 'initialize' do
    context 'when no params are passed' do
      it 'raises an exception' do
        expect { described_class.new }.to raise_error(ArgumentError)
      end
    end

    context 'when we pass raw_data' do
      let(:param) { 123456789012 }
      it 'initializes correctly' do
        expect { subject }.not_to raise_error
      end
    end
  end

  describe '#to_html' do
    let(:param) { 123456789012 }

    it 'returns a string without error' do
      expect(subject.to_html). to be_a String
    end
  end
end