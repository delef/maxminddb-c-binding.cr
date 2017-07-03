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

      result = LibMMDB.lookup_string(
        handle,
        ipstr,
        pointerof(gai_error).as(Pointer(Int8)),
        pointerof(mmdb_error).as(Pointer(Int8))
      )

      raise String.new LibC.gai_strerror(gai_error) unless gai_error == SUCCESS

      check mmdb_error
      list result.entry
    end

    private def list(entry)
      check GeoIP2::LibMMDB.get_entry_data_list(pointerof(entry), out entry_data_list)

      begin
        current = entry_data_list
        result = {names: [] of String, cities: [] of String}

        convert(entry_data_list)

        # while !current.null?
        #   case current.value.entry_data.type
        #   when .map?
        #     puts "Map - 1"
        #   when .utf8string?
        #     puts "Value - 2"
        #     puts String.new(current.value.entry_data.data.utf8_string, current.value.entry_data.data_size)
        #   end
          
        #   current = current.value.next
        # end
      ensure
        GeoIP2::LibMMDB.free_entry_data_list(entry_data_list)
      end
    end

    private def convert(entry_data_list)
      return nil if entry_data_list.null?

      current = entry_data_list
      result = [] of String

      case current.value.entry_data.type
      when .map?
        while !current.null?
          next unless current.value.entry_data.data.utf8_string.null?
          
          result.push String.new(current.value.entry_data.data.utf8_string, current.value.entry_data.data_size)
          
          current = current.value.next
        end
      when .utf8string?

      else
        nil
      end

      raise result.inspect
    end

    private def handle
      pointerof(@db)
    end

    private def check(status)
      return if status == SUCCESS
      raise String.new LibMMDB.strerror(status.to_u32)
    end
  end

  def self.open(file : String, mode : Symbol = :mmap)
    open_mode = mode == :mask ? MODE_MASK : MODE_MMAP
    Database.new(file, open_mode)
  end
end
