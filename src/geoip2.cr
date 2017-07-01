require "./geoip2/*"

module GeoIP2
  class Database
    @db : LibMMDB::MMDB

    def initialize(file, open_mode)
      check LibMMDB.open(file.to_s, open_mode.to_u32, out @db)
    end

    def finalize
      LibMMDB.close(handle)
    end

    def lookup(ipstr : String)
      gai_error = 0i32
      mmdb_error = 0i32
      result = LibMMDB.lookup_string(handle, ipstr, pointerof(gai_error).as(Pointer(Int8)), pointerof(mmdb_error).as(Pointer(Int8)))
      if gai_error != 0
        raise String.new LibC.gai_strerror(gai_error)
      end
      check mmdb_error
      result
    end

    private def handle
      pointerof(@db)
    end

    private def check(status)
      return if status == 0
      raise String.new LibMMDB.strerror status.to_u32
    end
  end

  def self.open(file : String, mode : Symbol = :mmap)
    open_mode = mode == :mask ? MODE_MASK : MODE_MMAP
    Database.new(file, open_mode)
  end
end
