class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.string   :name,        null: false
      t.text     :description, null: false

      t.belongs_to :user, foreign_key: true
      t.timestamps()
    end
  end
end
