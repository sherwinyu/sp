class GoalSerializer < ActiveModel::Serializer
  attributes *%w[
    goal
    completed_at
  ]
end
