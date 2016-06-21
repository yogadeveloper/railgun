require_relative '../acceptance_helper'

feature 'add some comment' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user add comment to question', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Add comment'
    within('.question-comment-form') do
      fill_in 'Add comment', with: 'what are you doing, man?'
    end
    click_on 'Comment'
    expect(page).to have_content user[:email]
    expect(page).to have_content 'what are you doing, man?'
  end

  scenario 'Non-authenticated user try to comment question' do
    visit question_path(question)
    expect(page).to_not have_link 'Add comment'
  end
end
