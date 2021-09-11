class CreateUserWithUids < ActiveRecord::Migration[6.1]
  def change
    create_table :user_with_uids, primary_key: :uid do |t|
      t.string :name

      t.timestamps
    end
  end
end
