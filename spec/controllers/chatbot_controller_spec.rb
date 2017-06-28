require 'rails_helper'

RSpec.describe ChatbotController, type: :controller do
  before :all do
    @dummy = {
      user_key: "one"
    }
    
    @keyboard = {
      type: "buttons",
      buttons: ["Choose Language", "Today Menu!"]
    }.to_json
  end

  describe "#keyboard" do
    context "first connection" do
      it "keyboard initializing" do
        get :keyboard, format: :json
        expect(response.body).to eq @keyboard 
      end
    end
  end
  
  describe "#message" do
    context "without choosing language" do
      it "click menu" do
        @dummy[:content] = "Today Menu!"
        post :message, @dummy, format: :json
        expect(JSON.parse(response.body)["message"]["text"]).to eq("Please choose a language first!")
      end
    end
  end
end
