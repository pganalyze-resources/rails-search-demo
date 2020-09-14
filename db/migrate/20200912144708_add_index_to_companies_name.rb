class AddIndexToCompaniesName < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_index :companies, :name, algorithm: :concurrently
  end
end
