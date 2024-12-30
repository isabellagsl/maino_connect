class MakeUserIdOptionalInPostComments < ActiveRecord::Migration[8.0]
  def change
    change_column_null :post_comments, :user_id, true
  end
end
