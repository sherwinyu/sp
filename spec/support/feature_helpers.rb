include Warden::Test::Helpers

module FeatureHelpers
  def login
    user = FactoryGirl.create :user
    login_as user, scope: :user
    return user
  end
end

RSpec.configure do |c|
  c.include FeatureHelpers
end
