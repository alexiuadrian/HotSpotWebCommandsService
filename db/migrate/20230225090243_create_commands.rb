class CreateCommands < ActiveRecord::Migration[7.0]
  def change
    create_table :commands do |t|
      t.string :name
      t.boolean :is_available
      t.boolean :requires_admin

      t.timestamps
    end
  end
end
