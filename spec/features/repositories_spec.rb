require 'spec_helper'

feature 'Repositories listing' do
  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user)
  end

  after do
    Warden.test_reset!
  end

  before(:all) do
    2.times do
      create(:repository)
    end
    create(:repository, alive: false)
  end

  scenario "display all" do
    visit repositories_path

    page.should have_css('.repository', count: Repository.count)
  end

  scenario "add a css class on tr depend on alive boolean" do
    visit repositories_path

    page.should have_css('.repository.success', count: Repository.where(alive: true).count)
    page.should have_css('.repository.danger', count: Repository.where(alive: false).count)
  end
end
