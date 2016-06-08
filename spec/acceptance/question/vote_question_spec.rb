require_relative '../acceptance_helper'

feature 'Vote Question' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user2) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes for question', js: true do
      within 'div#question-1' do
        click_on '+1'

        expect(page).to have_content 'Rating: 1'
        expect(page).to have_button('+1', disabled: true)
        expect(page).to have_button('-1', disabled: true)
        expect(page).to have_button('remove', disabled: false)
      end
    end

    scenario 'vote down', js: true do
      within 'div#question-1}' do
        click_on '-1'
        expect(page).to have_content 'Rating: -1'
        expect(page).to have_button('+1', disabled: true)
        expect(page).to have_button('-1', disabled: true)
        expect(page).to have_button('remove', disabled: false)
      end
    end

    scenario 'remove vote', js: true do
      within 'div#question-1' do
        click_on '+1'
        click_on 'remove'

        expect(page).to have_content 'Rating: 0'
        expect(page).to have_button('+1', disabled: false)
        expect(page).to have_button('-1', disabled: false)
        expect(page).to have_button('remove', disabled: true)
      end
    end
  end

  describe 'Question author' do
    background do
      sign_in user2
      visit question_path(question)
    end

    scenario "can't vote for his own question", js: true do
      within "div#question-1" do
        expect(page).to have_content 'Rating:'
        expect(page).to_not have_button('+1')
        expect(page).to_not have_button('-1')
        expect(page).to_not have_button('remove')
      end
    end
  end

  describe 'Non-authenticated user' do
    scenario "can't vote for the question" do
      visit question_path(question)
      expect(page).to have_content 'Rating:'
      expect(page).to_not have_button('+1')
      expect(page).to_not have_button('-1')
      expect(page).to_not have_button('remove')
    end
  end
end
