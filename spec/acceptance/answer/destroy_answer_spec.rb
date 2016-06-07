require 'rails_helper'

feature 'destroy answer', %q{
  As an authenticated User
  I want to be able to remove my own answers
} do

  given(:user) { create(:user ) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  before { user.answers << answer}

  scenario 'Authenticated user tries to delete his own answer' do
    sign_in(user)
    visit question_path(question)
    click_on "Delete answer"
    expect(page).to have_content "Your answer has been successfully removed"
    expect(page).to have_no_content answer.body
  end

  scenario 'User try to remove answer not belongs to him' do
    visit question_path(question)
    expect(page).to have_no_content "Delete answer"
  end
end
