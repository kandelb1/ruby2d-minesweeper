require_relative 'cell'

class Board
  attr_reader :num_mines

  def initialize(rows, cols, num_mines)
    @rows = rows
    @cols = cols
    @num_mines = num_mines
    @board = Array.new(rows) do
      Array.new(cols) do
        Cell.new
      end
    end
    @flags = 0
  end

  def grid
    @board
  end

  def num_flags
    @flags
  end

  def get_cell(row, col)
    check_position(row, col)
    @board[row][col]
  end

  def clear_board
    grid.map { |row| row.map { |cell| cell.reset } }
    @flags = 0
  end

  # randomly places @num_mines on the board, making sure to avoid the row,col position given
  def place_mines(row, col)
    coords = []
    (0..@rows - 1).each do |x|
      (0..@cols - 1).each do |y|
        coords.push([x, y])
      end
    end

    # don't place mines around the spot the player first revealed
    restricted_cells = get_neighboring_cells(row, col).append([row, col]) # don't forget the cell they clicked too!
    available_cells = coords.reject { |val| restricted_cells.include?(val) }.shuffle # remove restricted cells and then shuffle

    available_cells.take(@num_mines).each do |val|
      get_cell(*val).mine
    end
  end

  def calculate_numbers
    (0..@rows - 1).each do |row|
      (0..@cols - 1).each do |col|
        # if this cell has a mine, add 1 to the number of each neighboring cell
        cell = get_cell(row, col)
        get_neighboring_cells(row, col).each { |val| get_cell(*val).number += 1 } if cell.mine?
      end
    end
  end

  # will not return any invalid [row,col] pairs (a row or col number that is outside the range of the board)
  def get_neighboring_cells(row, col)
    # offsets are down, up, left, right, upleft, upright, downleft, downright
    [[1, 0], [-1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]].map { |offset| [row + offset[0], col + offset[1]] }
                                                                          .select { |pos| position_valid?(*pos) }
  end

  # returns true if given a valid position
  def position_valid?(row, col)
    (row >= 0 && row < @rows) && (col >= 0 && col < @cols)
  end

  # will throw an error if the row,col is invalid
  def check_position(row, col)
    return if position_valid?(row, col)

    raise "Invalid position #{row},#{col}. The board has #{@rows} rows and #{@cols} columns."
  end

  # places/removes a flag at the given position
  def place_flag(row, col)
    cell = get_cell(row, col)
    return if cell.revealed? # can't place flags on revealed cells!

    @flags += cell.flag
  end

  # recursive method that reveals a cell and then calls this function on its neighboring cells
  def reveal_cell(row, col)
    cell = get_cell(row, col)
    return if cell.revealed? # can't reveal an already revealed cell

    @flags -= 1 if cell.flag? # any flags will be removed, so make sure to update the flag count
    cell.reveal
    return if cell.mine? || cell.number.positive?

    get_neighboring_cells(row, col).each { |val| reveal_cell(*val) }
  end

end
