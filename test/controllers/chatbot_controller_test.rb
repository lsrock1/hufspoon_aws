require 'test_helper'

class ChatbotControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "keyboard init" do
    get :keyboard
    json = JSON.parse(@response.body)
    
    assert_equal "Select Language", json["buttons"][0], "챗봇 키보드 초기화 타입 이상"
    assert_equal "buttons", json["type"], "챗봇 키보드 초기화 언어 선택 버튼 이상"
    assert_equal "Today Menu!", json["buttons"][1], "챗봇 키보드 초기화 오늘 메뉴 버튼 이상"
  end
end
