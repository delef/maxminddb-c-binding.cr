module GeoIP2
  class Any
    @raw : Mapping::MapValue

    def initialize(@raw)
    end

    def [](key : String) : Any
      case data = @raw
      when Hash
        Any.new(data[key])
      else
        raise "Expected Hash for #[](key : String), not #{data.class}"
      end
    end

    def []?(key : String) : Any?
      case data = @raw
      when Hash
        value = data[key]?
        value.nil? ? nil : Any.new(value)
      else
        raise "Expected Hash for #[](key : String), not #{data.class}"
      end
    end

    def [](index : Int) : Any
      case data = @raw
      when Array
        Any.new(data[index])
      else
        raise "Expected Array for #[](index : Int), not #{data.class}"
      end
    end

    def []?(index : Int) : Any?
      case data = @raw
      when Array
        value = data[index]?
        value.nil? ? nil : Any.new(value)
      else
        raise "Expected Array for #[](index : Int), not #{data.class}"
      end
    end

    def as_i : Int32
      @raw.as(Int).to_i
    end

    def as_i? : Int32?
      as_i if @raw.is_a?(Int)
    end

    def as_i64 : Int64
      @raw.as(Int).to_i64
    end

    def as_i64? : Int64?
      as_i64 if @raw.is_a?(Int64)
    end

    def as_f : Float64
      @raw.as(Float).to_f
    end

    def as_f? : Float64?
      as_f if @raw.is_a?(Float64)
    end

    def as_f32 : Float32
      @raw.as(Float).to_f32
    end

    def as_f32? : Float32?
      as_f32 if (@raw.is_a?(Float32) || @raw.is_a?(Float64))
    end

    def as_s : String
      @raw.as(String)
    end

    def as_s? : String?
      as_s if @raw.is_a?(String)
    end

    def as_a : Array(Type)
      @raw.as(Array)
    end

    def as_a? : Array(Type)?
      as_a if @raw.is_a?(Array(Type))
    end

    def as_h : Hash(String, Type)
      @raw.as(Hash)
    end
  end
end
