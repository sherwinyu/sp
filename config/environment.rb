# Load the rails application
require File.expand_path('../application', __FILE__)

def rTR
  RescueTimeRaw
end

def rTDP
  RescueTimeDp
end

def reload_env!
    Dir["#{::Rails.root}/app/importers/*.rb"].each do |filename|
      if Rails.env.development? # if we're in console (development), load the file. otherwise, just require it
        load filename
      else
        require filename
      end
    end
end

# Initialize the rails application
Sysys::Application.initialize!

# Reload custom definitions
reload_env!
