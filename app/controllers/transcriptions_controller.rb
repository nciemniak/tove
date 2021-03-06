class TranscriptionsController < ApplicationController
  include JSONAPI::Deserialization

  def index
    @transcriptions = Transcription.all
    jsonapi_render(@transcriptions, allowed_filters)
  end

  def update
    @transcription = Transcription.find(params[:id])
    raise ActionController::BadRequest if type_invalid?
    @transcription.update!(update_attrs)
    render jsonapi: @transcription
  end

  def show
    @transcription = Transcription.find(params[:id])
    render jsonapi: @transcription
  end

  private

  def update_attrs
    jsonapi_deserialize(params)
  end

  def type_invalid?
    params[:data][:type] != "transcriptions"
  end

  def allowed_filters
    [:id, :subject_id, :workflow_id, :group_id, :flagged]
  end
end
