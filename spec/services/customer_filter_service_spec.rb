# spec/services/customer_filter_service_spec.rb
require 'rails_helper'

describe CustomerFilterService do
  let(:file) do
    StringIO.new([
      { user_id: 1, name: 'Close User', latitude: '19.05', longitude: '72.75' },
      { user_id: 2, name: 'Far User', latitude: '25.0', longitude: '80.0' },
      { user_id: 3, name: 'Edge User', latitude: '19.95', longitude: '72.755' }
    ].map(&:to_json).join("\n"))
  end

  describe '.call' do
    it 'returns only customers within 100km of Mumbai' do
      result = CustomerFilterService.call(file)
      expect(result.map { |c| c[:user_id] }).to match_array([1, 3])
    end

    it 'returns customers sorted by user_id' do
      result = CustomerFilterService.call(file)
      expect(result.map { |c| c[:user_id] }).to eq([1, 3])
    end
  end
end
