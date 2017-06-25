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
    return unless item.has_data

    case item.type
    when GeoIP2::LibMMDB::DataType::MAP
      # raise item.inspect
    when GeoIP2::LibMMDB::DataType::UTF8_STRING
      @result[:names].push inner(item).as(String)
    end

    raise @result.inspect

    puts "HD=#{item.has_data} O=#{item.offset} ON=#{item.offset_to_next} T=#{item.type} I=#{inner(item)}"
  end

  def list(ptr)
    until ptr.null?
      entry_data(ptr.value.entry_data)
      ptr = ptr.value.next
    end
  end
end

GeoIP2.open "db/GeoLite2-City.mmdb"
ptr = GeoIP2.lookup("139.59.0.0").not_nil!

Test.new.list(ptr)
