class AddTrigramIndexCompaniesName < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_index :companies,
              :name,
              opclass: :gin_trgm_ops,
              using: :gin,
              algorithm: :concurrently,
              name: 'index_companies_on_name_trgm'
  end
end
