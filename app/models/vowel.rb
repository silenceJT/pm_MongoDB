class Vowel
  include Mongoid::Document
  include Mongoid::Timestamps

  store_in collection: "Vowels_new", database: "Papua"
  # store_in collection: "Vowels_test", database: "Papua" # Test only
  field :no, type: Integer
  field :ipa, type: String
  field :short, type: String
  field :lengthened, type: String
  field :nasalised , type: String
  field :oral, type: String

  has_and_belongs_to_many :papuas

  scope :short, -> { where(short: "yes")}
  scope :lengthened, -> { where(lengthened: "yes")}
  scope :nasalised, -> { where(nasalised: "yes")}
  scope :oral, -> { where(oral: "yes")}

  def self.get_options(field)
    vowels = self.all
    vowels.pluck("#{field}").uniq.compact_blank.sort.unshift('All')
  end
end
