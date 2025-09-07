# app/controllers/api/v1/docs/customers_doc_controller.rb
module Api
  module V1
    module Docs
      class CustomersDocController < ApplicationController
        include Swagger::Blocks

        swagger_path '/customers/invite' do
          operation :post do
            key :summary, 'Invite customers near Mumbai'
            key :description, 'Upload a JSON lines file and filter customers within 100km of Mumbai'
            key :operationId, 'inviteCustomers'
            key :produces, ['application/json']
            key :tags, ['Customers']

            # Header parameter for API key
            parameter name: 'X-API-KEY' do
              key :in, :header
              key :description, 'API key for authentication'
              key :required, true
              key :type, :string
            end

            # File parameter
            parameter name: :file do
              key :in, :formData
              key :description, 'Customers file (JSON lines: one per line with user_id, name, latitude, longitude)'
              key :required, true
              key :type, :file
            end

            # Successful response
            response 200 do
              key :description, 'Filtered customers'
              schema do
                key :type, :array
                items do
                  key :'$ref', :CustomerResponse
                end
              end
            end

            # Unauthorized
            response 401 do
              key :description, 'Unauthorized'
              schema type: :object do
                property :error do
                  key :type, :string
                  key :example, 'Unauthorized'
                end
                property :code do
                  key :type, :integer
                  key :example, 401
                end
              end
            end

            # Rate limit exceeded
            response 429 do
              key :description, 'Rate limit exceeded'
              schema type: :object do
                property :error do
                  key :type, :string
                  key :example, 'Too Many Requests'
                end
                property :code do
                  key :type, :integer
                  key :example, 429
                end
              end
            end

            # Bad request (missing file)
            response 400 do
              key :description, 'Bad request'
              schema type: :object do
                property :error do
                  key :type, :string
                  key :example, 'Bad Request'
                end
                property :code do
                  key :type, :integer
                  key :example, 400
                end
              end
            end
          end
        end
      end
    end
  end
end
