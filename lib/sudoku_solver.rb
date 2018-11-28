class SudokuSolver

  ROWS = ('A'..'I')
  COLS = ('1'..'9')
  DIGITS = "123456789"

  def cross
  end

  @squares = cross(ROWS, COLS)
  nine_squares = ROWS.each_slice(3).map

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
    width = 2
    puts line = [['-'*width*3]*3].join('+') # 9x9 grid
    ROWS.each do |r|
      puts line if "DG".include?(r)
      COLS.each do |c|
        print values["#{r}#{c}"].center(width)
        print '|' if '36'.include?(c)
      end
      puts
    end
    puts line
  end

  

  def solve

  end

end
