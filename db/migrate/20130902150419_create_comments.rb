class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :author, index: true
      t.references :student, index: true
      t.string :body

      t.timestamps
    end
  end
end
