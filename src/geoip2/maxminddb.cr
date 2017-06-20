require "./types"

module GeoIP2
  @[Link("libmaxminddb")]
  lib LibMMDB
    fun open = MMDB_open(
      filename : LibC::Char*,
      flags : Uint32T,
      mmdb : S*
    ) : LibC::Int

    fun lookup_string = MMDB_lookup_string(
      mmdb : S*,
      ipstr : LibC::Char*,
      gai_error : LibC::Int*,
      mmdb_error : LibC::Int*
    ) : LookupResultS

    fun lookup_sockaddr = MMDB_lookup_sockaddr(
      mmdb : S*,
      sockaddr : Sockaddr*,
      mmdb_error : LibC::Int*
    ) : LookupResultS

    fun read_node = MMDB_read_node(
      mmdb : S*,
      node_number : Uint32T,
      node : SearchNodeS*
    ) : LibC::Int

    fun get_value = MMDB_get_value(
      start : EntryS*,
      entry_data : EntryDataS*,
      ...
    ) : LibC::Int

    fun vget_value = MMDB_vget_value(
      start : EntryS*,
      entry_data : EntryDataS*,
      ...
    ) : LibC::Int

    fun aget_value = MMDB_aget_value(
      start : EntryS*,
      entry_data : EntryDataS*,
      path : LibC::Char**
    ) : LibC::Int

    fun get_metadata_as_entry_data_list = MMDB_get_metadata_as_entry_data_list(
      mmdb : S*,
      entry_data_list : EntryDataListS**
    ) : LibC::Int

    fun get_entry_data_list = MMDB_get_entry_data_list(
      start : EntryS*,
      entry_data_list : EntryDataListS**
    ) : LibC::Int

    fun free_entry_data_list = MMDB_free_entry_data_list(
      entry_data_list : EntryDataListS*
    )

    fun close = MMDB_close(mmdb : S*)
    fun lib_version = MMDB_lib_version : LibC::Char*

    fun dump_entry_data_list = MMDB_dump_entry_data_list(
      stream : File*,
      entry_data_list : EntryDataListS*,
      indent : LibC::Int
    ) : LibC::Int
  end
end