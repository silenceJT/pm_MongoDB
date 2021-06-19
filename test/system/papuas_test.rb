require "application_system_test_case"

class PapuasTest < ApplicationSystemTestCase
  setup do
    @papua = papuas(:one)
  end

  test "visiting the index" do
    visit papuas_url
    assert_selector "h1", text: "Papuas"
  end

  test "creating a Papua" do
    visit papuas_url
    click_on "New Papua"

    fill_in "Country", with: @papua.country
    fill_in "Inv", with: @papua.inv
    fill_in "Iso", with: @papua.iso
    fill_in "Language", with: @papua.language
    fill_in "Language family", with: @papua.language_family
    fill_in "Latitude", with: @papua.latitude
    fill_in "Longitude", with: @papua.longitude
    click_on "Create Papua"

    assert_text "Papua was successfully created"
    click_on "Back"
  end

  test "updating a Papua" do
    visit papuas_url
    click_on "Edit", match: :first

    fill_in "Country", with: @papua.country
    fill_in "Inv", with: @papua.inv
    fill_in "Iso", with: @papua.iso
    fill_in "Language", with: @papua.language
    fill_in "Language family", with: @papua.language_family
    fill_in "Latitude", with: @papua.latitude
    fill_in "Longitude", with: @papua.longitude
    click_on "Update Papua"

    assert_text "Papua was successfully updated"
    click_on "Back"
  end

  test "destroying a Papua" do
    visit papuas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Papua was successfully destroyed"
  end
end
