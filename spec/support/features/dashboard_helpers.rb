module Features
  module DashboardHelpers
    def fill_in_node node, text
      node.native.send_keys text
      node.native.send_key :Enter
    end

    def node(key, context=self)
      key_field = context.find('.key-field', text: key)
      node_el = key_field.find(:xpath, "..")
      return node_el
    end

    def val_field(key, context=self)
      node(key, context).find('.val-field')
    end

    def key_field(key)
      node(key, context).find('.key-field')
    end

    def fill_in_sleep
      sleep = find(".sleep")
      fields = sleep.all('.val-field')
      fields[0].click
      fill_in_node fields[0], "8:30"

      fields[1].click
      fill_in_node fields[1], "8:35"

      fields[3].click
      fill_in_node fields[3], "2:00"

      fields[4].click
      fill_in_node fields[4], "2:25"
    end

    def fill_in_summary
      summary = find ".summary"
      best = node('best', summary)
      val_field('best', summary).set "Enjoying dinner with family asdf asdf asdf"
      val_field('worst', summary).set "back pain"
    end

    def add_goals
    end

    def save_day
      find('.day a.btn', text: 'Save').click
    end
  end
end

RSpec.configure do |c|
  c.include Features::DashboardHelpers, feature: "dashboard"
end
