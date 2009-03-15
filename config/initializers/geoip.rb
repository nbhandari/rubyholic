GeoIPClient = GeoIP.new(
  File.join(RAILS_ROOT, 'vendor', 'geoip', 'GeoLiteCity.dat')
)