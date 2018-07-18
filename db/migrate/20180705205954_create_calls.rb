class CreateCalls < ActiveRecord::Migration[5.1]
  def change
    create_table :calls do |t|
      t.string :from, null: false
      t.string :to, null: false
      t.string :status, null: false
      t.string :call_control_id, null: false
      t.string :call_leg_id, null: false
      t.index :call_leg_id

      t.timestamps
    end
  end
end
