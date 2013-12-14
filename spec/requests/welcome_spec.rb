require 'spec_helper'

describe "Home page" do
  subject { page }
  before { visit root_path }
  
  describe "GET /" do
    it { should have_content('Boring Task App') }
    it { should have_link "Sign up", href: new_user_path }
    it { should have_link "try it out", href: users_path }
  end
end
