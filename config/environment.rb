# Load the rails application
require File.expand_path('../application', __FILE__)

def rTR
  RescueTimeRaw
end

def rTDP
  RescueTimeDp
end

# Initialize the rails application
Sysys::Application.initialize!

Dir["#{::Rails.root}/app/importers/*.rb"].each do |filename|
  require filename
end
