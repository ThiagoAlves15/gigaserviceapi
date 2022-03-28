class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.jsonb :name
      t.string :gender
      t.string :email
      t.json :picture
      t.string :naturalization

      t.timestamps
    end
  end
end
