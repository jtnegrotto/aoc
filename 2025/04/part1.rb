class Grid
  PAPER = '@'

  attr_reader :rows

  def initialize(rows)
    @rows = rows
  end

  def [](x, y)
    rows[y][x]
  end

  def height
    rows.length
  end

  def width
    rows.first.length
  end

  def paper_at?(x, y)
    self[x, y] == PAPER
  end

  def accessible_paper_at?(x, y)
    return false unless paper_at?(x, y)

    min_x = x.zero? ? x : x - 1
    min_y = y.zero? ? y : y - 1
    max_x = x + 1 == width ? x : x + 1
    max_y = y + 1 == height ? y : y + 1

    n_adjacent_paper = 0
    min_x.upto(max_x) do |i|
      min_y.upto(max_y) do |j|
        next if i == x && j == y
        n_adjacent_paper += 1 if paper_at?(i, j)
        return false if n_adjacent_paper == 4
      end
    end
  end
end

class GridReader
  attr_reader :io

  def initialize(io)
    @io = io
  end

  def call
    rows = io.each_line.map do |line|
      line.chomp.chars
    end
    Grid.new(rows)
  end
end

n_accessible_paper = 0
grid = GridReader.new(ARGF).call
grid.width.times do |i|
  grid.height.times do |j|
    n_accessible_paper += 1 if grid.accessible_paper_at?(i, j)
  end
end
puts n_accessible_paper
