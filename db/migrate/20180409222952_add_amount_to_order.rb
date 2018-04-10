class AddAmountToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :balance, :decimal,
      precision: 8,
      default: 0,
      scale: 2
  end
end
