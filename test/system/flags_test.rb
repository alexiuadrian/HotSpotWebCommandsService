require "application_system_test_case"

class FlagsTest < ApplicationSystemTestCase
  setup do
    @flag = flags(:one)
  end

  test "visiting the index" do
    visit flags_url
    assert_selector "h1", text: "Flags"
  end

  test "should create flag" do
    visit flags_url
    click_on "New flag"

    fill_in "Name", with: @flag.name
    fill_in "Value", with: @flag.value
    click_on "Create Flag"

    assert_text "Flag was successfully created"
    click_on "Back"
  end

  test "should update Flag" do
    visit flag_url(@flag)
    click_on "Edit this flag", match: :first

    fill_in "Name", with: @flag.name
    fill_in "Value", with: @flag.value
    click_on "Update Flag"

    assert_text "Flag was successfully updated"
    click_on "Back"
  end

  test "should destroy Flag" do
    visit flag_url(@flag)
    click_on "Destroy this flag", match: :first

    assert_text "Flag was successfully destroyed"
  end
end
