require "./geoip2/*"

module GeoIP2
  @@mmdb : LibMMDB::S?

  def self.open(file, mode : Symbol = :mmap)
    open_mode = mode == :mask ? MODE_MASK : MODE_MMAP
    status = LibMMDB.open(file, open_mode, out mmdb)
    @@mmdb = mmdb
    
    raise open_error(status) if status != SUCCESS
  end

  def self.lookup(ip)
    result = LibMMDB.lookup_string(pointerof(@@mmdb.not_nil!), ip, out gai_error, out mmdb_error)

    raise "gai error" if gai_error != 0
    result
  end
end