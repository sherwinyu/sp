# This file was created by sherwin.

module SetupHelper
  def setup
    Option.stub(:next_ping_time).and_return 1.hour.from_now
    Option.stub(:current_timezone).and_return "America/Los_Angeles"
  end
end

# By including it in c.include, we can directly call `setup` anywhere in rspec as a local / global
# method. See `eventually` in async_helper and dashboard_spec
RSpec.configure do |c|
  c.include SetupHelper
end
