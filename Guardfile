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
  cmd = "zeus rspec #{opts.delete :cmd}"
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


=begin
guard :jasmine, all_on_start: false, port: 8888, keep_failed: false do
  watch(%r{spec/javascripts/spec\.(js\.coffee|js|coffee)$}) { 'spec/javascripts' }
  watch(%r{spec/javascripts/.+_spec\.(js\.coffee|js|coffee)$})
  watch(%r{spec/javascripts/fixtures/.+$})
  watch(%r{app/assets/javascripts/(.+?)\.(js\.coffee|js|coffee)(?:\.\w+)*$}) { |m| "spec/javascripts/#{ m[1] }_spec.#{ m[2] }" }
end

group 'unit-tests' do
  guard :rspec, {
                    zeus: true,
                    bundler: false,
                    all_on_start: false,
                    cli: "--tag ~js"
                  } do

    # Editing a model/controller/importer spec directly runs it
    watch(%r{^spec/models/.+_spec\.rb$})
    watch(%r{^spec/controllers/.+_spec\.rb$})
    watch(%r{^spec/importers/.+_spec\.rb$})

    # Editing anything in lib reruns the lib spec
    watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }

    # All unit tests:
    watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }

    # Editing controllers and routes retrigger routing specs:
    watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
    watch('config/routes.rb')                           { "spec/routing" }

    # Editing application controller re runs controllers
    watch('app/controllers/application_controller.rb')  { "spec/controllers" }

    # Editing anything under support or spec_helper reruns everything
    watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
    watch('spec/spec_helper.rb')  { "spec" }
  end
end

group 'js-tests' do
  guard :rspec, {
                    zeus: true,
                    bundler: false,
                    all_on_start: false,
                    cli: "--tag js"
                 } do
    # Capybara features specs
    watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/features/#{m[1]}_spec.rb" }

    # Editing a feature spec directly runs it
    watch(%r{^spec/features/.+_spec\.rb$})
  end
end

notification :tmux,
  display_message: true,
  timeout: 2,
  line_separator: ' > ',
  color_location:  'status-left-bg'
=end
