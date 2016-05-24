require_relative '../acceptance_helper'

feature 'destroy question', %q{
  As an authenticated user
  I want to be able to delete my questions
} do
  
  given(:user) { create(:user) }
  given(:new_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user tries to delete his own question' do
    sign_in(user)
    user.questions << question
    visit question_path(question)
    click_on "Delete question"
    save_and_open_page
    expect(page).to have_content "Question succesfully destroyed"
    expect(page).to have_no_content question.title
  end

  scenario 'User try to delete question that not belongs to him' do
    sign_in(new_user)
    visit question_path(question)
    expect(page).to_not have_content "Delete question"
  end
end