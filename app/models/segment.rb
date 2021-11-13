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
  field :plain_vs_non_plain, type: String
  field :voicing, type: String
  field :place, type: String
  field :manner, type: String
  field :additional, type: String
  field :extra, type: String
  field :unicode, type: String
  field :notes, type: String



  def self.get_options(field)
    segments = Segment.all
    array = []
    segments.each do |seg|
      case field
      when "cvd"
          field_strip = seg.cvd.strip
      when "plain_vs_non_plain"
          field_strip = seg.plain_vs_non_plain.strip
      when "voicing"
          field_strip = seg.voicing.strip
      when "place"
          field_strip = seg.place.strip
      when "manner"
          field_strip = seg.manner.strip
      end
      
      if array.exclude?(field_strip)
        array.push(field_strip)
      end
    end
    array = array.sort
    array.unshift('All')
    return array
  end

end
