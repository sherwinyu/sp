# This file was created by sherwin.

module SetupHelper
  def setup
    Option.current_timezone = "America/Los_Angeles"
  end
end

# By including it in c.include, we can directly call `setup` anywhere in rspec as a local / global
# method. See `eventually` in async_helper and dashboard_spec
RSpec.configure do |c|
  c.include SetupHelper
end
