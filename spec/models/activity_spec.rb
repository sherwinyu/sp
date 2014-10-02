require 'spec_helper'

describe Activity do

  mon5p = "2013-10-07T17:00:00"
  mon6p = "2013-10-07T18:00:00"
  mon7p = "2013-10-07T19:00:00"
  tues6p = "2013-10-08T18:00:00"

  let(:rtrs) {
    [mon5p_video, mon5p_coding]
  }
  let(:mon5p_video) {create :rescue_time_raw, rt_date: mon5p, rt_activity: "video", rt_time_spent: 60}
  let(:mon5p_coding) {create :rescue_time_raw, rt_date: mon5p, rt_activity: "coding", rt_time_spent: 60}

  let (:mon6p_coding) {create :rescue_time_raw, rt_date: mon6p, rt_activity: "coding", rt_time_spent: 60}
  let (:mon7p_coding) {create :rescue_time_raw, rt_date: mon7p, rt_activity: "lumping", rt_time_spent: 60}

  let (:tues6p_coding) {create :rescue_time_raw, rt_date: tues6p, rt_activity: "coding", rt_time_spent: 60 }
  let (:tues6p_video) {create :rescue_time_raw, rt_date: tues6p, rt_activity: "video", rt_time_spent: 60}
  let (:rtr) do
    mon5p_video
  end

  describe '.upsert_activity_from_rtr' do
    it 'creates a new Activity for those that don\'t exist yet' do
      activity1 = Activity.where(name: mon5p_video.rt_activity).first
      expect(activity1).to be_nil

      expect{
        Activity.upsert_activity_from_rtr rtr
      }.to change{Activity.count}.by 1

      activity1 = Activity.where(name: mon5p_video.rt_activity).first
      expect(activity1).to be_persisted
    end
    it 'does not create duplicate Activities for preexisting activity' do
      activity1 = Activity.create name: mon5p_video.rt_activity, productivity: 1000

      expect{
        Activity.upsert_activity_from_rtr rtr
      }.to change{Activity.count}.by 0

      expect(Activity.where(name: mon5p_video.rt_activity).count).to be 1
    end

    it 'does not not overwrite existing data on existing activites' do
      activity1 = Activity.create name: mon5p_video.rt_activity, productivity: 1000, category: 'cat1'

      Activity.upsert_activity_from_rtr rtr

      expect(activity1.reload.productivity).to eq 1000
      expect(activity1.reload.category).to eq 'cat1'
    end
  end
end
