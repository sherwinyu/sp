# Source: https://github.com/justin808/react-webpack-rails-tutorial/blob/master/lib/tasks/assets.rake
# https://hackhands.com/fast-rich-client-rails-development-webpack-es6-transpiler/
# The webpack task must run before assets:environment task.
# Otherwise Sprockets cannot find the files that webpack produces.
Rake::Task['assets:precompile']
  .clear_prerequisites
  .enhance(['assets:compile_environment'])

namespace :assets do
  # In this task, set prerequisites for the assets:precompile task
  task :compile_environment => :webpack do
    Rake::Task['assets:environment'].invoke
  end

  desc 'Compile assets with webpack'
  task :webpack do
    # sh 'cd webpack && $(npm bin)/webpack --config webpack.rails.config.js'
    sh '$(npm bin)/webpack'
  end

  task :clobber do
    # rm_rf "#{RailsReactTutorial::Application.config.root}/app/assets/javascripts/rails-bundle.js"
    rm_rf "#{RailsReactTutorial::Application.config.root}/app/assets/javascripts/webpack-bundle.js"
  end
end
