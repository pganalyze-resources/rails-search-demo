Company.delete_all

p 'Starting'

Company.transaction do
  file = File.open(Rails.root.join('db', 'nasdaq.json'))
  companies = JSON.parse(file.read)

  data =
    companies.map do |company|
      description = company['description'].to_s.strip

      next nil if description.blank?

      {
        exchange: 'NASDAQ',
        symbol: company['symbol'],
        name: company['name'],
        description: description
      }
    end

  Company.import(data.compact, validate: false)
end

p 'Done NASDAQ'

Company.transaction do
  file = File.open(Rails.root.join('db', 'tsx.json'))
  companies = JSON.parse(file.read)

  data =
    companies.map do |company|
      description = company['description'].to_s.strip

      next nil if description.blank?

      {
        exchange: 'TSX',
        symbol: company['symbol'],
        name: company['name'],
        description: description
      }
    end
  Company.import(data.compact, validate: false)
end

p 'Done TSX'

Company.transaction do
  data =
    (0..250_000).to_a.map do |n|
      {
        exchange: 'FAKE',
        symbol: SecureRandom.alphanumeric(10).upcase,
        name:
          [
            Faker::Company.name,
            Faker::Beer.hop,
            Faker::Coffee.blend_name,
            Faker::Restaurant.name
          ].shuffle.first(2).join(' '),
        description:
          [
            Faker::Company.bs,
            Faker::TvShows::GameOfThrones.quote,
            Faker::Restaurant.description
          ].join(' ')
      }
    end

  Company.import(
    data,
    validate: false, on_duplicate_key_ignore: true, batch_size: 10_000
  )
end

p 'Done FAKE'
