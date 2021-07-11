class AddUuidToBarBackQueries < ActiveRecord::Migration[6.1]
  def change
    add_column :bar_back_queries, :uuid, :string
  end
end
