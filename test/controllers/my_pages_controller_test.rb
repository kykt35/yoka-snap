require "test_helper"

class MyPagesControllerTest < ActionDispatch::IntegrationTest
  test "requires login" do
    get my_page_path

    assert_redirected_to new_session_path
  end

  test "shows current user's posts and saved posts" do
    sign_in_as users(:two)

    get my_page_path

    assert_response :success
    assert_includes response.body, users(:two).name
    assert_includes response.body, posts(:published).title
    assert_not_includes response.body, posts(:hidden).title
  end
end
