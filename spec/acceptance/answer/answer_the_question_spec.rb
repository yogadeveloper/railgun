require_relative '../acceptance_helper'

feature 'Can answer the question', %q{
  In order to be able to answer the question
  As a user
  I want to be able to answer the question
} do
  given(:user) { create(:user) }
  let!(:question) { create(:question, user: user) } 
  given(:answer) {create(:answer, question: question, user: user) }
  scenario 'User try to answer the question with valid attributes', js: true do
    sign_in(user)
    answer
    visit question_path(question)

    fill_in 'Body', with: 'Hey man, I have no idea about your issue. Now you know it'
    click_on ('Reply')
    expect(page).to have_content "Hey man, I have no idea about your issue. Now you know it"
  end

  scenario 'User try to answer the question with invalid attributes', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'hm'
    click_on ('Reply')
    expect(page).to have_content "Body is too short (minimum is 5 characters)"
  end
end