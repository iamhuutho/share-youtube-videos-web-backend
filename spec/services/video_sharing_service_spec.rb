require 'rails_helper'

RSpec.describe VideoSharingService do
  describe '#extract_video_id' do
    let(:url) { 'https://www.youtube.com/watch?v=VIDEO_ID' }
    subject { described_class.new(url) }

    context 'when the video URL is valid' do
      it 'extracts the video ID' do
        expect(subject.extract_video_id).to eq('VIDEO_ID')
      end
    end

    context 'when the video URL is invalid' do
      let(:url) { 'invalid_url' }

      it 'returns nil' do
        expect(subject.extract_video_id).to be_nil
      end
    end

    context 'when the video URL is nil' do
      let(:url) { nil }

      it 'returns nil' do
        expect(subject.extract_video_id).to be_nil
      end
    end

    context 'when the video URL is empty' do
      let(:url) { '' }

      it 'returns nil' do
        expect(subject.extract_video_id).to be_nil
      end
    end

    context 'when the video URL is already present in the database' do
      before do
        allow(Video).to receive(:find_by).with(url: url).and_return(double('Video'))
      end

      it 'returns nil' do
        expect(subject.extract_video_id).to be_nil
      end
    end
  end
end
