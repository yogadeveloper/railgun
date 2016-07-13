require_relative '../acceptance_helper'

include ActiveJob::TestHelper


feature 'Add subscription to Question' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user2) }

  describe 'unathenticated user' do
    scenario 'can not create subscription', js: true do
      visit question_path(question)
      within '.question' do
        expect(page).to_not have_content 'Subscribe'
        expect(page).to_not have_content 'Unsubscribe'
      end
    end
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'create subscription', js: true do
      within '.question' do
        click_on 'Subscribe'
        expect(page).to have_link 'Unsubscribe'
      end
    end

    scenario 'remove subscription' do
      within '.question' do
        click_on 'Subscribe'
        click_on 'Unsubscribe'
        expect(page).to have_link 'Subscribe'
        expect(page).to_not have_link 'Unsubscribe'
      end
    end

  #  scenario 'check email with answer', js: true do
  #    click_on 'Subscribe'
  #    within '.new_answer' do
  #      fill_in 'Body', with: 'check your inbox, my friend'
  #      perform_enqueued_jobs do
  #        click_on 'Answer'
  #        sleep(1)
  #        open_email(user.email)
  #        expect(current_email).to have_content 'check your inbox, my friend'
  #      end
  #    end
  #  end
  end
end
