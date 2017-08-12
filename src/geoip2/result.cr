module GeoIP2
  class Result
    @locale : String

    def initialize(data, @locale = "en")
      @data = Any.new(data)
    end

    def city(locale : String? = nil)
      locale ||= @locale
      @data["city"]["names"][locale].as_s
    end

    def country(locale : String? = nil)
      locale ||= @locale
      @data["country"]["names"][locale].as_s
    end

    def iso_code
    end

    def data
      @data
    end
  end
end
