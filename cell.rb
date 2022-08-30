class Cell
  attr_accessor :number

  def initialize
    @mine = false
    @flag = false
    @number = 0
    @hidden = true
  end

  def flag
    @flag = !@flag
    flag? ? 1 : -1
  end

  def flag?
    @flag
  end

  def mine
    @mine = true
  end

  def mine?
    @mine
  end

  def reveal
    @hidden = false
    @flag = false
  end

  def revealed?
    !@hidden
  end

  def reset
    @mine = false
    @flag = false
    @number = 0
    @hidden = true
  end

end
