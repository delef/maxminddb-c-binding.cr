require "./src/geoip2"

class Test
  def initialize
    @result = {names: [] of String, cities: {} of String => String}
  end

  def inner(data)
    case data.type
    when .ut_f8_string?
      String.new(data.data.utf8_string, data.data_size)
    end
  end

  def entry_data(item)
    return unless item.has_data?

    case item.type
    when GeoIP2::LibMMDB::DataType::MAP
      # raise item.inspect
    when GeoIP2::LibMMDB::DataType::UTF8_STRING
      @result[:names].push inner(item).as(String)
    end

    raise @result.inspect

    puts "HD=#{item.has_data} O=#{item.offset} ON=#{item.offset_to_next} T=#{item.type} I=#{inner(item)}"
  end

  def check(status)
    raise "status" if status != 0
  end

  def list(entry)
    check GeoIP2::LibMMDB.get_entry_data_list(pointerof(entry), out entry_data_list)
    begin
      current = entry_data_list
      while !current.null?
        case current.value.entry_data.type
        when .map?
          puts "Map"
        when .utf8string?
          puts String.new current.value.entry_data.data.utf8_string, current.value.entry_data.data_size
        end
        current = current.value.next
      end
    ensure
      GeoIP2::LibMMDB.free_entry_data_list entry_data_list
    end
  end
end

db = GeoIP2.open "db/GeoLite2-City.mmdb"

res = db.lookup("139.59.0.0")

Test.new.list(res.entry)
