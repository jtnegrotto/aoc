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
        break
      end
    end

    fresh_ranges = fresh_ranges.reduce([]) do |prev, a|
      res = prev.map { |b|
        if a.cover?(b.first) || a.cover?(b.last) || b.cover?(a.first) || b.cover?(a.last)
          a = ([a.first, b.first].min)..([a.last, b.last].max)
          nil
        else
          b
        end
      }.compact
    
      res << a
      
      res
    end

    fresh_ranges.map(&:size).sum
  end
end

puts FreshIngredientCounter.new(ARGF).call
