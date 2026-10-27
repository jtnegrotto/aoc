class FreshIngredientCounter
  ID_RANGE_PATTERN = %r{
    \A
    (?<first>\d+)
    -
    (?<last>\d+)
    \z
  }x

  attr_reader :io

  def initialize(io)
    @io = io
  end

  def call
    reading_fresh_id_ranges = true
    fresh_ranges = []
    n_fresh = 0

    @io.each_line do |line|
      line = line.chomp
      if line.length.zero? && reading_fresh_id_ranges
        reading_fresh_id_ranges = false
        next
      elsif reading_fresh_id_ranges
        md = line.match(ID_RANGE_PATTERN)
        if md.nil?
          raise "Invalid input line: #{line.inspect}"
        end
        first = Integer(md[:first])
        last = Integer(md[:last])
        fresh_ranges << (first..last)
      else
        id = Integer(line)
        n_fresh += 1 if fresh_ranges.any? { |range| range.cover?(id) }
      end
    end

    n_fresh
  end
end

puts FreshIngredientCounter.new(ARGF).call
