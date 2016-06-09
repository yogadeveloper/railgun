FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "Body Sample#{n}" }
    question_id nil
    user nil
  end

  factory :invalid_answer, class: "Answer" do
    body nil
    question nil
  end
end
