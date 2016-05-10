require 'rails_helper'

feature 'Can answer the question', %q{
  In order to be able to answer the question
  As a user
  I want to be able to answer the question
} do
  
  given(:question) { create(:question) } 
  given(:answer) {create(:answer) }
  scenario 'User try to answer the question with valid attributes' do
    question
    answer
    visit question_path(question)

    fill_in 'Body', with: 'Hey man, I have no idea about your issue. Now you know it'
    click_on ('Reply')
    expect(page).to have_content "Your reply has been successfully posted"
  end

  scenario 'User try to answer the question with invalid attributes' do
    visit question_path(question)
    fill_in 'Body', with: 'hm'
    click_on ('Reply')
    save_and_open_page
    expect(page).to have_content "Your message is too short. Please, don't be so laconical"
  end
end