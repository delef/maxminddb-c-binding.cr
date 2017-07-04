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
        current = entry_data_list
        result = {names: [] of String, cities: [] of String}

        entry_data_list, result = convert(entry_data_list)

        pp result

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

    alias MapValue = Nil | Bool | UInt16 | Int32 | UInt32 | Float32 | Float64 | String | Hash(MapValue, MapValue) | Array(MapValue)
    private def convert(current)
      return {current, nil} if current.null?
      entry = current.value.entry_data
      case entry.type
      when .map?
<<<<<<< HEAD
        while !current.null?
          next unless current.value.entry_data.data.utf8_string.null?
          
          result.push String.new(current.value.entry_data.data.utf8_string, current.value.entry_data.data_size)
          
          current = current.value.next
=======
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
>>>>>>> 5a268030e2a14438dfe8386b15386157c746ec1a
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
