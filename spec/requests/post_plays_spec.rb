require 'rails_helper'

RSpec.describe 'Plays', type: :request do
  describe "POST #create" do
    context "with valid params" do
      let(:valid_attributes) {
        {
          play: {
            title: "Hamlet",
            start_date: "2023-05-14",
            end_date: "2023-05-28"
          }
        }
      }

      before do
        post '/api/v1/plays', params: valid_attributes
      end

      it 'returns the title' do
        expect(JSON.parse(response.body)['title']).to eq(valid_attributes[:play][:title])
      end

      it 'returns a created status' do
        expect(response).to have_http_status(:created)
      end

      it 'returns the date_range' do
        expect(JSON.parse(response.body)['date_range']).to eq((valid_attributes[:play][:start_date]..valid_attributes[:play][:end_date]).to_s)
      end
    end

    context "with wrong_range_params" do
      let(:invalid_attributes) {
        {
          play: {
            title: "Hamlet",
            start_date: "2023-05-14",
            end_date: "2023-05-12"
          }
        }
      }

      before do
        post '/api/v1/plays', params: invalid_attributes
      end

      it "returns a 422 unprocessable entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns an error message" do
        expect(response.body).to include(I18n.t('activerecord.errors.models.play.attributes.date_range.invalid_date_range'))
      end
    end

    context "with wrong_type_params" do
      let(:invalid_attributes) {
        {
          play: {
            title: "Hamlet",
            start_date: "A",
            end_date: "Z"
          }
        }
      }

      before do
        post '/api/v1/plays', params: invalid_attributes
      end

      it "returns a 422 unprocessable entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns an error message" do
        expect(response.body).to include(I18n.t('activerecord.errors.models.play.attributes.date_range.invalid_type', value_class: nil.class ))
      end
    end

    context "with overlaps_plays" do
      let(:start_date) { Date.today }
      let(:end_date) { Date.today + 3.days }
      let(:invalid_attributes) {
        {
          play: {
            title: "Hamlet",
            start_date: start_date,
            end_date: end_date
          }
        }
      }
      let!(:play1) { create(:play, date_range: start_date..end_date) }

      before do
        post '/api/v1/plays', params: invalid_attributes
      end

      it "returns a 422 unprocessable entity status" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns an error message" do
        expect(response.body).to include(I18n.t('activerecord.errors.models.play.attributes.date_range.overlaps_with_other'))
      end
    end
  end
end
