# From: https://gist.github.com/mattwynne/1228927
#
# usage:
# it "returns a result of 5" do
#   eventually { expect(long_running_thing.result).to eq(5) }
# end
module AsyncHelper
  def eventually(options = {})
    timeout = options[:timeout] || 2
    interval = options[:interval] || 0.05
    time_limit = Time.now + timeout
    loop do
      begin
        yield
      rescue => error
      end
      return if error.nil?
      raise error if Time.now >= time_limit
      sleep interval
    end
  end
end

RSpec.configure do |c|
  c.include AsyncHelper
end

