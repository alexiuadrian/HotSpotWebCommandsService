class AddFlagsToCommands < ActiveRecord::Migration[7.0]
  def change
    add_column :commands, :flags, :string, default: ""
  end
end
