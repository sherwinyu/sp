Dir[Rails.root.join("lib/util/**/*.rb")].each {|f| require f}

FactoryGirl.define do
  factory :act do |user|
    at { Date.new(2014, 1, 2) + 3.hours }
    ended_at { at + 1.hour }
    desc "hello world"
  end
end
