require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "visiting the index" do
    visit users_url
    assert_selector "h1", text: "Users"
  end

  test "should create user" do
    visit users_url
    click_on "New user"

    fill_in "Birthday", with: @user.birthday
    fill_in "Cellphone", with: @user.cellphone
    fill_in "Email", with: @user.email
    fill_in "Gender", with: @user.gender
    fill_in "Location", with: @user.location
    fill_in "Name", with: @user.name
    fill_in "Naturalization", with: @user.naturalization
    fill_in "Phone", with: @user.phone
    fill_in "Picture", with: @user.picture
    fill_in "Registered", with: @user.registered
    click_on "Create User"

    assert_text "User was successfully created"
    click_on "Back"
  end

  test "should update User" do
    visit user_url(@user)
    click_on "Edit this user", match: :first

    fill_in "Birthday", with: @user.birthday
    fill_in "Cellphone", with: @user.cellphone
    fill_in "Email", with: @user.email
    fill_in "Gender", with: @user.gender
    fill_in "Location", with: @user.location
    fill_in "Name", with: @user.name
    fill_in "Naturalization", with: @user.naturalization
    fill_in "Phone", with: @user.phone
    fill_in "Picture", with: @user.picture
    fill_in "Registered", with: @user.registered
    click_on "Update User"

    assert_text "User was successfully updated"
    click_on "Back"
  end

  test "should destroy User" do
    visit user_url(@user)
    click_on "Destroy this user", match: :first

    assert_text "User was successfully destroyed"
  end
end
