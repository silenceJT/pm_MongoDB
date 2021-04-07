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
end
