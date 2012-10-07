require 'spec_helper'

describe "StaticPages" do
  describe "home" do
    it " displays sample app" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get "/"
      response.status.should be(200)
    end
  end
describe "about" do
    it "displays sample app" do
      visit '/about'
      page.should have_content("The Crew")
    end
  end
describe "contact" do
  it "should have contact" do
    visit "/contact"
    page.should have_selector('h1',
    :text => 'contact us')
    
  end
  end
  describe "terms" do
  it "should have terms" do
    visit '/terms'
    page.should have_selector('h1',
    :text => ' Cruisin Bro Terms')
  end
  end
  describe "privacy" do
  it "should have privacy" do
    visit '/privacy'
    page.should have_selector('h1',
    :text => 'privacy')
  end
  end
end
