require 'spec_helper'

feature 'Access spec' do
  let(:user) { create(:user) }

  context "when non connected" do
    scenario "can access root path, without alert message" do
      visit root_path

      current_path.should == root_path
      page.should have_no_css('.alert')
    end

    scenario "no link in nav" do
      visit root_path

      within('nav.navbar') do
        page.should have_no_css('.collapse')
      end
    end

    scenario "can't access to search path, redirect to root path with an alert message" do
      visit search_path

      current_path.should == root_path
      page.should have_css('.alert')
    end
  end

  context "when connected" do
    background do
      login_as(user, scope: :user)
    end

    scenario "links in navbar" do
      visit root_path

      within('nav.navbar') do
        page.should have_css('.collapse')
      end
    end

    scenario "visit root path redirect to search path" do
      visit root_path
      
      current_path.should == search_path
    end

    describe "logout" do
      scenario "works" do
        visit root_path

        click_on "logout"

        current_path.should == root_path
      end
    end
  end
end
