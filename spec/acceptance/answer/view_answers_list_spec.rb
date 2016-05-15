require 'rails_helper'

feature 'Can see answers list of question', %q{
  In order to be able to see the list of question
  As a user
} do
  scenario 'User see the list of answers' do
    question = create(:question)
    answers = create_pair(:answer, question: question)
    
    visit question_path(question)
    expect(page). to have_content "test-answerwqwqe"
  end
end