class Difficulty
  attr_reader :name, :width, :height, :num_mines

  def initialize(name, width, height, mines)
    @name = name
    @width = width
    @height = height
    @num_mines = mines
  end

  def num_rows
    @height
  end

  def num_columns
    @width
  end
end

class StartScreen
  def initialize
    @difficulties = [
      Difficulty.new('Beginner', 12, 12, 20),
      Difficulty.new('Intermediate', 18, 16, 45),
      Difficulty.new('Expert', 25, 16, 75)
    ]
    @selected_difficulty = 0
  end

  def get_difficulty
    @difficulties[@selected_difficulty]
  end

  def move_selection(dir)
    case dir
    when :left
      @selected_difficulty -= 1
      @selected_difficulty = 2 if @selected_difficulty.negative?
    when :right
      @selected_difficulty += 1
      @selected_difficulty = 0 if @selected_difficulty > 2
    end
  end

  def draw
    # could do math to center this perfectly but I'll just eyeball it
    x = 150
    y = 200
    width = 150
    height = 200
    text_color = 'yellow'

    @difficulties.each do |diff|
      color = diff == get_difficulty ? [0.5, 1, 0.5, 0.5] : [1, 1, 1, 0.25]
      rect = Rectangle.new(x: x, y: y, width: width, height: height, color: color)
      text = Text.new(diff.name, x: x, y: y, size: 20)
      Helper.center_text_in_rect(text, rect, true)
      text.y -= 17
      text = Text.new("Board Size: #{diff.width}x#{diff.height}", size: 15, color: text_color)
      Helper.center_text_in_rect(text, rect, true)
      text = Text.new("Mines: #{diff.num_mines}", size: 15, color: text_color)
      Helper.center_text_in_rect(text, rect, true)
      text.y += 15

      x += width + 40
    end

    # other text
    Helper.create_centered_text('Use arrow keys to select', HALF_WINDOW_WIDTH, 550, text_color, 20)
    Helper.create_centered_text('Press enter to start', HALF_WINDOW_WIDTH, 575, text_color, 20)
    Helper.create_centered_text('Press escape to quit', HALF_WINDOW_WIDTH, 600, text_color, 20)
  end

  def key_down(event)
    case event.key
    when 'left'
      move_selection(:left)
    when 'right'
      move_selection(:right)
    when 'return'
      $current_screen = GameScreen.new(get_difficulty)
    when 'escape'
      Window.close
    end
  end

end
