class Helper

  # returns [x, y] coord of the top-left corner of the board, with the board centered in the window
  def self.calculate_board_position(num_rows, num_cols, cell_size)
    real_width_x = num_cols * cell_size
    real_width_y = num_rows * cell_size
    middle_x = HALF_WINDOW_WIDTH
    middle_y = HALF_WINDOW_HEIGHT
    result_x = middle_x - (real_width_x / 2)
    result_y = middle_y - (real_width_y / 2)
    [result_x, result_y]
  end

  def self.create_centered_text(display_text, x, y, color, size = nil)
    text = Text.new(display_text, x: x, y: y, color: color, size: size)
    centered_x = x - (text.width / 2)
    text.x = centered_x
    text
  end

  def self.center_text_in_rect(text, rect, center_vert = false)
    center_x = rect.x + (rect.width / 2)
    center_y = rect.y + (rect.height / 2)
    text.x = center_x - (text.width / 2)
    text.y = center_y - (text.height / 2) if center_vert
    text
  end

end
