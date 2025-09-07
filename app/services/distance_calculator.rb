# app/services/distance_calculator.rb
class DistanceCalculator
  EARTH_RADIUS_KM = 6371.0

  def self.haversine(lat1, lon1, lat2, lon2)
    lat1_rad = to_rad(lat1)
    lon1_rad = to_rad(lon1)
    lat2_rad = to_rad(lat2)
    lon2_rad = to_rad(lon2)

    dlat = lat2_rad - lat1_rad
    dlon = lon2_rad - lon1_rad

    a = Math.sin(dlat / 2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon / 2)**2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    (EARTH_RADIUS_KM * c).round(2)
  end

  def self.to_rad(deg)
    deg * Math::PI / 180
  end
end
