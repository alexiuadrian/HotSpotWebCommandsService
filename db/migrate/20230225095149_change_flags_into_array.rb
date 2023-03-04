class ChangeFlagsIntoArray < ActiveRecord::Migration[7.0]
  def change
    remove_column :commands, :flags
    add_column :commands, :flags, :string, array: true, default: []
  end
end
