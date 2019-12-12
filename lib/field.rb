class Field

  attr_accessor :color, :piece

  def initialize(color = "none", piece = "none")
    @color = color
    @piece = piece
  end

  def clear
    @color = "none"
    @piece = "none"
  end

  def occupy(color, piece)
    @color = color
    @piece = piece
  end

end
