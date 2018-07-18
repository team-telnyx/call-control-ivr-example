class AddDirectionToCall < ActiveRecord::Migration[5.2]
  def change
    add_column :calls, :direction, :string
  end
end
