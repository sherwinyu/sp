source 'https://rubygems.org'
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.1'

# Use postgresql as the database for Active Record
gem 'pg'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'figaro', github: 'laserlemon/figaro'
gem 'rollbar'

# Gems used only for assets and not required
# in production environments by default.

gem 'sass-rails', '~> 4.0'
gem 'compass-rails'
gem 'coffee-rails', '~> 4.0.0'
gem 'coffee-script-source', '1.6.1'
gem 'uglifier'
gem 'font-awesome-rails'


group :production, :staging do
  gem 'rails_12factor'
  gem 'unicorn'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass', '~> 3.0.3.0'
gem 'ember-source', '~> 1.2'
gem 'ember-data-source'
gem 'ember-bootstrap-rails'
gem 'ember-rails'
gem 'emblem-rails', github: "alexspeller/emblem-rails"
gem 'react-rails', '~> 1.0.0.pre', github: 'reactjs/react-rails'

gem 'momentjs-rails', '2.0.0.2'

gem 'pry'
gem 'spring', '0.9.0'

group :development, :test do
  gem 'rspec-rails', '2.14'
  gem 'annotate', "2.5.0"

  gem 'rb-inotify', require: false

  gem 'factory_girl_rails', '4.2.1'
  gem 'guard-jasmine', '1.15.1'
  gem 'jasmine-sinon-rails', '1.3.4'
  gem 'sinon-rails', '1.4.2.1'
  gem 'guard-rspec', '~> 4.0'
end

gem "spring-commands-rspec", group: :development, require: false


group :development do
  gem 'pry-debugger'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'guard-livereload', '2.1.2'
end

group :test do
  gem 'database_cleaner', '0.9.1'
  gem 'capybara', '2.1.0'
  gem 'poltergeist', '~> 1.5.0'
  gem 'shoulda-matchers'
  gem 'bourne', '1.4.0'
end

gem 'twilio-ruby'

gem "active_model_serializers", :github => "rails-api/active_model_serializers"
gem "mongoid", git: 'https://github.com/mongoid/mongoid.git'

gem "mongoid_auto_increment"
gem 'rest-client', '1.6.7'
gem "mixpanel"
gem 'hashie'
gem 'awesome_print'
gem 'rack-mini-profiler'
gem 'devise'

gem 'bson'
gem 'moped'

gem 'mongoid_rails_migrations'
