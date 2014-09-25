require 'spec_helper'

describe RescueTimeDp do
  describe 'serializer' do
    let (:act1) {
      Activity.create names: ['gmail_com'], productivity: 0
    }

    let (:act2) {
      Activity.create names: ['anki'], productivity: 2
    }

    let (:rtdp) {
      rtdp = RescueTimeDp.new
      rtdp.rt_date = "2014-09-16"
      rtdp.time = DateTime.new(2014, 9, 16, 10)
      rtdp.acts = [
        {a: act1.id, duration: 300},
        {a: act2.id, duration: 150},
      ]
      rtdp.save
      rtdp.reload
    }

    it 'converts activities properly' do
      serializer = RescueTimeDpSerializer.new rtdp
      json = serializer.as_json['rescue_time_dp']
      expect(json).to have_key :activities
      expect(json[:activities]).to be_a Hash
      expect(json[:activities]['gmail_com'][:duration]).to eq 300
      expect(json[:activities]['gmail_com'][:productivity]).to eq 0
      expect(json[:activities]['anki'][:duration]).to eq 150
      expect(json[:activities]['anki'][:productivity]).to eq 2
    end

  end
  describe 'migration' do
    it 'works' do
      binding.pry
      cutoff = DateTime.new(2014, 9, 1)
      rtdps =  RescueTimeDp.where(:time.gte => cutoff, :acts2.exists => false)
      rtdps.map do |rtdp|
        expect(rtdps.acts2).to eq rtdp.acts
      end
    end
  end
end
