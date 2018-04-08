require 'spec_helper'

describe UniqueUsernameGenerator do
  let(:user) do
    FactoryBot.build(:user, full_name: 'Jose Feliciano', username: nil)
  end

  subject { described_class.for_user(user) }

  describe '.for_user' do
    context 'when the username from the fullname is not taken' do
      it 'uses full name joined with a dot as usernmae' do
        expect(subject).to eq 'jose.feliciano'
      end
    end

    context 'when the username is taken' do
      let!(:taken_useraname) do
        FactoryBot.create(:user, username: 'jose.feliciano')
      end

      it 'generates generates a sequenced new one until not taken' do
        expect(subject).to eq 'jose.feliciano_2'
      end
    end
  end
end