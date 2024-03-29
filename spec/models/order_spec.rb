require 'rails_helper'

RSpec.describe Order, type: :model do
  subject { FactoryBot.create(:order) }

  describe '.validations' do
    let(:teacher) { FactoryBot.create(:teacher) }
    let(:student) { FactoryBot.create(:student) }
    let(:patient) { FactoryBot.create(:patient) }

    let(:params) do
      {
        teacher: teacher,
        student: student,
        patient: patient
      }
    end

    subject { described_class.new(params) }

    context 'when the student doesnt have the student role' do
      let(:student) { FactoryBot.create(:teacher) }
      it 'is invalid' do
        expect(subject).not_to be_valid
      end
    end

    context 'when the teacher doesnt have the teacher role' do
      let(:teacher) { FactoryBot.create(:student) }
      it 'is invalid' do
        expect(subject).not_to be_valid
      end
    end

    context 'when the patient doesnt have the patient role' do
      let(:patient) { FactoryBot.create(:teacher) }
      it 'is invalid' do
        expect(subject).not_to be_valid
      end
    end
  end

  describe '#transition!' do
    context 'when we transition an order' do
      before do
        subject.transition!
      end

      it 'sends an email' do
        expect(email_count).to eq(1)
      end

      it 'has the correct subject content' do
        expect(last_email.subject).to eq('Orden de protesis recibida.')
        expect(last_email.body).to include('Nombre del paciente:')
      end
    end
  end

  describe '#barcode' do
    let(:barcoder) { instance_double('Barcoder') }

    before do
      allow(Barcoder).to receive(:new).and_return(barcoder)
    end

    it 'calls to_html on a barcoder' do
      expect(barcoder).to receive(:to_html)
      subject.barcode
    end
  end
end
