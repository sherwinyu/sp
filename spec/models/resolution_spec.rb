require 'spec_helper'

describe Resolution do
  before (:each) do
    setup
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

  describe "serializer" do
    it "includes dates" do

    end
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
    pending 'works agnostically of timezons'
  end

  describe '#add_completion' do
    let (:completion_params) do
      {
        ts: '2014-05-06T08:09:33.000Z',
        day: '2015-03-10',
        comment: 'This is a comment',
      }
    end

    describe 'when valid' do
      it 'adds the completion to the completions list' do
        result = resolution.add_completion(completion_params)
        expect(result).to eq ts: Time.zone.parse(completion_params[:ts]), comment: 'This is a comment'
        expect(resolution.errors).to have(0).elements
        expect(resolution.completions).to have(1).element
        expect(resolution.completions[0]).to eq({
          ts: Time.zone.parse('2014-05-06T08:09:33.000Z'),
          comment: 'This is a comment',
        })
      end
      pending 'adds includes the day_id when day is found'
      pending 'sorts the completions by ts'
    end

    describe 'when invalid' do
      it 'returns nil' do
        invalid_params = completion_params.merge ts: nil
        result = resolution.add_completion(invalid_params)
        expect(result).to eq nil
        expect(resolution.errors).to have(1).element
        expect(resolution.completions).to have(0).elements
      end
    end
  end
end
