include Warden::Test::Helpers

module FeatureHelpers
  def login
    user = FactoryGirl.create :user
    login_as user, scope: :user
    return user
  end

  # Saves page to place specfied at name inside of
  # test.rb definition of:
  #   config.integration_test_render_dir = Rails.root.join("spec", "render")
  # NOTE: you must pass "js:" for the scenario definition (or else you'll see that render doesn't exist!)
  def render_page(name="out")
    png_name = name.strip.gsub(/\W+/, '-')
    path = File.join(Rails::root, "#{png_name}.png")
    puts "Saving image to to #{path}"
    page.driver.render(path)
  end

  # shortcut for typing save_and_open_page
  def page!
    save_and_open_page
  end

  # console.log
  def clog script
    page.evaluate_script "console.log(#{script})"
  end

  # evaluate
  def ev script
    page.evaluate_script script
  end

  # does a console.log and then returns the value
  def peek script
    ret = ev "poltergeist_return_val = #{script}"
    clog "poltergeist_return_val"
    ev "poltergeist_return_val = 'DONTUSEME'"
    ret
  end

  def jsn script
    ev "JSON.stringify(#{script})"
  end
end

RSpec.configure do |c|
  c.include FeatureHelpers
end
