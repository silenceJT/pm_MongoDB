require "test_helper"

class PapuasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @papua = papuas(:one)
  end

  test "should get index" do
    get papuas_url
    assert_response :success
  end

  test "should get new" do
    get new_papua_url
    assert_response :success
  end

  test "should create papua" do
    assert_difference('Papua.count') do
      post papuas_url, params: { papua: { country: @papua.country, inv: @papua.inv, iso: @papua.iso, language: @papua.language, language_family: @papua.language_family, latitude: @papua.latitude, longitude: @papua.longitude } }
    end

    assert_redirected_to papua_url(Papua.last)
  end

  test "should show papua" do
    get papua_url(@papua)
    assert_response :success
  end

  test "should get edit" do
    get edit_papua_url(@papua)
    assert_response :success
  end

  test "should update papua" do
    patch papua_url(@papua), params: { papua: { country: @papua.country, inv: @papua.inv, iso: @papua.iso, language: @papua.language, language_family: @papua.language_family, latitude: @papua.latitude, longitude: @papua.longitude } }
    assert_redirected_to papua_url(@papua)
  end

  test "should destroy papua" do
    assert_difference('Papua.count', -1) do
      delete papua_url(@papua)
    end

    assert_redirected_to papuas_url
  end
end
