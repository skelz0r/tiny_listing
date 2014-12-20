require 'spec_helper'

feature "update a repository" do
  let(:user) { create(:user) }
  let(:link) { SITES['main_example'] }
  let(:number_of_files) { NUMBER_OF_FILES['main_example'] }

  before(:each) do
    login_as(user, scope: :user)
    pending "REFACTOR IN PROGRESS"
  end

  after(:each) do
    Warden.test_reset!
  end

  describe "that is alive" do
    use_vcr_cassette 'main_example'

    # FIXME refactor me
    scenario "with success" do
      Vacuum::Engine.new(Repository.new(link: link)).suck_up!
      alive_repository = Repository.last
      alive_repository.loots.last.destroy

      visit repository_path(alive_repository)
      page.should have_css('.loot', count: number_of_files - 1)

      within('.repository .actions') do
        click_link('Refresh')
      end

      page.should have_css('.alert.alert-success')
      page.should have_css('.loot', count: number_of_files)
    end
  end

  describe "that is dead" do

    scenario "with success" do
      pending "deport logique de retrieve link ailleurs qu'en A/R"

      dead_repository = VCR.use_cassette 'empty' do
        create(:repository, link: SITES['empty'])
      end

      #DAT HACK
      VCR.use_cassette '403' do
        dead_repository.link = SITES['403']
        dead_repository.save
      end

      create(:loot, repository: dead_repository)

      visit repository_path(dead_repository)
      page.should have_css('.loot', count: 1)

      click_on('Refresh')

      page.should have_css('.alert.alert-danger')
      page.should have_css('.loot', count: 0)
    end
  end
end
