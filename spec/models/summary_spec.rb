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

      ts1 = day.date.to_time.to_datetime + 7.hours
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
