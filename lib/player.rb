class Player

  attr_accessor :name
  attr_reader :color

  def initialize(color)
    @color = color
    @name = ""
  end

end
