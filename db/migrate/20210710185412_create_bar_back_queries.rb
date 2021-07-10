class CreateBarBackQueries < ActiveRecord::Migration[6.1]
  def change
    create_table :bar_back_queries do |t|
      t.string :name, null: false
      t.string :string, null: false

      t.timestamps
    end
  end
end
