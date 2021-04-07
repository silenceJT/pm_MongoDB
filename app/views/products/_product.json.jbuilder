json.extract! product, :id, :brand, :category, :product_name, :color, :ean, :vender_sku, :sps_sku, :description, :fob_usd, :fob_aud, :margin_rate, :total_profit, :retail_price, :channel_buy_price, :channel_MKT_rebate, :saa, :rcm, :ce, :active, :created_at, :updated_at
json.url product_url(product, format: :json)
