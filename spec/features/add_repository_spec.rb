require 'spec_helper'

feature "Add a repository" do
  let(:user) { create(:user) }

  background do
    login_as(user, scope: :user)
    visit new_repository_path
  end

  after(:each) do
    Warden.test_reset!
  end

  describe "with a valid repository" do
    let(:link) { SITES["main_example"] }

    use_vcr_cassette "main_example"

    scenario "it works" do
      within('form#new_repository') do
        fill_in "repository_link", with: link
        find('button').click
      end

      page.should have_css('.alert.alert-success')
    end
  end

  describe "with a non-valid repository" do
    let(:link) { SITES["not_a_repository"] }

    use_vcr_cassette "not_a_repository"

    scenario "returns an error" do
      within('form#new_repository') do
        fill_in "repository_link", with: link
        find('button').click
      end

      page.should have_css('.alert.alert-danger')
    end
  end
end
