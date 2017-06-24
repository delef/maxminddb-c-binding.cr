require "./geoip2/*"

module GeoIP2
  @@mmdb = uninitialized LibMMDB::S

  def self.open(file, mode : Symbol = :mmap)
    open_mode = mode == :mask ? MODE_MASK : MODE_MMAP
    status = LibMMDB.open(file, open_mode, out mmdb)
    @@mmdb = mmdb
    
    raise open_error(status) if status != SUCCESS
  end

  def self.lookup(ip_address)
    gai_error = uninitialized LibC::Int
    mmdb_error = uninitialized LibC::Int
    data_list = uninitialized LibMMDB::EntryDataListS*

    result = LibMMDB.lookup_string(
      pointerof(@@mmdb),
      ip_address,
      pointerof(gai_error),
      pointerof(mmdb_error)
    )

    raise "Error from getaddrinfo" if gai_error != SUCCESS
    raise open_error(mmdb_error) if mmdb_error != SUCCESS

    if result.found_entry
      entry = result.entry

      status = LibMMDB.get_entry_data_list(
        pointerof(entry),
        pointerof(data_list)
      )

      if status == SUCCESS
        data_list
      else
        nil
      end
    else
      raise "No entry for this IP address (#{ip_address}) was found"
    end
  end
end