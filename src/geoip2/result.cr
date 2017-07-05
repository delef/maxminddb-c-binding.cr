module GeoIP2
  class Result
    @result : Hash(Mapping::MapValue, Mapping::MapValue)?
    @locale : Symbol|String?

    def initialize(@result, @locale = nil)
    end

    def country(locale = nil)
      @result

      # return nil if @result.nil?

      # root = @result.as(Hash(Database::MapValue, Database::MapValue))
      # country = root["country"].as(Hash(Database::MapValue, Database::MapValue))
      # names = country["names"].as(Hash(Database::MapValue, Database::MapValue))

      # {
      #   geoname_id: country["geoname_id"].as(UInt32),
      #   iso_code: country["iso_code"].as(String),
      #   names: names.as(NamedTuple)
      # }
    end

    def iso_code
    end
  end
end