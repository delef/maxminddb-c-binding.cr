require "./src/geoip2"

GeoIP2.open "db/GeoLite2-City.mmdb"
ptr = GeoIP2.lookup("139.59.147.72").not_nil!

def print_inner!(data)
  case data.type
  when .ut_f8_string?
    puts String.new(data.data.utf8_string, data.data_size)
  end
end

def print_entry_data!(data)
  puts "HD=#{data.has_data} O=#{data.offset} ON=#{data.offset_to_next} T=#{data.type}"
  print_inner! data
end

def print_list!(ptr)
  until ptr.null?
    print_entry_data! ptr.value.entry_data
    ptr = ptr.value.next
  end
end
print_list! ptr
