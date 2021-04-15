class Product
  include Mongoid::Document
  store_in collection: "Product", database: "SPS"
  field :brand, type: String
  field :category, type: String
  field :product_name, type: String
  field :color, type: String
  field :ean, type: String
  field :vender_sku, type: String
  field :sps_sku, type: String
  field :description, type: String
  field :fob_usd, type: Float
  field :fob_aud, type: Float
  field :margin_rate, type: Float
  field :total_profit, type: Float
  field :retail_price, type: Float
  field :channel_buy_price_egst, type: Float
  field :channel_mkt_rebate_egst, type: Float
  field :saa, type: Mongoid::Boolean
  field :rcm, type: Mongoid::Boolean
  field :ce, type: Mongoid::Boolean
  field :active, type: Mongoid::Boolean


  validates :brand, :category, :product_name, :description, :retail_price, :active, presence: true
  validates :description, length: { maximum: 1000, too_long: "%{count} characters is the maximum alowed. " }
  validates :product_name, length: { maximum: 140, too_long: "%{count} characters is the maximum alowed. " }
  validates :fob_usd, :fob_aud, :retail_price, numericality: { only_integer: false }, length: { maximum: 7 }

  CATEGORY = %w{ Accessories Air-condition Alarm AP Battery Blind Bracket Bulb Camera Case Charger Cloud Controller 
    Doorbell e-bike Extra_Battery Garage_Sensor Gateway Home_Kit Hub Indoor_Camera Lamp Light Lock Mesh Mirror 
    Mosquito_Killer Motor Nest_Hub Nightlight NVR Outdoor_Battery Plug Projector Rack RoboVac Router Scale Scooter 
    SD Sensor Sensor_Nightlight Service Solar_Panel Speaker Stand Switch Tem_Sensor TMM Toy Watch }

  BRAND = %w{ A-OK Aqara Ebo Ecoflow ESS Eufy Ezviz GIMI Google HikVision HOLACA imoo IP-COM Konke 
    LifeSmart MEGVII realme Sonoff SP Tenda Terncy TLI TP-LINK Tronic Tuya Whill Wulian Xiaomi Yeelight Yio }



end
