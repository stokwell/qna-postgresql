require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:title) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }

  describe "#vote_count" do
    let (:question) {create(:question)}
    let!(:vote_up_list) {create_list(:up_vote, 5, votable: question)}
    let!(:vote_down_list) {create_list(:down_vote, 3, votable: question)}

    it "should show sum of question votes" do
      expect(question.count_votes).to eq 2
    end
  end

end
