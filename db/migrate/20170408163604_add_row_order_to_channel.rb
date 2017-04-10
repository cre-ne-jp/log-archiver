class AddRowOrderToChannel < ActiveRecord::Migration
  def change
    add_column :channels, :row_order, :integer
  end
end
