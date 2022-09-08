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

      include_ids = Segment.in(ipa: include_ary).pluck(:id)
      exclude_ids = Segment.in(ipa: exclude_ary).pluck(:id)

      papuas = papuas.and({:segment_ids.all => include_ids}, {:segment_ids.nin => exclude_ids})
    end

    papuas
  end

  def add_segment!(segment)
    byebug
    segment = segment - self.segments
    self.reload.segments << segment if segment.present?
  end

  def remove_segment!(segment)
    byebug
    segment = self.segments & segment
    if segment.present?
      segment.each do |seg|
        self.reload.segments.delete(seg) 
      end
    end
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
