class Bank
  attr_reader :joltages

  def initialize(joltages)
    @joltages = joltages
  end

  def max_joltage
    d1_idx_range = 0...(joltages.length - 1)
    d1 = joltages[d1_idx_range].max
    d2_offset = joltages.index(d1) + 1
    d2_idx_range = d2_offset..(joltages.length - 1)
    d2 = joltages[d2_idx_range].max
    [d1, d2].join.to_i
  end
end

class BankReader
  attr_reader :io

  def initialize(io)
    @io = io
  end

  def read_bank
    joltages = io.readline.chomp.chars.map(&:to_i)
    Bank.new(joltages)
  end

  def each
    return enum_for(:each) unless block_given?

    while !io.eof?
      bank = read_bank
      yield bank
    end
  end
end

r = BankReader.new(ARGF)
puts r.each.lazy.map(&:max_joltage).sum
