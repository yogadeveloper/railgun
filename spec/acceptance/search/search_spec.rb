require_relative '../acceptance_helper'

feature 'search' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }
  given!(:comment) { create(:comment, commentable: answer) }

  background do
    index
    visit root_path
  end

  scenario "using 'all' context", js: true do
    select 'all', from: 'search_context'
    click_on 'Search'
    expect(page).to have_content user.email
    expect(page).to have_content question.title
    expect(page).to have_content answer.body
    expect(page).to have_content comment.body

    fill_in 'search_content', with: question.title
    click_on 'Search'
    expect(page).to have_content question.title
    expect(page).to_not have_content answer.body
    expect(page).to_not have_content comment.body
    expect(page).to_not have_content user.email
  end

  scenario "using 'questions' search", js: true do
    select 'questions', from: 'search_context'
    fill_in 'search_content', with: question.body
    click_on 'Search'
    expect(page).to have_content question.title
    expect(page).to_not have_content answer.body
    expect(page).to_not have_content comment.body
    expect(page).to_not have_content user.email
  end

  scenario "using 'answers' search", js: true do
    select 'answers', from: 'search_context'
    fill_in 'search_content', with: answer.body
    click_on 'Search'
    expect(page).to have_content answer.body
    expect(page).to_not have_content question.title
    expect(page).to_not have_content user.email
    expect(page).to_not have_content comment.body
  end

  scenario "using 'comments' search", js: true do
    select 'comments', from: 'search_context'
    fill_in 'search_content', with: comment.body
    click_on 'Search'
    expect(page).to have_content comment.body
    expect(page).to_not have_content question.title
    expect(page).to_not have_content answer.body
    expect(page).to_not have_content user.email
  end

  scenario "using 'users' search", js: true do
    select 'users', from: 'search_context'
    fill_in 'search_content', with: user.email
    click_on 'Search'
    expect(page).to have_content user.email
    expect(page).to_not have_content question.title
    expect(page).to_not have_content answer.body
    expect(page).to_not have_content comment.body
  end
end
