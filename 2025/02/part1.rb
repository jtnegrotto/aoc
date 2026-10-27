class ID
  INVALID_PATTERN = %r{
    \A
    (\d+)
    \1
    \z
  }x

  attr_reader :number

  def initialize(number)
    @number = number
  end

  def valid?
    number.to_s.match(INVALID_PATTERN).nil?
  end

  def <=> other
    number <=> other.number
  end

  def succ
    self.class.new(number + 1)
  end
end

class IDRangeReader
  RANGE_PATTERN = %r{
    (?<first>\d+)
    -
    (?<last>\d+)
  }x

  attr_reader :io

  def initialize(io)
    @io = io
  end

  def read_range
    return nil if io.eof?

    chars = []
    while !io.eof?
      c = io.readchar
      break if c == ','
      chars << c
    end
    str = chars.join

    md = RANGE_PATTERN.match(str)
    raise "Invalid range: #{str.inspect}" if md.nil?
    first = ID.new Integer(md[:first])
    last = ID.new Integer(md[:last])

    first..last
  end
end

invalid_sum = 0
reader = IDRangeReader.new(ARGF)
while !(range = reader.read_range).nil?
  range.each do |id|
    invalid_sum += id.number unless id.valid?
  end
end
puts invalid_sum
