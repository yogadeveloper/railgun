require_relative '../acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of Question
  I'd like to be able to edit my question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:other_user) { create(:user) }
  given(:other_question) { create(:question, user: other_user) }

  scenario 'Unathenticated user try to edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to Edit' do
      expect(page).to have_link 'Edit'
    end

    scenario "try to edit his question", js: true do
      click_on 'Edit'
      within '.edit_question' do
        fill_in 'Title', with: 'edited question title'
        fill_in 'Body', with: 'edited question'
        click_on 'Save'
      end
      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question title'
      expect(page).to have_content 'edited question'
      expect(page).to_not have_selector 'textarea#question.body'
    end


    scenario "as non-author try to edit other user's question", js: true do
      visit question_path(other_question)
      expect(page).to_not have_link 'Edit'
    end
  end

end
