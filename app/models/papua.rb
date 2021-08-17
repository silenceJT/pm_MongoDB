class Papua
  include Mongoid::Document
  include Mongoid::Search
  #store_in collection: "Papua", database: "SPS"
  store_in collection: "Papuas", database: "Papua"
  field :no, type: Integer
  field :language_name, type: String
  field :language_family, type: String
  field :iso, type: String
  field :country, type: String
  field :latitude, type: String
  field :longitude, type: String
  field :inv, type: String
  field :count_of_segments, type: Integer
  field :count_of_consonants, type: Integer
  field :count_of_vowels, type: Integer
  field :count_of_diphthongs, type: Integer


  #search_in :no, :language, :language_family, :iso, :country, :latitude, :longitude, :inv
  search_in :inv


  def self.to_csv(options = {})
      CSV.generate(options) do |csv|
          csv << column_names
          all.each do |papua|
              csv << papua.attributes.values_at(*column_names)
          end
      end
  end


end