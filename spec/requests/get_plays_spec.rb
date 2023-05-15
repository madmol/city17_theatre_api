require 'rails_helper'

RSpec.describe 'Plays', type: :request do
  describe "GET #index" do
    before do
      FactoryBot.create_list(:play, 10)
      get '/api/v1/plays'
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "returns a list of all plays" do
      expect(JSON.parse(response.body).size).to eq(10)
    end
  end
end
