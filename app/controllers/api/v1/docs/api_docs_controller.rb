module Api
  module V1
    module Docs
      class ApiDocsController < ActionController::API
        include Swagger::Blocks

        swagger_root do
          key :swagger, '2.0'
          info do
            key :version, '1.0.0'
            key :title, 'Customer Invitation API'
            key :description, 'API to filter customers within 100km of Mumbai office'
          end
          key :host, 'localhost:3000'
          key :basePath, '/api/v1'
          key :consumes, ['application/json', 'multipart/form-data']
          key :produces, ['application/json']

          # Security definition for API key
          security_definition :api_key do
            key :type, :apiKey
            key :name, 'X-API-KEY'
            key :in, :header
          end
        end

        SWAGGERED_CLASSES = [
          Api::V1::Docs::CustomersDocController,
          Api::V1::Docs::Schema::CustomerResponseSchema,
          self
        ].freeze

        # GET /api/v1/docs/swagger.json
        def index
          render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
        end
      end
    end
  end
end
