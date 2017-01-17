class AddUpvotesAndDownvotesToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :upvotes, :integer
    add_index :votes, :upvotes

    add_column :votes, :downvotes, :integer
    add_index :votes, :downvotes
  end
end
