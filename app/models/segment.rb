class Segment
  include Mongoid::Document
  store_in collection: "Segments", database: "Papua"
  field :no, type: Integer
  field :ipa, type: String
  field :sequence, type: String
  field :category, type: String
  field :place, type: String

  Segment.each do |seg|
  	seg.no = seg.no.to_i
  	seg.save
  end
end
