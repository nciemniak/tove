module ErrorExtender
  extend ActiveSupport::Concern
  include JSONAPI::Errors

  included do
    rescue_from ActionController::BadRequest, with: :render_jsonapi_bad_request
    rescue_from ActiveModel::UnknownAttributeError, with: :render_jsonapi_unknown_attribute
  end

  def render_jsonapi_bad_request(exception)
    error = { status: '400', title: Rack::Utils::HTTP_STATUS_CODES[400] }
    render jsonapi_errors: [error], status: :bad_request
  end

  def render_jsonapi_unknown_attribute(exception)
    error = {
      status: '422',
      title: Rack::Utils::HTTP_STATUS_CODES[422],
      detail: exception.to_param
    }

    render jsonapi_errors: [error], status: :unprocessable_entity
  end
end
