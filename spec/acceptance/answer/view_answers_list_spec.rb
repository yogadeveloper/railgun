require_relative '../acceptance_helper'

feature 'Can see answers list of question', %q{
  In order to be able to see the list of question
  As a user
} do

  given(:user) { create :user }
  given!(:question) { create :question, user: user }
  given!(:answers) { create_list :answer, 5, question: question, user: user }

  scenario 'User see the list of answers' do
    visit question_path(question)
    5.times do |count|
    expect(page).to have_content answers[count].body
   end
  end
end