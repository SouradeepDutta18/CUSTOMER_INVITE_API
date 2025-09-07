# spec/controllers/api/v1/customers_controller_spec.rb
require 'rails_helper'

describe Api::V1::CustomersController, type: :controller do
  let(:active_user) do
    User.create!(
      name: 'Active User',
      email: 'active@example.com',
      api_key: 'valid_key',
      expires_at: 1.day.from_now
    )
  end

  let(:expired_user) do
    User.create!(
      name: 'Expired User',
      email: 'expired@example.com',
      api_key: 'expired_key',
      expires_at: 1.day.ago
    )
  end

  describe 'POST #invite' do
    it 'returns 401 if no API key provided' do
      post :invite
      expect(response).to have_http_status(:unauthorized)
      expect(parsed_response).to eq({ 'error' => 'Unauthorized' })
    end

    it 'returns 401 if expired API key provided' do
      request.headers['X-API-KEY'] = expired_user.api_key
      post :invite
      expect(response).to have_http_status(:unauthorized)
      expect(parsed_response).to eq({ 'error' => 'Invalid or expired API key' })
    end

    it 'returns 400 if no file uploaded' do
      request.headers['X-API-KEY'] = active_user.api_key
      post :invite
      expect(response).to have_http_status(:bad_request)
      expect(parsed_response).to eq({ 'error' => 'No file uploaded' })
    end

    it 'filters customers within 100 km of Mumbai using Tempfile' do
      request.headers['X-API-KEY'] = active_user.api_key

      file = Tempfile.new(['customers', '.json'])
      customers_data = [
        { user_id: 1, name: 'Near Mumbai', latitude: 19.0, longitude: 72.7 }, # inside range
        { user_id: 2, name: 'Far Away 1', latitude: -68.850431, longitude: -35.814792 }, # outside
        { user_id: 3, name: 'Far Away 2', latitude: 82.784317, longitude: -11.291294 }  # outside
      ]

      customers_data.each { |row| file.puts(row.to_json) }
      file.rewind

      post :invite, params: { file: fixture_file_upload(file.path, 'application/json') }

      expect(response).to have_http_status(:ok)
      expect(parsed_response).to eq([{ 'user_id' => 1, 'name' => 'Near Mumbai' }])

      file.close
      file.unlink
    end
  end

  private

  def parsed_response
    JSON.parse(response.body)
  end
end
