class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.references :student, index: true, foreign_key: { to_table: :users }
      t.references :patient, index: true, foreign_key: { to_table: :users }
      t.string :description

      t.timestamps
    end
  end
end
