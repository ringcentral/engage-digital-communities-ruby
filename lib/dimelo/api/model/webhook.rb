module Dimelo
  class Webhook < Dimelo::API::Model

    attributes :id, :endpoint_enabled, :endpoint_url, :preprod_settings, :verify_token
    attributes :answer__destroyed, :question__destroyed, :identity__destroyed, :comment__destroyed, :feedback__destroyed, :status_comment__destroyed

    submit_attributes :id, :endpoint_enabled, :endpoint_url, :preprod_settings, :verify_token, :answer__destroyed, :question__destroyed, :identity__destroyed, :comment__destroyed, :feedback__destroyed, :status_comment__destroyed
  end
end
