# Read about factories at https://github.com/thoughtbot/factory_girl

Dir[Rails.root.join("lib/util/**/*.rb")].each {|f| require f}

FactoryGirl.define do
  factory :rescue_time_raw do |rtr|
=begin
 ["2013-10-07T17:00:00", 1, 1, "loginwindow", "General Utilities", 1]
[
    [
        "2013-10-07T16:00:00",
        4,
        1,
        "Windows Explorer",
        "General Utilities",
        1
    ],
    [
        "2013-10-07T17:00:00",
        1012,
        1,
        "Gmail",
        "Email",
        0
    ],
    [
        "2013-10-07T17:00:00",
        7,
        1,
        "Finder",
        "General Utilities",
        1
    ],
    [
        "2013-10-07T17:00:00",
        5,
        1,
        "iTerm",
        "General Software Development",
        2
    ],
    [
        "2013-10-07T17:00:00",
        1,
        1,
        "loginwindow",
        "General Utilities",
        1
    ]
]
=end
    rtr.rt_date Util::DateTime.format_as_rt_date Time.parse "2013-10-07T17:00:00"
    rt_time_spent 15.minutes
    rt_number_of_people 1
    rt_category "General Utilities"
    rt_activity "loginwindow"
  end
end
