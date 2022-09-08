class Segment
  include Mongoid::Document
  # store_in collection: "Segments", database: "Papua"
  # field :no, type: Integer
  # field :ipa, type: String
  # field :sequence, type: String
  # field :category, type: String
  # field :place, type: String

  store_in collection: "Segments_new", database: "Papua"
  field :no, type: Integer
  field :ipa, type: String
  field :cvd, type: String
  field :number, type: Integer
  field :plain_vs_non_plain, type: String
  field :voicing, type: String
  field :place, type: String
  field :manner, type: String
  field :additional, type: String
  field :extra, type: String
  field :unicode, type: String
  field :notes, type: String

  has_and_belongs_to_many :papuas

  def self.get_options(field)
    segments = self.all
    segments.pluck("#{field}").uniq.compact_blank.sort.unshift('All')
  end

end
