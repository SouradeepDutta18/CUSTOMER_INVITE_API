module Api
  module V1
    module Docs
      module Schema
        class CustomerResponseSchema
          include Swagger::Blocks

          swagger_schema :CustomerResponse do
            property :user_id do
              key :type, :integer
              key :example, 3
            end
            property :name do
              key :type, :string
              key :example, 'Amit Sharma'
            end
          end
        end
      end
    end
  end
end
