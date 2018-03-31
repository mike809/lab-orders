describe User do
  describe '.from_omniauth' do
    let(:auth) do
      OpenStruct.new(
        info: OpenStruct.new(email: email),
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
