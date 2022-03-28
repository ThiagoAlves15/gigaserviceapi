class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.jsonb :name
      t.string :gender
      t.json :location
      t.string :email
      t.timestamp :birthday
      t.timestamp :registered
      t.string :phone
      t.string :cellphone
      t.json :picture
      t.string :naturalization

      t.timestamps
    end
  end
end
