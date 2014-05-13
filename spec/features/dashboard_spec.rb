require "spec_helper"
require "support/features/dashboard_helpers"

feature "Dashboard", feature: "dashboard" do
  include Features::DashboardHelpers
  before(:each) do
    login
  end
  scenario "You can save the day", js: true do
    visit '#'
    expect(page).to have_text "Dashboard"

    fill_in_sleep
    fill_in_summary
    add_goals
    save_day

    ### Another way of dong it..
    #
    # "+08:00"
    # Note that this is actually system offset, but in this request spec, the browser offset will be
    # the system offset
    # browser_offset = DateTime.now.zone
    #
    # browser_tz = ...
    # browser_tz.parse("8:30")
    #
    # expd_date = Util::DateTime::today_as_experienced_date
    #
    # awake_at_dt = Util::DateTime.experienced_date_and_time_to_datetime expd_date, Time.zone.parse("8:30 #{browser_offset}")
    # up_at_dt = Util::DateTime.experienced_date_and_time_to_datetime expd_date, Time.zone.parse("8:35 #{browser_offset}")
    # computer_off_at_dt = Util::DateTime.experienced_date_and_time_to_datetime expd_date, Time.zone.parse("2:00 #{browser_offset}")
    # lights_out_at = Util::DateTime.experienced_date_and_time_to_datetime expd_date, Time.zone.parse("2:25 #{browser_offset}")
    ###

    # TODO(syu): get rid of this... or move it into its own helper method
    def normalize(datetime)
      # it's tuesday 2am and we parse tuesday 2:30am -> yes, tuesday 2am
      # it's tuesday 2am and we parse tuesday 8:30am -> no, monday 8am
      # it's tuesday 8am and we parse tuesday 8am -> yes, tuesday 8am
      # it's tuesday 8am and we parse tuesday 2am -> no, wednesday 2am
      now = Time.now
      delta = if datetime.hour > 4 && now.hour < 4
                -1
              elsif datetime.hour < 4 && now.hour > 4
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

=begin
describe "Referrals" do
  let(:host) {"test-newliving.weaveenergy.com"}
  describe "non faceboko auth, new recipient" do
    before(:each) do
      ApplicationController.any_instance.stub(:get_host).and_return host
      @product1 = create :product, :with_customizations
      @product2 = create :product, :with_customizations
      @client = create :client, :newliving, products: [@product1, @product2]
      @campaign = create :campaign, client: @client
    end
    it "works", js: true do
      visit '#'
      # The route redirects to ProductsSelectProduct
      URI.parse(current_url).fragment.should eq '/campaign/1/products/selectProduct'

      # click the product link for the nest thermostat
      product_link = all('li.product a').first
      product_link.should have_text "Nest Thermostat"

      # it creates a referral batch
      expect{product_link.click; sleep 2}.to change{ReferralBatch.count}.by 1
      @referral_batch = ReferralBatch.last

      # it has the referral batch show url
      URI.parse(current_url).fragment.should eq '/inStore/stories/1/show'

      page.should have_text "Log In with Facebook"
      page.should have_text "Share with your friends"
      page.should_not have_text "What's your name?"
      page.should_not have_text "And your email?"

      # click the share with your friends link
      find("a", text: "Share with your friends").click

      # the new forms should be revealed
      page.should have_text "What's your name?"
      page.should have_text "And your email?"


      fill_in "sender-name", with: "sherwin yu"
      fill_in "sender-email", with: "xyn.xhuwin@gmail.com"
      # it should set the values properly
      peek("$('input#sender-name').val()").should eq "sherwin yu"
      peek("$('input#sender-email').val()").should eq "xyn.xhuwin@gmail.com"

      # should have the authenticate link
      auth_link = find('a', text: 'Share!')

      # click the link
      expect{auth_link.click; sleep 2}.to change{User.count}.by 1
      @sender = User.last

      # it should create a user
      User.last.name.should eq "sherwin yu"
      User.last.email.should eq "xyn.xhuwin@gmail.com"

      URI.parse(current_url).fragment.should eq '/inStore/stories/1/referrals/select_recipient'
      page.should have_text "Select a friend"
      page.should have_field "name-or-email"

      # fill in the name with a new name
      fill_in 'name-or-email', with: "janet chien"
      find('.friend-new').should have_text /Tell janet chien about/

      # click the link
      expect{find('.friend-new').click; sleep 2}.to change{Referral.count}.by 1
      # it sets the sender on the referral_batch
      @referral_batch.reload.sender.should eq @sender.reload
      @referral = Referral.last
      @referral.sender.should eq @sender
      @referral.sender_email.should eq "xyn.xhuwin@gmail.com"
      @referral.recipient_email.should be_nil
      @referral.recipient.name.should eq "janet chien"
      @referral.recipient.email.should be_nil
      URI.parse(current_url).fragment.should eq '/inStore/stories/1/referrals/1/edit_body'

      page.should have_text "2. Finish your message"
      page.should have_text "Select a few of the following highlights"

      # 3 customziations
      all('label.customization').count.should eq @product1.customizations.count
      # nothing is selected
      all('.customization.selected').should be_empty

      # customziatinos match text
      find('label.customization', text: @product1.customizations.first.description)
      find('label.customization', text: @product1.customizations.second.description)
      # click the last one
      find('label.customization', text: @product1.customizations.third.description).click

      all('.customization.selected').count.should be 1
      find('.customization.selected').should have_text @product1.customizations.third.description

      # fill in the message
      # fill_in
      find('input.recipient-email-address').set "janet@example.com"

      # click send
      find('a', text: "SEND!").click
      sleep 3

      @referral.reload.should be_delivered
      @referral.recipient_email.should eq "janet@example.com"
      @referral.recipient.email.should eq "janet@example.com"

      URI.parse(current_url).fragment.should eq '/inStore/stories/1/referrals/select_recipient'
      page.should have_text "You've sent 1 referral."
    end
  end

  pending "create new referral with recipient" do
    before(:each) do
      create :referral_batch
    end
    it "works", js: true do
      visit  '#/stories/1/referrals/select_recipient'

      fill_in "wala", with: "y z"
      ex "$('#wala').keydown()"
      page.should_not have_content "Personalize your referral"

      find("a", text: "Yan Zhang").click
      page.should have_content "Personalize your referral"
      uri = URI.parse(current_url)
      uri.fragment.split("/").last.should eq "edit_body"
    end
  end

  pending "update existing referral with body + customizations" do
    before(:each) do
      @referral = create :referral
    end
    it "works" do
      visit "#/stories/#{@referral.referral_batch.id}/referrals/#{@referral.id}/edit_body"
      fill_in "referral-content", with: "I really think you should buy this product! It's totally awesome"
      fill_in "referral-recipient-email", with: "sherwin@communificiency.com"
      find("#referral-send").click
      page.should have_content "Your referral was sent!"
    end
  end
end
=end
