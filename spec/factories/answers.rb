FactoryGirl.define do
  factory :answer do
    user
    question
    sequence(:body) { |n| "Answer #{n}" }
  end

  factory :invalid_answer, class: 'Answer' do
    user
    question
    body nil
  end

  factory :best_answer, class: 'Answer'  do
    body "It_is_the_best_answer"
    user
    association :question
    best_answer true  
  end

  factory :usual_answer, class: 'Answer'  do
    body "It_is_an_usual_answer "
    user
    association :question
    best_answer false  
  end


end
