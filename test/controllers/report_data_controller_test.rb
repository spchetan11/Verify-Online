require 'test_helper'

class ReportDataControllerTest < ActionController::TestCase
  setup do
    @report_datum = report_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:report_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create report_datum" do
    assert_difference('ReportDatum.count') do
      post :create, report_datum: { body: @report_datum.body, college_id: @report_datum.college_id, designation: @report_datum.designation, from_address: @report_datum.from_address, header: @report_datum.header, letter_title: @report_datum.letter_title, signature: @report_datum.signature, subject: @report_datum.subject, to_address: @report_datum.to_address }
    end

    assert_redirected_to report_datum_path(assigns(:report_datum))
  end

  test "should show report_datum" do
    get :show, id: @report_datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @report_datum
    assert_response :success
  end

  test "should update report_datum" do
    patch :update, id: @report_datum, report_datum: { body: @report_datum.body, college_id: @report_datum.college_id, designation: @report_datum.designation, from_address: @report_datum.from_address, header: @report_datum.header, letter_title: @report_datum.letter_title, signature: @report_datum.signature, subject: @report_datum.subject, to_address: @report_datum.to_address }
    assert_redirected_to report_datum_path(assigns(:report_datum))
  end

  test "should destroy report_datum" do
    assert_difference('ReportDatum.count', -1) do
      delete :destroy, id: @report_datum
    end

    assert_redirected_to report_data_path
  end
end
