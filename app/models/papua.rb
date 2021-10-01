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
  field :consonants, type: String
  field :vowels, type: String
  field :diphthongs, type: String
  field :count_of_segments, type: Integer
  field :count_of_consonants, type: Integer
  field :count_of_vowels, type: Integer
  field :count_of_diphthongs, type: Integer


  #search_in :no, :language, :language_family, :iso, :country, :latitude, :longitude, :inv
  search_in :inv
  #search_in :language_name, index: :_language_keywords
  #search_in :count_of_consonants, index: :_con_keywords
  #search_in :count_of_vowels, index: :_vow_keywords
  #search_in :count_of_segments, index: :_seg_keywords


  def self.to_csv(options = {})
      CSV.generate(options) do |csv|
          csv << column_names
          all.each do |papua|
              csv << papua.attributes.values_at(*column_names)
          end
      end
  end

  def self.search_by_inv(sub_string)
   self.where(inv: /#{"sub_string"}/)
end


end
