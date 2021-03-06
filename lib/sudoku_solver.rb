class SudokuSolver

  ROWS = ('A'..'I')
  COLS = ('1'..'9')
  DIGITS = "123456789"

  def cross
  end

  @squares =  cross(ROWS, COLS)
  nine_squares = ROWS.each_slice(3).map {|r| COLS.each_slice(3).map{|c| cross(r,c)}}.flatten(1)
  @unitlist = COLS.map{|c| cross(ROWS,[c])} <<
              ROWS.map{|r| cross([r], COLS)} <<
              nine_squares
  @units = @squares.inject({}) {|h, s| h[s]=@unitlist.select{|arr| arr.include?(s)};h}
  @peers = @squares.inject({}) {|h,s| peers=(cross(ROWS,[s[1]]) << 
                                      cross([s[0]],COLS) << 
                                      nine_squares.select{|sq| sq.include?(s)} ).
                                      flatten; 
                                      peers.delete(s);
                                      h[s]=peers;
                                      h}
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.solve(puzzle_string)
    new(puzzle_string).solve
  end

  def grid_values(grid)
    @squares.zip(grid.each_char.grep(/[0-9\.]/))
  end

  def assign(values, s, d)
    other_values = values[s].sub(d,'')
    other_values.each_char dp |d2|
      return false unless eliminate(values, s, d2)
    end
    values
  end

  def eliminate(values, s, d)
    return values unless values[s].include?(d)

    values[s] = values[s].sub(d,'')

    if values[s].size==0
      return false
    elsif values[s].size == 1
      d2 = values[s]
      @peers[s].each do |s2|
        return false unless (eliminate(values, s2, d2))
      end
    end

    sa = [s]
    @units[s].each do |u|
      dplaces = values[s].include?(d) ? sa & u : []
      return values if dplaces.size == 0
      if dplaces.size == 1
        return false unless assign(values, dplaces[0], d)
      end
    end
    values
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

  def parse_grid(grid)
    values = {}
    @squares.each do |s|
      values[s] = DIGITS
    end

    grid_values(grid).each do |zg|
      s, d = zg
      if DIGITS.include?(d)
        return false unless assign(values, s, d)
      end
    end
    values
  end


  def search(values)
    return false unless values
    return values unless @squares.any?{|s| values[s].size != 1}
    k,v,l = get_min(values)
    v.each_char do |d|
      r = serch(assign(values.clone, k, d))
      return r if r
    end
    return false
  end

  

  def solve

  end

  GRID1  = '003020600900305001001806400008102900700000008006708200002609500800203009005010300'


  def measureFor(fn, timeMinimum)
    iter = 0
    elapsed = 0
    start = Time.now
    while elapsed < timeMinimum do
      fn.call()
      elapsed = (Time.now -start) * 1000
      iter += 1
    end
    return 1000.0 * elapsed /iter
end

def measure(fn, times = 10, runfor = 2000, setup=nil, warmup=nil, teardown=nil) 
  if setup != nil
    setup.call()    
  end

  if warmup == nil
    warmup = fn
  end
  
  measureFor(lambda { warmup.call() }, 100)
  
  result = measureFor(lambda { (0..times).each { |i| fn.call() } }, runfor)
  
  if teardown != nil
    teardown.call()
  end
  
  return result
end

def report(name, score)
  puts "#{name}(RunTime): #{score}"
end

def log(o)
  puts o
  return o
end

def solved(values)
  unitsolved = lambda { |unit| ((unit.map { |s| (values[s]) }.uniq - DIGITS.chars.uniq {|c| c}).length) == 0 }
  return values != nil && @unitlist.select{ |unit| unitsolved.call((unit)) }.all?   
end

def solveGrid(name, grid)
  solution = nil
  puts "#{name}: #{grid}"
  time = Benchmark.realtime do
  	solution = search(parse_grid(grid))
  end
  display(solution)
  puts "solved: #{solved(solution)}, in #{time * 1000}ms\n"
end

def displayAll()
  solveGrid("grid1", GRID1)
end

