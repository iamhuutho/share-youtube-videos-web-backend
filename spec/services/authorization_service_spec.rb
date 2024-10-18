require 'rails_helper'

RSpec.describe AuthorizationService do
  describe '#authorize_user' do
    let(:session) { double('Session', expires_at: Time.now + 1.hour) }
    subject { described_class.new(session) }

    context 'when the session is valid' do
      it 'returns true' do
        expect(subject.authorize_user).to be_truthy
      end
    end

    context 'when the session is expired' do
      before { allow(session).to receive(:expires_at).and_return(Time.now - 1.hour) }

      it 'raises an AuthorizationError' do
        expect { subject.authorize_user }.to raise_error(AuthorizationError)
      end
    end
  end
end