module Features
  module DashboardHelpers
    def fill_in_node node, text
      node.native.send_keys text
      node.native.send_key :Enter
    end

    ##
    # @return a .key-field
    # @param key
    def node(key, context=self)
      key_field = context.find('.key-field', text: key)
      node_el = key_field.find(:xpath, "..")
      return node_el
    end

    ##
    # @return the val_field div with the given key
    def val_field(key, context=self)
      node(key, context).find('.val-field')
    end

    ##
    # @return the key_field div with the given key
    def key_field(key, context=self)
      node(key, context).find('.key-field')
    end

    def fill_in_sleep
      sleep = find(".sleep")
      fields = sleep.all('.val-field')
      # awake_at
      fields[0].click
      fill_in_node fields[0], "8:30"

      # up_at
      fields[1].click
      fill_in_node fields[1], "8:35"

      # sleep_routine_at
      fields[2].click
      fill_in_node fields[2], "00:35"

      # melatonin_at
      fields[3].click
      fill_in_node fields[3], "00:30"

      # computer_off_at
      fields[4].click
      fill_in_node fields[4], "2:00"

      # lights_out_at
      fields[5].click
      fill_in_node fields[5], "2:25"
    end

    def fill_in_summary
      summary = find ".summary"
      best = node('best', summary)
      val_field('best', summary).set "Enjoying dinner with family"
      val_field('worst', summary).click
      val_field('worst', summary).set "Back pain worsening"
    end

    def fill_in_meditation
      key_field('meditation', summary).click
      meditation = node('meditation')
      meditation.native.send_keys :Enter
      nodes = sleep.all('.node-literal')
      firstkf = nodes.first.find('.key-field')
    end

    # def fill_in_work
      # key_field('meditation
#
    # end

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
