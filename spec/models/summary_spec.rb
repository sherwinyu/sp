require 'spec_helper'

describe Summary do
  describe '#_resolutions_via_completions' do
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
