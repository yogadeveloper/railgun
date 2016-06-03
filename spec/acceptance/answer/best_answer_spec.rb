require_relative '../acceptance_helper'

feature 'Can set the best answer', %q{
  I want to be able to set the best answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create_list(:answer, 5, question: question, user: user) }
  given!(:non_author) { create(:user) }
  given!(:answer_to_mark) { create(:answer, question: question, user: user) }

  scenario 'Non-authenticated user tries to set the best answer', js: true do
    visit question_path(question)
    expect(page).to_not have_content "Mark as Best"
  end
  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "Sees the link 'best answer'", js: true do
      expect(page).to have_content "Mark as Best"
    end

    scenario "try to mark best answer", js: true do
      within("div#answer-#{answer_to_mark.id}") do
        expect(page).to_not have_selector("best")
        click_on "Mark as Best"
      end
      within '.best' do
        expect(page).to have_content answer_to_mark.body
      end
    end
  end

  scenario 'Non-author tries to set best answer', js: true do
    sign_in(non_author)
    visit question_path(question)
    expect(page).to_not have_content "Mark as Best"
  end
end
