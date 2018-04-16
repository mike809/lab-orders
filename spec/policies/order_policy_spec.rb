require 'rails_helper'

RSpec.describe OrderPolicy do
  let(:order) { FactoryBot.build(:order) }
  subject { described_class.new(user, order) }

  describe '.scope' do
    context 'as a student' do
      let(:user) { FactoryBot.create(:student) }
      let(:other_user) { FactoryBot.create(:student) }
      let!(:student_orders) { create_list(:order, 2, student: user) }
      let!(:other_orders) { create_list(:order, 2, student: other_user) }

      it 'contains the orders for that student' do
        expect(Pundit.policy_scope(user, Order)).to match_array student_orders
      end
    end

    context 'as an admin' do
      let(:user) { FactoryBot.create(:admin) }
      let!(:orders) { create_list(:order, 4) }

      it 'contains all the orders' do
        expect(Pundit.policy_scope(user, Order)).to match_array orders
      end
    end

    context 'as an teacher' do
      let(:user) { FactoryBot.create(:teacher) }
      let!(:teacher_orders) { create_list(:order, 4, teacher: user) }
      let!(:orders) { create_list(:order, 4) }

      it 'contains all the orders' do
        expect(Pundit.policy_scope(user, Order)).to match_array teacher_orders
      end
    end
  end

  context 'as a student' do
    let(:user) { FactoryBot.create(:student) }

    context '#create' do
      context 'when the student for the order is the user' do
        let(:order) { FactoryBot.build(:order, student: user) }
        it { is_expected.to authorize(:create) }
      end

      context 'when the student for the order is a different user' do
        let(:other_user) { FactoryBot.create(:student) }
        let(:order) { FactoryBot.build(:order, student: other_user) }
        it { is_expected.not_to authorize(:create) }
      end
    end

    it { is_expected.not_to authorize(:update) }

    it { is_expected.to authorize(:index) }
    it { is_expected.to authorize(:new) }
  end

  context 'as a teacher' do
    let(:user) { FactoryBot.create(:teacher) }

    it { is_expected.to authorize(:new) }
    it { is_expected.to authorize(:index) }
    it { is_expected.to authorize(:create) }

    it { is_expected.not_to authorize(:update) }
  end

  context 'as an admin' do
    let(:user) { FactoryBot.create(:administrator) }

    it { is_expected.to authorize(:new) }
    it { is_expected.to authorize(:index) }
    it { is_expected.to authorize(:create) }
    it { is_expected.to authorize(:update) }
  end
end
