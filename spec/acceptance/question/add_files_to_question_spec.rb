require_relative '../acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'User adds file when asks question', js: true do
    fill_in 'Title', with: 'Everything in its right place'
    fill_in 'Body',  with: 'Right, man?'
    click_on 'add file'
    fields = all('input[type="file"]')
    fields[0].set("#{Rails.root}/spec/spec_helper.rb")
    fields[1].set("#{Rails.root}/models/answer_spec.rb")
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link 'answer_spec.rb', href: '/uploads/attachment/file/2/answer_spec.rb'
  end
end
