Dir[Rails.root.join("lib/util/**/*.rb")].each {|f| require f}

FactoryGirl.define do
  factory :user do |user|
    email "sherwinxyu@gmail.com"
    password "password"
    password_confirmation "password"
  end
end
