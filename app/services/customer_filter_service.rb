# CustomerFilterService reads a customers.txt file (JSON lines format),
# and filters customers located within 100 km of the Mumbai office.

# Optimization: Instead of running the expensive Haversine formula for
# every customer, we first check whether the customer falls inside a
# precomputed "bounding box" around Mumbai. The bounding box is a rectangle
# that fully contains the 100 km radius circle.

# If a customer is outside the bounding box, they are guaranteed to be
# more than 100 km away and can be rejected immediately.
class CustomerFilterService
  MUMBAI_LAT = 19.0590317
  MUMBAI_LON = 72.7553452
  DISTANCE_LIMIT_KM = 100

  # Step 1: Calculate degree offsets that correspond to 100 km.
  # 1 degree latitude ≈ 111 km everywhere on Earth.
  KM_PER_DEG_LAT = 111.0
  # 1 degree longitude depends on latitude.
  KM_PER_DEG_LON = 111.0 * Math.cos(MUMBAI_LAT * Math::PI / 180)

  LAT_DELTA = DISTANCE_LIMIT_KM / KM_PER_DEG_LAT
  LON_DELTA = DISTANCE_LIMIT_KM / KM_PER_DEG_LON

  # Step 2: Build bounding box around Mumbai office.
  LAT_MIN = MUMBAI_LAT - LAT_DELTA
  LAT_MAX = MUMBAI_LAT + LAT_DELTA
  LON_MIN = MUMBAI_LON - LON_DELTA
  LON_MAX = MUMBAI_LON + LON_DELTA

  def self.call(file)
    customers = []

    file.read.each_line do |line|
      data = JSON.parse(line)
      lat = data['latitude'].to_f
      lon = data['longitude'].to_f

      # Step 3: Reject customers outside bounding box.
      # If their latitude or longitude is outside these ranges,
      # they cannot be within 100 km of Mumbai.
      next unless lat.between?(LAT_MIN, LAT_MAX) && lon.between?(LON_MIN, LON_MAX)

      # Step 4: For remaining candidates, compute accurate distance.
      distance = DistanceCalculator.haversine(MUMBAI_LAT, MUMBAI_LON, lat, lon)

      if distance <= DISTANCE_LIMIT_KM
        customers << { user_id: data['user_id'], name: data['name'] }
      end
    end

    # Return sorted list by user_id
    customers.sort_by { |c| c[:user_id] }
  end
end
