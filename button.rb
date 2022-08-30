class Button

  def self.create_centered_button(x, y, width, height, text)
    center_x = x - width / 2
    center_y = y - height / 2
    Button.new(center_x, center_y, width, height, text)
  end

  def initialize(x, y, width, height, text)
    @x = x
    @y = y
    @text = text
    @width = width
    @height = height
    @rect = Rectangle.new(x: @x, y: @y, width: @width, height: @height, color: [0.5, 1, 0.5, 0.5])
    @text = Text.new(@text, color: 'black')
    Helper.center_text_in_rect(@text, @rect, true)
  end

  def draw
    @rect.add
    @text.add
  end

  def contains?(x, y)
    @rect.contains?(x, y)
  end

end
