module Dimelo::CCP
  module API
    module Common
      module Openable

        def open
          path = "#{compute_path(attributes)}/open"
          response = client.transport(:put, path)
          self.attributes = Dimelo::CCP::API.decode_json(response)
          errors.empty?
        end

        def close
          path = "#{compute_path(attributes)}/close"
          response = client.transport(:put, path)
          self.attributes = Dimelo::CCP::API.decode_json(response)
          errors.empty?
        end

      end
    end
  end
end
