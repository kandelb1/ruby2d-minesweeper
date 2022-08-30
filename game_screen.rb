require_relative 'helper'
require_relative 'button'

class GameScreen

  def initialize(difficulty)
    @difficulty = difficulty
    @game = Game.new(difficulty)
    @first_click = true

    @board_x, @board_y = Helper.calculate_board_position(difficulty.num_rows, difficulty.num_columns, CELL_SIZE)

    @restart_button = Button.create_centered_button(HALF_WINDOW_WIDTH, 40, 60, 20, 'Reset')
    @menu_button = Button.create_centered_button(HALF_WINDOW_WIDTH, 65, 60, 20, 'Menu')
  end

  def draw
    case @game.state
    when :game_inprogress
      Helper.create_centered_text("Mines: #{@difficulty.num_mines}", HALF_WINDOW_WIDTH, 0, 'orange')
      Helper.create_centered_text("Flags placed: #{@game.num_flags}", HALF_WINDOW_WIDTH, 20, 'orange')
    when :game_lost
      Helper.create_centered_text('Game Over!', HALF_WINDOW_WIDTH, 0, 'orange')
      @restart_button.draw
      @menu_button.draw
    when :game_won
      Helper.create_centered_text('Victory!', HALF_WINDOW_WIDTH, 0, 'orange')
      @restart_button.draw
      @menu_button.draw
    end

    # draw the board
    @game.grid.each_with_index do |row_obj, row|
      y = @board_y + (CELL_SIZE * row)
      row_obj.each_with_index do |cell, col|
        x = @board_x + (CELL_SIZE * col)
        color = [1, 1, 1, cell.revealed? ? 0.6 : 1]
        Image.new('img/cell.png', x: x, y: y, color: color)
        if cell.revealed?
          Image.new('img/mine.png', x: x, y: y) if cell.mine?
          if cell.number.positive? && !cell.mine?
            Image.new("img/#{cell.number}.png", x: x, y: y)
          end
        elsif cell.flag?
          Image.new('img/flag.png', x: x, y: y)
        end
      end
    end
  end

  def mouse_down(event)
    if clicked_cell?(event.x, event.y) && @game.state == :game_inprogress
      pos = get_position_clicked(event.x, event.y)
      case event.button
      when :left
        if @first_click
          @game.start_game(*pos)
          @first_click = false
        else
          @game.reveal_cell(*pos)
        end
      when :right
        @game.place_flag(*pos)
      end
    end

    if clicked_reset_button?(event)
      reset_game
    elsif clicked_menu_button?(event)
      $current_screen = StartScreen.new
    end
  end

  def clicked_reset_button?(event)
    @restart_button.contains?(event.x, event.y) if event.button == :left
  end

  def clicked_menu_button?(event)
    @menu_button.contains?(event.x, event.y) if event.button == :left
  end

  def reset_game
    @game = Game.new(@difficulty)
    @first_click = true
  end

  # returns true if the click was within the board
  def clicked_cell?(x, y)
    (x > @board_x && x < @board_x + (CELL_SIZE * @difficulty.width)) &&
      (y > @board_y && y < @board_y + (CELL_SIZE * @difficulty.height))
  end

  # returns the [row, col] of the cell clicked
  def get_position_clicked(x, y)
    # the mouse y position / cell_size gives us the row we are at
    # the mouse x position / cell_size gives us the column we are at
    [(y - @board_y) / CELL_SIZE, (x - @board_x) / CELL_SIZE]
  end

end