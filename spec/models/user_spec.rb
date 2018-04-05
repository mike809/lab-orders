describe User do
  describe 'validations' do
    let(:params) { {} }
    subject { FactoryBot.build(:user, params) }

    context 'when all the fields are present' do
      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when the username is missing' do
      let(:params) { { username: nil } }
      it 'is not valid' do
        expect(subject).not_to be_valid
      end
    end

    context 'when the email is missing' do
      let(:params) { { email: nil } }
      it 'is not valid' do
        expect(subject).not_to be_valid
      end
    end

    context 'when the full_name is missing' do
      let(:params) { { full_name: nil } }
      it 'is not valid' do
        expect(subject).not_to be_valid
      end
    end
  end

  describe '.from_omniauth' do
    let(:auth) do
      OpenStruct.new(
        info: OpenStruct.new(email: email, name: 'Jose Gomez'),
        provider: 'Azure',
        uid: '1234'
      )
    end

    subject { described_class.from_omniauth(auth) }

    context "when the user's email starts with a matricula" do
      let(:email) { '20100724@ce.pucmm.edu.do' }
      it 'sets the role to student' do
        expect(subject.role).to eq 'student'
      end
    end

    context "when the user's email doesn't start with a matricula" do
      let(:email) { 'jose.pena@ce.pucmm.edu.do' }
      it 'sets the role to teacher' do
        expect(subject.role).to eq 'teacher'
      end
    end
  end
end
