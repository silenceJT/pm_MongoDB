require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    assert_difference('Product.count') do
      post products_url, params: { product: { active: @product.active, brand: @product.brand, category: @product.category, ce: @product.ce, channel_MKT_rebate: @product.channel_MKT_rebate, channel_buy_price: @product.channel_buy_price, color: @product.color, description: @product.description, ean: @product.ean, fob_aud: @product.fob_aud, fob_usd: @product.fob_usd, margin_rate: @product.margin_rate, product_name: @product.product_name, rcm: @product.rcm, retail_price: @product.retail_price, saa: @product.saa, sps_sku: @product.sps_sku, total_profit: @product.total_profit, vender_sku: @product.vender_sku } }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: { product: { active: @product.active, brand: @product.brand, category: @product.category, ce: @product.ce, channel_MKT_rebate: @product.channel_MKT_rebate, channel_buy_price: @product.channel_buy_price, color: @product.color, description: @product.description, ean: @product.ean, fob_aud: @product.fob_aud, fob_usd: @product.fob_usd, margin_rate: @product.margin_rate, product_name: @product.product_name, rcm: @product.rcm, retail_price: @product.retail_price, saa: @product.saa, sps_sku: @product.sps_sku, total_profit: @product.total_profit, vender_sku: @product.vender_sku } }
    assert_redirected_to product_url(@product)
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end
end
