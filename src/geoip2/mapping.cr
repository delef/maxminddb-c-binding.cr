module GeoIP2
  class Mapping
    alias MapNumeric = UInt16 | Int32 | UInt32 | Float32 | Float64
    alias MapValue = Nil | Bool | String | MapNumeric | Hash(MapValue, MapValue) | Array(MapValue)

    def self.build(current)
      return {current, nil} if current.null?

      entry = current.value.entry_data

      case entry.type
      when .map?
        mapping = Hash(MapValue, MapValue).new(initial_capacity: entry.data_size)
        current = current.value.next

        entry.data_size.times do
          current, key = build(current)
          current, val = build(current)

          mapping[key] = val
        end

        {current, mapping}
      when .array?
        array = Array(MapValue).new(entry.data_size)
        current = current.value.next

        entry.data_size.times do
          current, val = build(current)
          array << val
        end

        {current, array}
      when .uint16?
        uint16 = entry.data.uint16
        current = current.value.next

        {current, uint16}
      when .uint32?
        uint32 = entry.data.uint32
        current = current.value.next

        {current, uint32}
      when .int32?
        int32 = entry.data.int32
        current = current.value.next

        {current, int32}
      when .boolean?
        boolean = entry.data.boolean
        current = current.value.next

        {current, boolean}
      when .float?
        float_value = entry.data.float_value
        current = current.value.next

        {current, float_value}
      when .double?
        double_value = entry.data.double_value
        current = current.value.next

        {current, double_value}
      when .utf8_string?
        str = String.new(entry.data.utf8_string, entry.data_size)
        current = current.value.next

        {current, str}
      else
        current = current.value.next
        {current, nil}
      end
    end
  end
end
