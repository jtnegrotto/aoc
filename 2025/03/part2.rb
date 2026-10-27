class Bank
  NUM_DIGITS = 12

  attr_reader :joltages

  def initialize(joltages)
    @joltages = joltages
  end

  def max_joltage
    digits = []

    offset = 0
    slice = joltages
    NUM_DIGITS.times do |i|
      max_index = joltages.length - NUM_DIGITS + i

      slice = joltages[offset..max_index]
      max = slice.max
      digits << max
      offset += slice.index(max) + 1
    end

    digits.join.to_i
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
