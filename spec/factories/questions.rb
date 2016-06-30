FactoryGirl.define do
  factory :question do
    sequence(:title) { |t| "Topic#{t}" }
    body 'MyText'
    user 
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
