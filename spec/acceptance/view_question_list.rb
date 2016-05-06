require 'rails_helper'

feature 'view list of questions on root_path' do  
  given(:question) { create(:question) }
  scenario 'view list of questions' do  
    question
    visit questions_path
    expect(page).to have_content question.title
  end
end 
