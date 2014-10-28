module Dimelo::CCP
  module API
    module Common
      module Starrable

        def star! #use method name with bang to differenciate from #star attribute
          path = "#{compute_path(attributes)}/star"
          response = client.transport(:put, path)
          self.attributes = Dimelo::CCP::API.decode_json(response)
          errors.empty?
        end

        def unstar!
          path = "#{compute_path(attributes)}/unstar"
          response = client.transport(:put, path)
          self.attributes = Dimelo::CCP::API.decode_json(response)
          errors.empty?
        end

      end
    end
  end
end
