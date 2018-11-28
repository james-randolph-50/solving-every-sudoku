class SudokuSolver
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.solve(puzzle_string)
    new(puzzle_string).solve
  end

  def grid_values(grid)
    @squares.zip(grid.each_char.grep(/[0-9\.]/))
  end

  def assign
  end

  def eliminate
  end

  def display
  end

  

  def solve

  end

end
