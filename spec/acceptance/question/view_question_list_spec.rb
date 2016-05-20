require 'rails_helper'

feature 'view list of questions on root_path' do  
  given(:user) { create :user }
  given!(:questions) { create_list(:question, 5, user: user) }
 
  scenario 'view list of questions' do  
    visit questions_path
    5.times do |count|
      expect(page).to have_content questions[count].title
    end
  end
end 
