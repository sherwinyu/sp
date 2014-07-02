# A sample Guardfile
# More info at https://github.com/guard/guard#readme

def watchers
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
end

def rspec_params opts={}
  cmd = "bundle exec spring rspec -f doc #{opts.delete :cmd}"
  {
    cmd: cmd,
    all_on_start: false,
  }.merge opts
end

# By default, run unit tests
group :default do
  guard :rspec, rspec_params(cmd: "--tag ~integration --tag ~slow") do
    watchers
  end
end

group :unit do
  guard :rspec, rspec_params(cmd: "--tag ~integration --tag ~slow --tag ~nonunit") do
    watchers
  end
end


group :integration do
  guard :rspec, rspec_params(cmd: "--tag integration") do
    watchers
  end
end

group :focus do
  guard :rspec, rspec_params(cmd: "--tag focus") do
    watchers
  end
end

group :everything do
  guard :rspec, rspec_params do
    watchers
  end
end

scope group: :default

guard 'livereload' do
  watch(%r{app/views/.+\.(erb|haml|slim)})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html))).*}) { |m| "/assets/#{m[3]}" }
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(emblem))).*})
end
