class Game

  def initialize(difficulty)
    @board = Board.new(difficulty.num_rows, difficulty.num_columns, difficulty.num_mines)
    @state = :game_inprogress
  end

  def grid
    @board.grid
  end

  def start_game(row, col)
    puts "starting game with click at #{row},#{col}"
    @board.clear_board
    @board.place_mines(row, col)
    @board.calculate_numbers
    reveal_cell(row, col)
  end

  def place_flag(row, col)
    @board.place_flag(row, col)
  end

  def reveal_cell(row, col)
    @board.reveal_cell(row, col)
    update_game_state
    puts "game state is now #{@state}"
  end

  def update_game_state
    hidden_total = 0
    @board.grid.each do |row|
      row.each do |cell|
        if cell.mine?
          if cell.revealed?
            @state = :game_lost
            return
          end
        end
      end
    end
    @board.grid.each do |row|
      hidden_total += row.select { |cell| !cell.revealed? }.length
    end
    if hidden_total == @board.num_mines
      @state = :game_won
    else
      @state = :game_inprogress
    end
  end

  def state
    @state
  end

  def num_flags
    @board.num_flags
  end

end
