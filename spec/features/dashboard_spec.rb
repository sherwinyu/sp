require "spec_helper"
require "support/features/dashboard_helpers"

feature "Dashboard", feature: "dashboard" do
  include Features::DashboardHelpers

  before(:each) do
    Option.current_timezone = "Asia/Shanghai"
    login
  end

  scenario "You can save the day", js: true do
    visit '#'
    expect(page).to have_text "Dashboard"

    fill_in_sleep
    fill_in_summary
    add_goals
    save_day

    # TODO(syu): get rid of this... or move it into its own helper method
    # This method mirrors the CLIENT-SIDE time parsing and adjustment
    # That's why we use Time.now (to mimic the browser time == system time)
    def normalize(datetime)
      # it's tuesday 2am and we parse tuesday 2:30am -> yes, tuesday 2am
      # it's tuesday 2am and we parse tuesday 8:30am -> no, monday 8am
      # it's tuesday 8am and we parse tuesday 8am -> yes, tuesday 8am
      # it's tuesday 8am and we parse tuesday 2am -> no, wednesday 2am
      browser_time = Time.now
      delta = if datetime.hour > 4 && browser_time.hour < 4
                -1
              elsif datetime.hour < 4 && browser_time.hour > 4
                1
              else
                0
              end
      datetime + delta
    end

    awake_at_dt = normalize Time.parse("8:30").to_datetime
    up_at_dt = normalize Time.parse("8:35").to_datetime
    computer_off_at_dt = normalize Time.parse("2:00").to_datetime
    lights_out_at_dt = normalize Time.parse("2:25").to_datetime

    eventually do
      day = Day.latest
      expect(day.sleep.awake_at).to eq awake_at_dt
      expect(day.sleep.up_at).to eq up_at_dt
      expect(day.sleep.computer_off_at).to eq computer_off_at_dt
      expect(day.sleep.lights_out_at).to eq lights_out_at_dt
      expect(day.summary.best).to eq "Enjoying dinner with family"
      expect(day.summary.worst).to eq "Back pain worsening"
    end
  end
end
