class RemoveConstraintFromDocuments < ActiveRecord::Migration[5.2]
  def change
    change_column :documents, :user_id, :integer, :null => true
  end
end
