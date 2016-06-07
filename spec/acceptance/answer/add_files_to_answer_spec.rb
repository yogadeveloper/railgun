require_relative '../acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds file when create the answer', js: true do
    fill_in 'Body',  with: 'test answ2er'
    click_on 'add file'
    fields = all('input[type="file"]')
    fields[0].set("#{Rails.root}/spec/spec_helper.rb")
    fields[1].set("#{Rails.root}/models/answer_spec.rb")
    click_on 'Reply'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'answer_spec.rb', href: '/uploads/attachment/file/2/answer_spec.rb'
    end
  end

  scenario 'User adds files when edits the answer', js: true do
    within 'div#answers-list' do
      click_on 'Edit'
      click_on 'add file'
      first('input[type="file"]').set("#{Rails.root}/spec/spec_helper.rb")
      click_on 'Save'
    end
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end
end
