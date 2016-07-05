require_relative '../acceptance_helper'
#
feature 'Vote Answer'# do
#  given(:user) { create(:user) }
#  given(:user2) { create(:user) }
#  given!(:question) { create(:question, user: user2) }
#  given!(:answer) { create(:answer, question: question, user: user2) }
#  given!(:answer2) { create(:answer, question: question, user: user) }
#
#  describe 'Authenticated user' do
#    background do
#      sign_in(user)
#      visit question_path(question)
#    end
#
#    scenario 'votes for answer', js: true do
#      within '.answer:first-of-type' do
#        click_on '+1'
#
#        expect(page).to have_content 'Rating: 1'
#        expect(page).to have_button('+1', disabled: true)
#        expect(page).to have_button('-1', disabled: true)
#        expect(page).to have_button('remove', disabled: false)
#      end
#    end
#
#    scenario 'vote down', js: true do
#      within '.answer:first-of-type' do
#        click_on '-1'
#        expect(page).to have_content 'Rating: -1'
#        expect(page).to have_button('+1', disabled: true)
#        expect(page).to have_button('-1', disabled: true)
#        expect(page).to have_button('remove', disabled: false)
#      end
#    end
#
#    scenario 'remove vote', js: true do
#      within '.answer:first-of-type' do
#        click_on '+1'
#        click_on 'remove'
#
#        expect(page).to have_content 'Rating: 0'
#        expect(page).to have_button('+1', disabled: false)
#        expect(page).to have_button('-1', disabled: false)
#        expect(page).to have_button('remove', disabled: true)
#      end
#    end
#
#    scenario "Answer's author can't vote for his own answer", js: true do
#      within "div#answer-2" do
#        expect(page).to have_content 'Rating:'
#        expect(page).to_not have_button('+1')
#        expect(page).to_not have_button('-1')
#        expect(page).to_not have_button('remove')
#      end
#    end
#  end
#
#  describe 'Non-authenticated user' do
#    scenario "can't vote for the answer" do
#      visit question_path(question)
#      expect(page).to have_content 'Rating:'
#      expect(page).to_not have_button('+1')
#      expect(page).to_not have_button('-1')
#      expect(page).to_not have_button('remove')
#    end
#  end
#end
