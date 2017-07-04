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
        pointerof(gai_error),
        pointerof(mmdb_error)
      )

      raise String.new LibC.gai_strerror(gai_error) unless gai_error == SUCCESS

      check mmdb_error
      list result.entry
    end

    private def list(entry)
      check GeoIP2::LibMMDB.get_entry_data_list(pointerof(entry), out entry_data_list)

      begin
        entry_data_list, result = convert(entry_data_list)
        
        Result.new(result.as(Hash(MapValue, MapValue)))
      ensure
        GeoIP2::LibMMDB.free_entry_data_list(entry_data_list)
      end
    end

    alias MapValue = Nil | Bool | UInt16 | Int32 | UInt32 | Float32 | Float64 | String | Hash(MapValue, MapValue) | Array(MapValue)
    private def convert(current)
      return {current, nil} if current.null?
      
      entry = current.value.entry_data

      case entry.type
      when .map?
        mapping = Hash(MapValue, MapValue).new(initial_capacity: entry.data_size)
        current = current.value.next

        entry.data_size.times do
          current, key = convert(current)
          current, val = convert(current)
          mapping[key] = val
        end

        {current, mapping}
      when .array?
        array = Array(MapValue).new(entry.data_size)
        current = current.value.next

        entry.data_size.times do
          current, val = convert(current)
          array << val
        end

        {current, array}
      when .uint16?
        uint16 = entry.data.uint16
        current = current.value.next

        {current, uint16}
      when .uint32?
        uint32 = entry.data.uint32
        current = current.value.next

        {current, uint32}
      when .int32?
        int32 = entry.data.int32
        current = current.value.next

        {current, int32}
      when .boolean?
        boolean = entry.data.boolean
        current = current.value.next

        {current, boolean}
      when .float?
        float_value = entry.data.float_value
        current = current.value.next

        {current, float_value}
      when .double?
        double_value = entry.data.double_value
        current = current.value.next

        {current, double_value}
      when .utf8string?
        str = String.new(entry.data.utf8_string, entry.data_size)
        current = current.value.next

        {current, str}
      else
        current = current.value.next
        {current, nil}
      end
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
