FactoryGirl.define do
  factory :answer do
    body  'test-answerwqwqe'
    question_id 1
    user
  end

  factory :invalid_answer, class: "Answer" do
    body nil
    question nil
  end
end