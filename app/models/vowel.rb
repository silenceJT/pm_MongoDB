class Vowel
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: "Vowels_new", database: "Papua"
  field :no, type: Integer
  field :ipa, type: String
  field :short, type: String
  field :lengthened, type: String
  field :nasalised , type: String
  field :oral, type: String

  def self.get_options(field)
    vowels = self.all
    vowels.pluck("#{field}").uniq.compact_blank.sort.unshift('All')
  end
end
