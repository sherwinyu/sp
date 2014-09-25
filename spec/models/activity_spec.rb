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
  describe '.upsert_activity_from_rtr' do


    it 'returns a list of Activities' do
      activities = Activity.upsert_activities_from_rtrs rtrs
      expect(activities.first).to be_an Activity
      expect(activities.second).to be_an Activity

      expect(activities.first.name).to eq mon5p_video.rt_activity
      expect(activities.first.productivity).to eq mon5p_video.rt_productivity
      expect(activities.first.category).to eq mon5p_video.category

      expect(activities.second.name).to eq mon5p_coding.rt_activity
      expect(activities.second.productivity).to eq mon5p_coding.rt_productivity
      expect(activities.second.category).to eq mon5p_coding.category
    end

    it 'creates Activities for activities that don\'t exist yet' do
      # Non-existent activity1 and activity2
      activity1 = Activity.where(name: mon5p_video.rt_activity).first
      activity2 = Activity.where(name: mon5p_coding.rt_activity).first
      expect(activity1).to be_nil
      expect(activity2).to be_nil

      Activity.upsert_activities_from_rtrs rtrs

      activity1 = Activity.where(name: mon5p_video.rt_activity).first
      activity2 = Activity.where(name: mon5p_video.rt_activity).first
      expect(activity1).to be_persisted
      expect(activity2).to be_persisted
    end

    it 'does not create duplicate Activities for preexistiing activities' do
      activity1 = Activity.create name: mon5p_video.rt_activity, productivity: 1000
      activity2 = Activity.create name: mon5p_coding.rt_activity, productivity: 2000

      expect{
        Activity.upsert_activities_from_rtrs rtrs
      }.to change{Activity.count}.by 0
      expect(Activity.where(name: mon5p_video.rt_activity).count).to be 1
      expect(Activity.where(name: mon5p_coding.rt_activity).count).to be 1
    end

    it 'does not not overwrite existing data on existing activites' do
      activity1 = Activity.create name: mon5p_video.rt_activity, productivity: 1000, category: 'cat1'
      activity2 = Activity.create name: mon5p_video.rt_activity, productivity: 2000, category: 'cat2'

      Activity.upsert_activities_from_rtrs rtrs

      expect(activity1.reload.productivity).to eq 1000
      expect(activity1.reload.category).to eq 'cat1'

      expect(activity2.reload.productivity).to eq 2000
      expect(activity2.reload.category).to eq 'cat2'
    end
  end
end
