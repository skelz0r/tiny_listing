require 'spec_helper'

feature 'File search' do
  let(:user) { create(:user) }

  before(:all) do
    create(:loot, name: 'The lord of the rings', extension: 'mp4')
    create(:loot, name: 'The lord of the rings', extension: 'mp3')
    create(:loot, name: 'The lord of the rings', extension: 'jpg')

    create(:loot, name: 'Thank you lord', extension: 'avi')

    create(:loot, name: 'Ring my bell!', extension: 'mp3')
    create(:loot, name: 'Ring my belly!', extension: 'gif')
  end

  after(:all) do
    Loot.destroy_all
    Warden.test_reset!
  end

  before(:each) do
    login_as(user, scope: :user)
    visit search_path
  end

  context "with nothing fill" do
    scenario "it returns an error" do
      launch_search

      page.should have_css('.alert.alert-danger')
    end
  end

  context "for real file name with underscore" do
    before do
      create(:loot, name: "no_you_listen", extension: "mp3")
    end

    scenario "works (thanks to loot's name_sanitize)" do
      fill_in 'loot_name', with: 'listen'
      launch_search

      page.should have_css("#loots")

      within("#loots") do
        page.should have_css('.loot', count: 1)
        page.should have_content('no_you_listen')
      end
    end
  end

  context "basic search" do
    before do
      fill_in 'loot_name', with: 'The lord of the rings'
      launch_search
    end

    it 'returns exact matchs' do
      page.should have_css("#loots")
      within("#loots") do
        page.should have_css('.loot', count: 3)
        page.should have_content('The lord of the rings')
      end
    end

    it "returns the number of results" do
      page.should have_content("3 results")
    end
  end

  context "with only name" do
    it 'on a partial name with one precise word' do
      fill_in 'loot_name', with: 'lord'
      launch_search

      page.should have_css("#loots")
      within("#loots") do
        page.should have_css('.loot', count: 4)
      end
    end

    it 'on a partial name with an approximate word' do
      fill_in 'loot_name', with: 'ring'
      launch_search

      page.should have_css("#loots")
      within("#loots") do
        page.should have_css('.loot', count: 5)
      end
    end
  end

  context "with an extension" do
    it 'without text works' do
      fill_in 'loot_name', with: ''
      select 'mp3', from: "loot_extension"
      launch_search

      page.should have_css("#loots")
      within("#loots") do
        page.should have_css('.loot', count: 2)
      end
    end

    it 'with some text works' do
      fill_in 'loot_name', with: 'lord'
      select 'mp3', from: "loot_extension"
      launch_search

      page.should have_css("#loots")
      within("#loots") do
        page.should have_css('.loot', count: 1)
      end
    end
  end
end
