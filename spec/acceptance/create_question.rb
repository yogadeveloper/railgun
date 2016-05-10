require 'rails_helper'

feature 'Can ask question', %q{
  In order to be able to ask question
  As a user
  I want to be able to ask question
} do

  scenario 'User try to ask question with valid attributes' do
    visit questions_path
    first(:link, 'Ask Question').click
    fill_in 'Title', with: 'Everything in its right place'
    fill_in 'Body',  with: 'Right, man?'
    click_on 'Create' 
    expect(page).to have_content "Question successfully created"
  end


  scenario 'User try to ask question with invalid attributes' do
    visit questions_path
    first(:link, 'Ask Question').click
    fill_in 'Title', with: 's'
    fill_in 'Body',  with: 'q'
    click_on 'Create'
    save_and_open_page
    expect(page).to have_content "Title and body length should be no less than 5 letters"
  end
end