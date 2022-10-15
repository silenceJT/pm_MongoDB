class Segment
  include Mongoid::Document
  # store_in collection: "Segments_test", database: "Papua"
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

  # manner
  scope :plosive, -> { where(manner: "Plosive") }
  scope :nasal, -> { where(manner: "Nasal") }
  scope :fricative, -> { where(manner: "Fricative") }
  scope :affricate, -> { where(manner: "Affricate") }
  scope :central_approximant, -> { where(manner: "Central Approximant") }
  scope :approximant, -> { where(manner: "Approximant") }
  scope :lateral_fricative, -> { where(manner: "Lateral Fricative") }
  scope :implosive, -> { where(manner: "Implosive") }
  scope :trill, -> { where(manner: "Trill") }
  scope :lateral_approximant, -> { where(manner: "Lateral Approximant") }
  scope :tap, -> { where(manner: "Tap") }
  scope :lateral_tap, -> { where(manner: "Lateral Tap") }
  scope :implosive_double_articulation, -> { where(manner: "Implosive, Double Articulation") }
  scope :lateral_flap, -> { where(manner: "Lateral Flap") }
  scope :flap, -> { where(manner: "Flap") }
  scope :lateral_affricate, -> { where(manner: "Lateral Affricate") }

  # place
  scope :velar, -> { where(place: "Velar") }
  scope :alveolar, -> { where(place: "Alveolar") }
  scope :bilabial, -> { where(place: "Bilabial") }
  scope :labio_dental, -> { where(place: "Labio-dental") }
  scope :retroflex, -> { where(place: "Retroflex") }
  scope :palatal, -> { where(place: "Palatal") }
  scope :dental, -> { where(place: "Dental") }
  scope :alveolo_palatal, -> { where(place: "Alveolo-palatal") }
  scope :uvular, -> { where(place: "Uvular") }
  scope :labio_velar, -> { where(place: "Labio-velar") }
  scope :postalveolar, -> { where(place: "Postalveolar") }
  scope :labial, -> { where(place: "Labial") }
  scope :glottal, -> { where(place: "Glottal") }
  scope :labio_palatal, -> { where(place: "Labio-palatal") }
  scope :pharyngeal, -> { where(place: "Pharyngeal") }
  scope :dental_alveolar_cluster, -> { where(place: "Dental - Alveolar Cluster") }

  # voicing
  scope :voiceless, -> { where(voicing: "Voiceless") }
  scope :voiced, -> { where(voicing: "Voiced") }

  # plain_vs_non_plain
  scope :aspirated, -> { where(plain_vs_non_plain: "Aspirated") }
  scope :plain, -> { where(plain_vs_non_plain: "Plain") }
  scope :palatalised, -> { where(plain_vs_non_plain: "Palatalised") }
  scope :pre_nasalised, -> { where(plain_vs_non_plain: "Pre-nasalised") }
  scope :pre_aspirated, -> { where(plain_vs_non_plain: "Pre-aspirated") }
  scope :labialised, -> { where(plain_vs_non_plain: "Labialised") }
  scope :pre_nasalised_labialised, -> { where(plain_vs_non_plain: "Pre-nasalised, Labialised") }
  scope :pre_glottalised, -> { where(plain_vs_non_plain: "Pre-glottalised") }
  scope :ejective, -> { where(plain_vs_non_plain: "Ejective") }
  scope :pre_nasalised_palatalised, -> { where(plain_vs_non_plain: "Pre-nasalised, Palatalised") }
  scope :pre_stopped, -> { where(plain_vs_non_plain: "Pre-stopped") }
  scope :post_stopped, -> { where(plain_vs_non_plain: "Post-stopped") }
  scope :non_plain, -> { where(plain_vs_non_plain: "Non-Plain") }

  def self.get_options(field)
    segments = self.all
    segments.pluck("#{field}").uniq.compact_blank.sort.unshift('All')
  end

end
