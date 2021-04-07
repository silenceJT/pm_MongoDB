require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
  setup do
    @product = products(:one)
  end

  test "visiting the index" do
    visit products_url
    assert_selector "h1", text: "Products"
  end

  test "creating a Product" do
    visit products_url
    click_on "New Product"

    check "Active" if @product.active
    fill_in "Brand", with: @product.brand
    fill_in "Category", with: @product.category
    check "Ce" if @product.ce
    fill_in "Channel mkt rebate", with: @product.channel_MKT_rebate
    fill_in "Channel buy price", with: @product.channel_buy_price
    fill_in "Color", with: @product.color
    fill_in "Description", with: @product.description
    fill_in "Ean", with: @product.ean
    fill_in "Fob aud", with: @product.fob_aud
    fill_in "Fob usd", with: @product.fob_usd
    fill_in "Margin rate", with: @product.margin_rate
    fill_in "Product name", with: @product.product_name
    check "Rcm" if @product.rcm
    fill_in "Retail price", with: @product.retail_price
    check "Saa" if @product.saa
    fill_in "Sps sku", with: @product.sps_sku
    fill_in "Total profit", with: @product.total_profit
    fill_in "Vender sku", with: @product.vender_sku
    click_on "Create Product"

    assert_text "Product was successfully created"
    click_on "Back"
  end

  test "updating a Product" do
    visit products_url
    click_on "Edit", match: :first

    check "Active" if @product.active
    fill_in "Brand", with: @product.brand
    fill_in "Category", with: @product.category
    check "Ce" if @product.ce
    fill_in "Channel mkt rebate", with: @product.channel_MKT_rebate
    fill_in "Channel buy price", with: @product.channel_buy_price
    fill_in "Color", with: @product.color
    fill_in "Description", with: @product.description
    fill_in "Ean", with: @product.ean
    fill_in "Fob aud", with: @product.fob_aud
    fill_in "Fob usd", with: @product.fob_usd
    fill_in "Margin rate", with: @product.margin_rate
    fill_in "Product name", with: @product.product_name
    check "Rcm" if @product.rcm
    fill_in "Retail price", with: @product.retail_price
    check "Saa" if @product.saa
    fill_in "Sps sku", with: @product.sps_sku
    fill_in "Total profit", with: @product.total_profit
    fill_in "Vender sku", with: @product.vender_sku
    click_on "Update Product"

    assert_text "Product was successfully updated"
    click_on "Back"
  end

  test "destroying a Product" do
    visit products_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Product was successfully destroyed"
  end
end
