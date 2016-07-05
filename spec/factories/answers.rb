FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "Body Sample#{n}" }
    question
    user
  end

  factory :invalid_answer, class: "Answer" do
    body nil
    question nil
  end
end
