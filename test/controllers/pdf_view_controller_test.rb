require "test_helper"

class PdfViewControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pdf_view_index_url
    assert_response :success
  end
end
