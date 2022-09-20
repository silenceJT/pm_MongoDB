class Papua
  include Mongoid::Document
  include Mongoid::Search
  # store_in collection: "Papua", database: "SPS"
  store_in collection: "Papuas", database: "Papua"
  field :no, type: Integer
  field :language_name, type: String
  field :language_family, type: String
  field :iso, type: String
  field :area, type: String
  field :country, type: String
  field :region, type: String
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
  field :source, type: String
  field :notes, type: String

  has_and_belongs_to_many :segments

  def self.search(params)
    papuas = Papua.all

    papuas = papuas.where(:language_name => /#{params[:language_name]}/i) if params[:language_name].present?
    papuas = papuas.where(:language_family => /#{params[:language_family]}/i) if params[:language_family].present?
    papuas = papuas.where(:iso => /#{params[:iso]}/i) if params[:iso].present?
    papuas = papuas.where(:area => /#{params[:area]}/i) if params[:area].present?
    papuas = papuas.where(:country => /#{params[:country]}/i) if params[:country].present?
    papuas = papuas.where(:region => /#{params[:region]}/i) if params[:region].present?

    if params[:c_size].present?
      case params[:c_compare]
      when ">="
        papuas = papuas.where(:count_of_consonants.gte => params[:c_size])
      when ">"
        papuas = papuas.where(:count_of_consonants.gt => params[:c_size])
      when "="
        papuas = papuas.where(:count_of_consonants => params[:c_size])
      when "<"
        papuas = papuas.where(:count_of_consonants.lt => params[:c_size])
      else
        papuas = papuas.where(:count_of_consonants.lte => params[:c_size])
      end
    end

    if params[:v_size].present?
      case params[:v_compare]
      when ">="
        papuas = papuas.where(:count_of_vowels.gte => params[:v_size])
      when ">"
        papuas = papuas.where(:count_of_vowels.gt => params[:v_size])
      when "="
        papuas = papuas.where(:count_of_vowels => params[:v_size])
      when "<"
        papuas = papuas.where(:count_of_vowels.lt => params[:v_size])
      else
        papuas = papuas.where(:count_of_vowels.lte => params[:v_size])
      end
    end

    if params[:total_size].present?
      case params[:total_compare]
      when ">="
        papuas = papuas.where(:count_of_segments.gte => params[:total_size])
      when ">"
        papuas = papuas.where(:count_of_segments.gt => params[:total_size])
      when "="
        papuas = papuas.where(:count_of_segments => params[:total_size])
      when "<"
        papuas = papuas.where(:count_of_segments.lt => params[:total_size])
      else
        papuas = papuas.where(:count_of_segments.lte => params[:total_size])
      end
    end

    if params[:inv].present?
      input_ary = params[:inv].split(" ")

      exclude_ary = input_ary.select { |i| i.start_with?("-") }
      include_ary = input_ary - exclude_ary
      exclude_ary = exclude_ary.map { |e| e.gsub(/-/, '') }

      include_uppercase_ary = []
      include_lowercase_ary = []

      exclude_uppercase_ary = []
      exclude_lowercase_ary = []

      if params[:inv].match?(/\b[A-Z]+\b/)
        include_uppercase_ids = []
        exclude_uppercase_ids = []

        include_ary.each do |inc_str|
          include_uppercase_ary.push(inc_str) if inc_str.match?(/\b[A-Z]+\b/)
        end

        exclude_ary.each do |exc_str|
          exclude_uppercase_ary.push(exc_str) if exc_str.match?(/\b[A-Z]+\b/)
        end

        include_uppercase_ids = self.process_uppercase(include_uppercase_ary)
        exclude_uppercase_ids = self.process_uppercase(exclude_uppercase_ary)
      end

      include_lowercase_ary = include_ary - include_uppercase_ary
      exclude_lowercase_ary = exclude_ary - exclude_uppercase_ary

      include_lowercase_ids = Segment.in(ipa: include_lowercase_ary).pluck(:id)
      exclude_lowercase_ids = Segment.in(ipa: exclude_lowercase_ary).pluck(:id)

      papuas = papuas.where(:segment_ids.all => include_lowercase_ids) if include_lowercase_ary.present?
      
      papuas = papuas.where(:segment_ids.nin => exclude_lowercase_ids) if exclude_lowercase_ary.present?

      papuas = papuas.where(:segment_ids.all => include_uppercase_ids) if include_uppercase_ary.present?
      
      papuas = papuas.where(:segment_ids.nin => exclude_uppercase_ids) if exclude_uppercase_ary.present?
    end

    papuas
  end

  def add_segment!(segment)
    segment = segment - self.segments
    self.reload.segments << segment if segment.present?
  end

  def remove_segment!(segment)
    segment = self.segments & segment
    if segment.present?
      segment.each do |seg|
        self.reload.segments.delete(seg) 
      end
    end
  end

  def self.process_uppercase(array)
    return [] if array.empty?
  
    ids = Segment.pluck(:id)

    array.each do |str|
      case str
      # Manner
      when 'PLO'
        ids &= Segment.plosive.pluck(:id)
      when 'NAS'
        ids &= Segment.nasal.pluck(:id)
      when 'FRI'
        ids &= Segment.fricative.pluck(:id)
      when 'AFF'
        ids &= Segment.affricate.pluck(:id)
      when 'CAP'
        ids &= Segment.central_approximant.pluck(:id)
      when 'APP'
        ids &= Segment.approximant.pluck(:id)
      when 'LFR'
        ids &= Segment.lateral_fricative.pluck(:id)
      when 'IMP'
        ids &= Segment.implosive.pluck(:id)
      when 'TRI'
        ids &= Segment.trill.pluck(:id)
      when 'LAP'
        ids &= Segment.lateral_approximant.pluck(:id)
      when 'TAP'
        ids &= Segment.tap.pluck(:id)
      when 'LTA'
        ids &= Segment.lateral_tap.pluck(:id)
      when 'IDA'
        ids &= Segment.implosive_double_articulation.pluck(:id)
      when 'LFL'
        ids &= Segment.lateral_flap.pluck(:id)
      when 'FLA'
        ids &= Segment.flap.pluck(:id)
      when 'LAF'
        ids &= Segment.lateral_affricate.pluck(:id)
      
      # Place
      when 'VEL'
        ids &= Segment.velar.pluck(:id)
      when 'ALV'
        ids &= Segment.alveolar.pluck(:id)
      when 'BIL'
        ids &= Segment.bilabial.pluck(:id)
      when 'LDE'
        ids &= Segment.labio_dental.pluck(:id)
      when 'RET'
        ids &= Segment.retroflex.pluck(:id)
      when 'PAL'
        ids &= Segment.palatal.pluck(:id)
      when 'DEN'
        ids &= Segment.dental.pluck(:id)
      when 'APA'
        ids &= Segment.alveolo_palatal.pluck(:id)
      when 'UVU'
        ids &= Segment.uvular.pluck(:id)
      when 'LVE'
        ids &= Segment.labio_velar.pluck(:id)
      when 'PVE'
        ids &= Segment.postalveolar.pluck(:id)
      when 'LAB'
        ids &= Segment.labial.pluck(:id)
      when 'GLO'
        ids &= Segment.glottal.pluck(:id)
      when 'LPA'
        ids &= Segmentlabio_palatal..pluck(:id)
      when 'PHA'
        ids &= Segment.pharyngeal.pluck(:id)
      when 'DAC'
        ids &= Segment.dental_alveolar_cluster.pluck(:id)

      # Voicing
      when 'VL'
        ids &= Segment.voiceless.pluck(:id)
      when 'VD'
        ids &= Segment.voiced.pluck(:id)

      # Plain vs non plain
      when 'ASP'
        ids &= Segment.aspirated.pluck(:id)
      when 'PLA'
        ids &= Segment.plain.pluck(:id)
      when 'PLD'
        ids &= Segment.palatalised.pluck(:id)
      when 'PNA'
        ids &= Segment.pre_nasalised.pluck(:id)
      when 'PAS'
        ids &= Segment.pre_aspirated.pluck(:id)
      when 'LBD'
        ids &= Segment.labialised.pluck(:id)
      when 'PNL'
        ids &= Segment.pre_nasalised_labialised.pluck(:id)
      when 'PGL'
        ids &= Segment.pre_glottalised.pluck(:id)
      when 'EJE'
        ids &= Segment.ejective.pluck(:id)
      when 'PNP'
        ids &= Segment.pre_nasalised_palatalised.pluck(:id)
      when 'PRS'
        ids &= Segment.pre_stopped.pluck(:id)
      when 'POS'
        ids &= Segment.post_stopped.pluck(:id)
      when 'NP'
        ids &= Segment.non_plain.pluck(:id)
      end
    end

    return ids
  end

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
