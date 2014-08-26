require 'spec_helper'

describe TwilioMessage do
  describe ".from_sms" do
    it 'returns a new dp with properties set' do
      dp = TwilioMessage.from_sms "5 6 7 - felt pretty good"
      expect(dp.details[:energy]).to eq 5
      expect(dp.details[:focus]).to eq 6
      expect(dp.details[:happiness]).to eq 7
      expect(dp.details[:comment]).to eq "felt pretty good"
      expect(dp).not_to be_persisted
    end
    it 'works when the body has no comment' do
      dp = TwilioMessage.from_sms "1 2 3"
      expect(dp.details[:energy]).to eq 1
      expect(dp.details[:focus]).to eq 2
      expect(dp.details[:happiness]).to eq 3
      expect(dp.details).not_to have_key :commment
    end

    it 'works when substituting out elements' do
      dp = TwilioMessage.from_sms ". 2 3"
      expect(dp.details[:energy]).to be_nil
      expect(dp.details[:focus]).to eq 2
      expect(dp.details[:happiness]).to eq 3

      dp = TwilioMessage.from_sms "1 . 3"
      expect(dp.details[:energy]).to eq 1
      expect(dp.details[:focus]).to be_nil
      expect(dp.details[:happiness]).to eq 3

      dp = TwilioMessage.from_sms "1 2 ."
      expect(dp.details[:energy]).to eq 1
      expect(dp.details[:focus]).to eq 2
      expect(dp.details[:happiness]).to be_nil

      expect(dp.details).not_to have_key :commment
    end
  end
end
