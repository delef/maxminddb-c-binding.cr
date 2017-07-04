module GeoIP2
  class Result
    @result : Hash(Database::MapValue, Database::MapValue)|Nil
    @locale : Symbol|String?

    def initialize(@result, @locale = nil)
    end

    def country(locale = nil)
      return nil if @result.nil?

      @result


      # {
      #   geoname_id: data["country"]["geoname_id"],
      #   iso_code: data["country"]["iso_code"],
      #   names: data["country"]["names"],
      # }
    end

    def iso_code
    end
  end
end