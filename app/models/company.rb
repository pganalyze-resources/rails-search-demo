class Company < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search,
                  against: { name: 'A', description: 'B' },
                  using: {
                    tsearch: {
                      dictionary: 'english', tsvector_column: 'searchable'
                    }
                  }

  validates :exchange, :symbol, :name, :description, presence: true

  scope :name_imatch, ->(name) { where('companies.name ilike ?', name) }

  scope :name_partial, ->(name) { where('companies.name ilike ?', "%#{name}%") }

  scope :name_similar,
        lambda { |name|
          quoted_name = ActiveRecord::Base.connection.quote_string(name)
          where('companies.name % :name', name: name).order(
            Arel.sql("similarity(companies.name, '#{quoted_name}') DESC")
          )
        }
end
