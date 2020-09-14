class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :exchange, null: false
      t.string :symbol, null: false
      t.string :name, null: false
      t.text :description, null: false
      t.timestamps

      t.index :symbol
      t.index %i[exchange symbol], unique: true
    end
  end
end
