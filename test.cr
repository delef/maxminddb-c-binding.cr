require "./src/geoip2"

db = GeoIP2.open "db/GeoLite2-City.mmdb"
res = db.lookup("139.59.0.0")

raise res.inspect
