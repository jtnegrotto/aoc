class Dial
  DEFAULT_POSITION = 50
  MIN_POSITION = 0
  MAX_POSITION = 99

  attr_reader :position

  def initialize(position: DEFAULT_POSITION)
    @position = position
  end

  def rotate(direction:, count: 1)
    if count.negative?
      raise ArgumentError, "Count cannot be negative, got #{count}"
    end

    if count > 1
      count.times { rotate(direction:) }
      return
    end

    case direction
    when :left
      @position = position == MIN_POSITION ? MAX_POSITION : position - 1
    when :right
      @position = position == MAX_POSITION ? MIN_POSITION : position + 1
    else
      raise ArgumentError, "Invalid direction #{direction.inspect}; must be :left or :right"
    end
  end
end

class InputReader
  LINE_PATTERN = %r{
    (?<direction>[LR])
    (?<count>\d+)
  }x

  attr_reader :io

  def initialize(io)
    @io = io
  end

  def each
    return enum_for(:each) unless block_given?

    @io.each_line do |line|
      md = line.match LINE_PATTERN
      raise "Invalid input line: #{line.inspect}" if md.nil?

      direction = case md[:direction]
                  when 'L'
                    :left
                  when 'R'
                    :right
                  end

      count = Integer(md[:count])

      yield({ direction:, count: })
    end
  end
end

dial = Dial.new
num_zero = 0
reader = InputReader.new(ARGF)
reader.each do |input|
  dial.rotate(direction: input[:direction], count: input[:count])
  num_zero += 1 if dial.position.zero?
end
puts num_zero
