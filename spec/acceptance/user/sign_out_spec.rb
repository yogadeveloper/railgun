require 'rails_helper'

feature 'User sign out', %q{
  In order to be able to complete work session
  As a User
  I want to be able to sign out
} do
  
  given(:user) { create(:user) }

  scenario 'Registered user try to sign out' do
    sign_in(user)
    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully'
    expect(page).to have_content("Login")

  end
end