require_relative '../acceptance_helper'

feature 'add some comment to answer' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  scenario 'Authenticated user add comment to answer', js: true do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      click_on 'Add comment'
      within '.answer-comment-form' do
        fill_in 'Add comment', with: 'what are you doing, man?'
        click_on 'Comment'
      end
      expect(page).to have_content 'what are you doing, man?'
      expect(page).to have_content /#{user[:email]}/i
    end
  end

  scenario 'Non-authenticated user try to comment answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Add comment'
  end
end
