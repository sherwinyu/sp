require 'spec_helper'

describe Summary do
  before :each do
    setup
  end
  let(:coded) do
    r = Resolution.create key: 'coded'
    r.reload
  end
  let(:coded_in_am) do
    r = Resolution.create key: 'coded_in_am'
    r.reload
  end
  let(:in_bed_by_1130) do
    r = Resolution.create key: 'in_bed_by_1130'
    r.reload
  end
  let(:mindfulness) do
    r = Resolution.create key: 'mindfulness'
    r.reload
  end
  let(:chns_sentence) do
    r = Resolution.create key: 'chns_sentence'
    r.reload
  end
  let (:resolutions) do
    [
      coded,
      coded_in_am,
      in_bed_by_1130,
      mindfulness,
      chns_sentence
    ]

  end


  describe '#_resolutions_via_completions' do
    it 'works' do
      resolutions
      day = Day.create date: '2015-03-02'
      day.summary = Summary.new

      day2 = day.tomorrow!
      day2.summary = Summary.new
      day2.save

      # Need to call .to_time to get ISO string
      ts1 = day.date.to_time + 7.hours
      completion = chns_sentence.add_completion ts: ts1.to_s, comment: 'hello'
      expect(completion).to be_present
      chns_sentence.save!
      expect(day.summary._resolutions_via_completions).to eq({
        coded: false,
        coded_in_am: false,
        mindfulness: false,
        in_bed_by_1130: false,
        chns_sentence: true
      })

      # Now add a date that isn't covered
      ts2 = day.date.to_time.to_datetime + 1.day + 7.hours

      completion = in_bed_by_1130.add_completion ts: ts2.to_s, comment: 'in bed'
      expect(completion).to be_present

      completion = coded_in_am.add_completion ts: ts2.to_s, comment: 'coded_in_am'
      expect(completion).to be_present

      completion = coded.add_completion ts: ts2.to_s, comment: 'coded'
      expect(completion).to be_present
      resolutions.each &:save!

      # Still expect day 1 to only have chns_sentence
      expect(day.summary._resolutions_via_completions).to eq({
        coded: false,
        coded_in_am: false,
        mindfulness: false,
        in_bed_by_1130: false,
        chns_sentence: true
      })

      # But expect day 2 to have in_bed_by_1130, coded_in_am, and coded
      expect(day2.summary._resolutions_via_completions).to eq({
        coded: true,
        coded_in_am: true,
        mindfulness: false,
        in_bed_by_1130: true,
        chns_sentence: false
      })


    end


  end

  let (:resolution_params) do
    {
      key: 'resolution-key',
      text: 'Work out every day',
      group: 'Fitness',
      frequency: 'weekly',
      type: 'goal',
      target_count: '3',
    }
  end

  # Note we have to reload, to get string keys instead of symbol keys in nested docs
  let (:resolution) do
    r = Resolution.create resolution_params
    r.reload
  end

  let (:workout_time) do
    DateTime.new(2015, 1, 1, 20, 30)
  end

  let (:completion_params1) do
    {
      ts: workout_time,
      comment: 'working out at 8:30 on 2015-1-1'
    }
  end

  let (:resolution_with_completions) do
    r = Resolution.create resolution_params.merge(
      completions: [completion_params1]
    )
    r.reload
  end

  describe '#completions_in_range' do
    it 'returns all the completions in the range' do
      range = ((workout_time + 1.second)..workout_time + 1.day)
      found_completions = resolution_with_completions.completions_in_range range
      expect(found_completions.length).to be 0

      range = ((workout_time - 1.minute)..workout_time + 1.day)
      found_completions = resolution_with_completions.completions_in_range range
      expect(found_completions.length).to eq 1
    end
    pending 'works agnostically of timezone'
  end
end
