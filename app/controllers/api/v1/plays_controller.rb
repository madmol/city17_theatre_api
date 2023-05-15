class Api::V1::PlaysController < ApplicationController
  before_action :set_play, only: [:destroy]

  resource_description do
    name 'Plays'
    short 'API endpoints for managing plays'
    description 'This resource allows you to manage plays.'
  end

  api :GET, '/api/v1/plays', 'Get a list of plays'
  description 'Returns a list of all plays.'
  formats ['json']

  def index
    @plays = Play.all
    render json: @plays
  end

  api :POST, '/api/v1/plays', 'Create a new play'
  description <<-EOS
    Creates a new play with the specified parameters.

    Params:
      * title (string) - The title of the play.
      * start_date (string) - The start date of the play in the format "YYYY-MM-DD".
      * end_date (string) - The end date of the play in the format "YYYY-MM-DD".

    Returns:
      * id (integer) - The ID of the newly created play.
      * title (string) - The title of the play.
      * date_range (Range) - The start date of the play in the format "YYYY-MM-DD".

    Errors:
      * 422 Unprocessable Entity: if the play could not be created

    Example:

    POST /api/v1/plays
    {
      "play": {
        "title": "Hamlet",
        "start_date": "2023-05-14",
        "end_date": "2023-05-28"
      }
    }

    Response:
    {
      "id": 1,
      "title": "Hamlet",
      "date_range": "2023-05-14..2023-05-28"
    }
  EOS
  error code: 422, desc: 'Invalid date format'
  formats ['json']
  param :play, Hash, desc: 'Play attributes', required: true do
    param :title, String, desc: 'Title of the play'
    param :start_date, String, desc: 'Start date of the play in the format "YYYY-MM-DD"'
    param :end_date, String, desc: 'End date of the play in the format "YYYY-MM-DD"'
  end

  def create
    begin
      @play = Play.new(play_params)
    rescue ArgumentError => e
      render json: { error: e.message }, status: :unprocessable_entity
      return
    end

    if @play.save
      render json: @play, status: :created
    else
      render json: @play.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/api/v1/plays/:id', 'Delete a play'
  description 'Deletes a play with the specified ID.'
  param :id, String, desc: 'ID of the play to delete', required: true

  def destroy
    @play.destroy
    head :no_content
  end

  private

  def set_play
    @play = Play.find(params[:id])
  end

  def play_params
    params.require(:play).permit(:title, :start_date, :end_date).tap do |whitelisted|
      start_date = Date.parse(whitelisted.delete(:start_date)) rescue nil
      end_date = Date.parse(whitelisted.delete(:end_date)) rescue nil
      if start_date.present? && end_date.present?
        whitelisted[:date_range] = (start_date..end_date)
      else
        whitelisted[:date_range] = nil
      end
    end
  end
end
