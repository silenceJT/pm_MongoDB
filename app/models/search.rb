class Search
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: "Searches", database: "Papua"
  field :language_name, type: String
  field :language_family, type: String
  field :iso, type: String
  field :area, type: String
  field :country, type: String
  field :region, type: String
  field :inv, type: String
  field :c_compare, type: String
  field :c_size, type: Integer
  field :v_compare, type: String
  field :v_size, type: Integer
  field :total_compare, type: String
  field :total_size, type: Integer
  field :result, type: String
  field :created_by, type: String

  COMPARE = %w{ >= > = < <= }

  COLNAMES = %w{ Bilabial Labial Labio-dental Dental Alveolar Alveolo-palatal Postalveolar 
    Retroflex Labio-palatal Palatal Labio-velar Velar Uvular Pharyngeal Glottal}

  ROWNAMES = [ "Plosive", "Affricate", "Lateral Affricate", "Fricative", "Lateral Fricative", "Nasal", 
    "Trill", "Tap", "Lateral Tap", "Flap", "Lateral Flap", "Approximant", "Central Approximant", 
    "Lateral Approximant", "Implosive", "Implosive, Double Articulation" ]

  def papuas
    @papuas ||= find_papuas
  end

  def papuas_other
    other = Array.new()
    @papuas.each do |pap|
      other.push(pap.no)
    end
    @papuas_other = Papua.not_in(:no => other)
  end

  # def result
  #   @result = (@papuas.size.to_f * 100 / Papua.all.size).round(2)
  # end

  def find_papuas
    papuas = Papua.all

    papuas = papuas.where(:language_name => /#{language_name}/i) if language_name.present?
    papuas = papuas.where(:language_family => /#{language_family}/i) if language_family.present?
    papuas = papuas.where(:iso => /#{iso}/i) if iso.present?
    papuas = papuas.where(:area => /#{area}/i) if area.present?
    papuas = papuas.where(:country => /#{country}/i) if country.present?
    papuas = papuas.where(:region => /#{region}/i) if region.present?

    if c_size.present?
      case c_compare
      when ">="
        papuas = papuas.where(:count_of_consonants.gte => c_size)
      when ">"
        papuas = papuas.where(:count_of_consonants.gt => c_size)
      when "="
        papuas = papuas.where(:count_of_consonants => c_size)
      when "<"
        papuas = papuas.where(:count_of_consonants.lt => c_size)
      else
        papuas = papuas.where(:count_of_consonants.lte => c_size)
      end
    end

    if v_size.present?
      case v_compare
      when ">="
        papuas = papuas.where(:count_of_consonants.gte => v_size)
      when ">"
        papuas = papuas.where(:count_of_consonants.gt => v_size)
      when "="
        papuas = papuas.where(:count_of_consonants => v_size)
      when "<"
        papuas = papuas.where(:count_of_consonants.lt => v_size)
      else
        papuas = papuas.where(:count_of_consonants.lte => v_size)
      end
    end

    if total_size.present?
      case total_compare
      when ">="
        papuas = papuas.where(:count_of_consonants.gte => total_size)
      when ">"
        papuas = papuas.where(:count_of_consonants.gt => total_size)
      when "="
        papuas = papuas.where(:count_of_consonants => total_size)
      when "<"
        papuas = papuas.where(:count_of_consonants.lt => total_size)
      else
        papuas = papuas.where(:count_of_consonants.lte => total_size)
      end
    end


    #full text search
    if inv.present?
      exclude_array = Array.new()
      include_array = Array.new()
      counts_inc = Hash.new()
      counts_exc = Hash.new()
      combined_inc = Array(1..Papua.all.size)
      combined_exc = Array.new()
      all_no = Array(1..Papua.all.size)
      final_no = Array.new()

      # split inc and exc into 2 arraies
      str_array = inv.split(" ")
      str_array.each do |str_item|
        if str_item.start_with?('-')
          str_item.slice!(0)
          exclude_array.push(str_item)
        else
          include_array.push(str_item)
        end
      end

      # extract no from results
      include_array.each do |inc_item|
        if inc_item.include?('g')
          inc_item['g'] = 'ɡ'
        end
        include_no = []
        papuas.each do |papua|
          for p_inv in papua.inv.split("\,") do
            p_inv_striped = p_inv.strip
            if p_inv_striped == inc_item
              include_no.push(papua.no)
            end
          end
        end
        # papuas_inc = papuas.where(:inv => /#{inc_item}/)
        # papuas_inc.each do |p_inc|
        #   include_no.push(p_inc.no)
        # end
        combined_inc = combined_inc & include_no
      end

      exclude_array.each do |exc_item|
        if exc_item.include?('g')
          exc_item['g'] = 'ɡ'
        end
        exclude_no = []
        papuas.each do |papua|
          for p_inv in papua.inv.split("\,") do
            p_inv_striped = p_inv.strip
            if p_inv_striped == exc_item
              exclude_no.push(papua.no)
            end
          end
        end
        # papuas_exc = papuas.where(:inv => /#{exc_item}/)
        # papuas_exc.each do |p_exc|
        #   exclude_no.push(p_exc.no)
        # end
        combined_exc = combined_exc | exclude_no
      end

      final_no = combined_inc & (all_no - combined_exc)

      papuas = papuas.in(:no => final_no)

    end

    return papuas
  end
end
