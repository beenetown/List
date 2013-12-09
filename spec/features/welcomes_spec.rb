require 'spec_helper'

describe "Home page" do

  describe "GET /" do
    before { visit root_path }

    it "should have heading" do
      expect(page).to have_content('Boring Task App')
    end

    it "should have a link button to sign up" do
      expect(page).to have_link "Sign up", href: new_user_path
    end

    it "should have a link to try it out" do
      expect(page).to have_link "try it out", href: "#"
    end
  end
end
