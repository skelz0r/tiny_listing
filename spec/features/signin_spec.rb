require 'spec_helper' 

feature 'Signin spec' do
  let(:user) { create(:user) }

  background do
    visit root_path
  end

  scenario "works with valid credentials" do
    within('form#signin') do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      find('button').click
    end

    current_path.should == search_path
  end

  context "with invalid credentials" do
    scenario "redirect to root path with an alert" do
      within('form#signin') do
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: "lol"
        find('button').click
      end

      current_path.should == user_session_path
      page.should have_css('.alert.alert-danger')
    end
  end
end
