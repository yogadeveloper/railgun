require 'rails_helper'

feature 'User registration', %q{
  In order to be able to ask questions
  As a User
  I want to be able to register
} do
  scenario 'User try to register with valid attributes' do
    visit root_path
    click_on 'Sign up'
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    save_and_open_page
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
  
  scenario 'User try to register with invalid attributes' do
  end
end