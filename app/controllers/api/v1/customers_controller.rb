# app/controllers/api/v1/customers_controller.rb
module Api
  module V1
    class CustomersController < ApplicationController
      def invite
        file = params[:file]

        return render json: { error: 'No file uploaded' }, status: :bad_request unless file

        begin
          filtered_customers = CustomerFilterService.call(file)
          render json: filtered_customers
        rescue StandardError => e
          Rails.logger.error("CustomerFilterService error: #{e.message}")
          render json: { error: 'Unable to process file' }, status: :unprocessable_entity
        end
      end
    end
  end
end
