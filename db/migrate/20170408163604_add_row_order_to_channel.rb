class AddRowOrderToChannel < ActiveRecord::Migration[4.2]
  def change
    add_column :channels, :row_order, :integer
  end
end
