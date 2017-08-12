module GeoIP2
  def self.open_error(status)
    message =
      case status
      when SUCCESS
        "Success (not an error)"
      when FILE_OPEN_ERROR
        "Error opening the specified MaxMind DB file"
      when CORRUPT_SEARCH_TREE_ERROR
        "The MaxMind DB file's search tree is corrupt"
      when INVALID_METADATA_ERROR
        "The MaxMind DB file contains invalid metadata"
      when IO_ERROR
        "An attempt to read data from the MaxMind DB file failed"
      when OUT_OF_MEMORY_ERROR
        "A memory allocation call failed"
      when UNKNOWN_DATABASE_FORMAT_ERROR
        "The MaxMind DB file is in a format this library can't handle " +
          "(unknown record size or binary format version)"
      when INVALID_DATA_ERROR
        "The MaxMind DB file's data section contains bad data (unknown " +
          "data type or corrupt data)"
      when INVALID_LOOKUP_PATH_ERROR
        "The lookup path contained an invalid value (like a negative " +
          "integer for an array index)"
      when LOOKUP_PATH_DOES_NOT_MATCH_DATA_ERROR
        "The lookup path does not match the data (key that doesn't exist, " +
          "array index bigger than the array, expected array or map " +
          "where none exists)"
      when INVALID_NODE_NUMBER_ERROR
        "The MMDB_read_node function was called with a node number that " +
          "does not exist in the search tree"
      when IPV6_LOOKUP_IN_IPV4_DATABASE_ERROR
        "You attempted to look up an IPv6 address in an IPv4-only database"
      else
        "Unknown error code"
      end

    "GeoIP2: #{message}"
  end
end
