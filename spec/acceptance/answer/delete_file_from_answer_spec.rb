require_relative '../acceptance_helper'

feature 'Delete attachment' do
  given(:user){ create(:user) }
  given(:question){ create(:question, user: user) }
  given(:answer){ create(:answer, question: question, user: user) }
  given!(:attachment){ create(:attachment, attachable: answer) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'delete answers attached file', js: true do
    within 'div#answers-list' do
      expect(page).to have_link 'spec_helper.rb'
      click_on 'Edit'
      click_on 'Remove file'
      click_on 'Save'
    end
    expect(page).to_not have_link 'spec_helper.rb'
  end
end
