require 'rails_helper'

RSpec.describe 'Plays', type: :request do
  describe "DELETE #destroy" do
      let(:start_date) { Date.today }
      let(:end_date) { Date.today + 3.days }
      let!(:play1) { create(:play, date_range: start_date..end_date) }


    before do
      delete "/api/v1/plays/#{play1.id}"
    end

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
