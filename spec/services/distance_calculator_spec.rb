# spec/services/distance_calculator_spec.rb
require 'rails_helper'

describe DistanceCalculator do
  describe '.haversine' do
    it 'calculates distance between two points' do
      mumbai_lat, mumbai_lon = 19.0590317, 72.7553452
      pune_lat, pune_lon = 18.5204, 73.8567
      distance = DistanceCalculator.haversine(mumbai_lat, mumbai_lon, pune_lat, pune_lon)
      expect(distance).to eq(130.49)
    end
  end
end
