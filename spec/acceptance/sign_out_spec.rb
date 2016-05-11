require 'rails_helper'

feature 'User sign out', %q{
  In order to be able to complete work session
  As a User
  I want to be able to sign out
} do
  
  given(:user) { create(:user) }

  scenario 'Registered user try to sign out' do
    user
    visit questions_path
    click_on 'Log in'
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'
    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully'
    save_and_open_page
    expect(page).to have_content("Login")

  end
end