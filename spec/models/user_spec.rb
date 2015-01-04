require 'spec_helper'

describe User do
  describe "creation" do
    it "properly saves the encrypted password" do
      u = User.create email: "hello@example.com", password: "password"
      expect(u.reload.encrypted_password).to_not be_nil
      expect(u.email).to eq "hello@example.com"
      expect(User.find_by( email: "hello@example.com").password).to be_nil
    end
  end


end
