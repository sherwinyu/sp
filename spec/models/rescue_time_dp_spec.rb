require 'spec_helper'

describe RescueTimeDp do
  mon5p = "2013-10-07T17:00:00"
  mon6p = "2013-10-07T18:00:00"
  mon7p = "2013-10-07T19:00:00"
  tues6p = "2013-10-08T18:00:00"

  let(:rtrs) {
    [mon5p_video, mon5p_coding, mon6p_coding, mon7p_coding, tues6p_coding, tues6p_video]
  }
  let(:mon5p_video) {create :rescue_time_raw, rt_date: mon5p, rt_activity: "video", rt_time_spent: 60}
  let(:mon5p_coding) {create :rescue_time_raw, rt_date: mon5p, rt_activity: "coding", rt_time_spent: 60}

  let (:mon6p_coding) {create :rescue_time_raw, rt_date: mon6p, rt_activity: "coding", rt_time_spent: 60}
  let (:mon7p_coding) {create :rescue_time_raw, rt_date: mon7p, rt_activity: "lumping", rt_time_spent: 60}

  let (:tues6p_coding) {create :rescue_time_raw, rt_date: tues6p, rt_activity: "coding", rt_time_spent: 60 }
  let (:tues6p_video) {create :rescue_time_raw, rt_date: tues6p, rt_activity: "video", rt_time_spent: 60}

  describe 'serializer' do
    let (:act1) {
      Activity.create name: 'gmail.com', productivity: 0
    }

    let (:act2) {
      Activity.create name: 'anki', productivity: 2
    }

    let (:rtdp) {
      rtdp = RescueTimeDp.new
      rtdp.rt_date = "2014-09-16"
      rtdp.time = DateTime.new(2014, 9, 16, 10)
      rtdp.acts = [
        {'a' => act1.id, duration: 300},
        {'a' => act2.id, duration: 150},
      ]
      rtdp.save
      rtdp.reload
    }

    it 'converts the acts array to the expected hash of hashes' do
      serializer = RescueTimeDpSerializer.new rtdp
      json = serializer.as_json['rescue_time_dp']
      expect(json).to have_key :activities
      expect(json[:activities]).to be_a Hash
      expect(json[:activities]['gmail.com'][:duration]).to eq 300
      expect(json[:activities]['gmail.com'][:productivity]).to eq 0
      expect(json[:activities]['anki'][:duration]).to eq 150
      expect(json[:activities]['anki'][:productivity]).to eq 2
    end
  end

  describe 'sync_against_raw' do
    it 'correctly sets the `acts` field of the rtdp #INTEGRATION' do
      activity1 = Activity.create name: mon5p_video.rt_activity, productivity: 1000, category: 'cat1'

      # Load these rtrs into memory
      mon5p_video
      mon5p_coding

      rtdp = RescueTimeDp.new rt_date: mon5p

      # Sync against raw
      expect { rtdp.sync_against_raw }.to change{ Activity.count }.by 1

      # It only creates one new Activity
      expect(Activity.count).to eq 2

      # It sets rtdp.acts to an array of {a, duration based on the RTRs}
      expect(rtdp.acts).to be_an Array
      activity1 = Activity.where(name: mon5p_video.rt_activity).first
      activity2 = Activity.where(name: mon5p_coding.rt_activity).first
      expect(rtdp.acts.first).to eq a: activity1.id, duration: 60
      expect(rtdp.acts.second).to eq a: activity2.id, duration: 60
    end
  end
end
