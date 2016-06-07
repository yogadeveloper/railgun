require_relative '../acceptance_helper'

feature 'create question', %q{
  In order to be able to ask question
  As an authenticated user
  I want to be able to ask question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user tries to ask question with valid attributes' do
    sign_in(user)
    visit questions_path
    first(:link, 'Ask Question').click
    fill_in 'Title', with: 'Everything in its right place'
    fill_in 'Body',  with: 'Right, man?'
    click_on 'Create'
    save_and_open_page 
    expect(page).to have_content "Question successfully created"
    expect(page).to have_content "Everything in its right place"
    expect(page).to have_content "Right, man?"
  end


  scenario 'User try to ask question with invalid attributes' do
    sign_in(user)
    visit questions_path
    first(:link, 'Ask Question').click
    fill_in 'Title', with: 's'
    fill_in 'Body',  with: 'q'
    click_on 'Create'
    expect(page).to have_content "Title and body length should be no less than 5 letters"
  end


  scenario 'Non-authenticated user tries to create question' do
    visit root_path
    first(:link, 'Ask Question').click
    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end