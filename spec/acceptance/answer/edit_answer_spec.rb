require_relative '../acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of Answer
  I would like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:another_user) { create(:user) }
  given!(:new_answer) { create(:answer, question: question, user: another_user) }

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
      within '.answers' do
        expect(page).to have_link 'Edit'    
      end  
    end

    scenario "try to edit his answer", js: true do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'
      save_and_open_page
      expect(page).to_not have_content answer.body
      expect(page).to have_content 'edited answer'
      expect(page).to_not have_selector 'textarea'
      end
    end    

    scenario "as non-author try to edit other user's question", js: true do
      save_and_open_page
      within 'div#answer-2' do
# Пробовал так:       
#     within 'div#answer-#{ new_answer.id }' do --- не работает
        expect(page).to_not have_content 'Edit'
      end
    end
    scenario "user can see Edit button only if he is author"
  end
end
