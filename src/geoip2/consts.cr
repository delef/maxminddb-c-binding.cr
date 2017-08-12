module GeoIP2
  # flags for open
  MODE_MMAP = 1
  MODE_MASK = 7

  # status codes
  SUCCESS                               =  0
  FILE_OPEN_ERROR                       =  1
  CORRUPT_SEARCH_TREE_ERROR             =  2
  INVALID_METADATA_ERROR                =  3
  IO_ERROR                              =  4
  OUT_OF_MEMORY_ERROR                   =  5
  UNKNOWN_DATABASE_FORMAT_ERROR         =  6
  INVALID_DATA_ERROR                    =  7
  INVALID_LOOKUP_PATH_ERROR             =  8
  LOOKUP_PATH_DOES_NOT_MATCH_DATA_ERROR =  9
  INVALID_NODE_NUMBER_ERROR             = 10
  IPV6_LOOKUP_IN_IPV4_DATABASE_ERROR    = 11
end
