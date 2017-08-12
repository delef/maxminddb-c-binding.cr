require "./src/geoip2"

db = GeoIP2.open "db/GeoLite2-City.mmdb"
res = db.lookup("37.110.3.102")

pp res.city
