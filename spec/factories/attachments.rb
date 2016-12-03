FactoryGirl.define do
  factory :attachment do
    file { File.new(Rails.root.join('config.ru')) }
  end
end
