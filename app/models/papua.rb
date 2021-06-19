class Papua
  include Mongoid::Document
  include Mongoid::Search
  store_in collection: "Papua", database: "SPS"
  field :no, type: Integer
  field :language, type: String
  field :language_family, type: String
  field :iso, type: String
  field :country, type: String
  field :latitude, type: String
  field :longitude, type: String
  field :inv, type: String

  search_in :no, :language, :language_family, :iso, :country, :latitude, :longitude, :inv



  def self.to_csv(options = {})
      CSV.generate(options) do |csv|
          csv << column_names
          all.each do |papua|
              csv << papua.attributes.values_at(*column_names)
          end
      end
  end


end
