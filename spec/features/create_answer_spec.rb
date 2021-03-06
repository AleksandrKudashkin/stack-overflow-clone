require_relative 'feature_helper'

feature 'Create answer to a question', %q(
  In order to help a man to solve his problem
  As an Authenticated user
  I want to be able to create an answer to a question
) do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Authenticated user creates an answer to question', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Your answer', with: 'Read the following manual!'
    click_on 'Save'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Answer was successfully created'
    expect(page).to have_content 'Read the following manual!'

    within '.new_answer' do
      expect(find_field('answer_body').value).to eq ''
    end
  end

  scenario 'Authenticated user tries to create invalid answer', js: true do
    sign_in(user)

    visit question_path(question)

    click_on 'Save'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Non-authenticated user tries to create a question' do
    visit question_path(question)

    expect(page).to_not have_content 'Your answer'
  end
end
