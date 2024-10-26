require 'rails_helper'

describe "User accesses homepage" do
  context "when not logged in" do
    it "gets redirected to login page" do
      visit root_path

      expect(current_path).to be new_user_session_path
    end
  end
end
