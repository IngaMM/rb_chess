class Move

  attr_accessor :error_message, :possible, :piece

  def initialize(board, color, i_start, j_start, i_target, j_target)
    @board = board
    @color = color
    @i_start = i_start
    @j_start = j_start
    @i_target = i_target
    @j_target = j_target
    @error_message = ""
    @possible = false
    @piece = ""
  end

  def check
    @error_message = ""

    if inside_board == false # target outside of board
      @error_message = "Invalid move. Outside of board."
      return
    else
      @piece = @board.fields[@i_start][@j_start].piece # right color on start field
      if valid_start_field == false
        @error_message = "Invalid move. Start field not occupied by a piece of your color."
        return
      elsif target_field_is_occupied_by_same_color == true # not the same color on the target field
        @error_message = "Invalid move. Target field is already occupied by a piece of your color."
        return
      else
        case @piece
        when "rook"
          @possible = self.class.possible_targets_rook(@board, @i_start, @j_start).include? [@i_target, @j_target]
        when "knight"
          @possible = self.class.possible_targets_knight(@i_start, @j_start).include? [@i_target, @j_target]
        when "bishop"
          @possible = self.class.possible_targets_bishop(@board, @i_start, @j_start).include? [@i_target, @j_target]
        when "queen"
          @possible = self.class.possible_targets_queen(@board, @i_start, @j_start).include? [@i_target, @j_target]
        when "king"
          @possible = self.class.possible_targets_king(@i_start, @j_start).include? [@i_target, @j_target]
        when "pawn"
          @possible = self.class.possible_targets_pawn(@board, @color, @i_start, @j_start).include? [@i_target, @j_target]
        else
          @error_message = "Piece not found."
        end
        @error_message = "Invalid move. Target field out of reach or another piece in the way." unless @possible
      end
    end
  end

  def target_occupied_by_opponent
    @color == "white" ? opp_color = "black" : opp_color = "white"
    return @board.fields[@i_target][@j_target].color == opp_color
  end

  def execute
    @board.fields[@i_target][@j_target].occupy(@color, @piece)
    @board.fields[@i_start][@j_start].clear
  end

   def self.possible_targets_rook(board, i, j)
     possible_target_fields = []
     counter = 1
     while counter < 8 do
       possible_target_fields << [i + counter, j] if path_free(board, i, j, i + counter, j)
       possible_target_fields << [i - counter, j] if path_free(board, i, j, i - counter, j)
       possible_target_fields << [i, j + counter] if path_free(board, i, j, i, j + counter)
       possible_target_fields << [i, j - counter] if path_free(board, i, j, i, j - counter)
       counter += 1
     end
     return possible_target_fields
   end

   def self.possible_targets_knight(i, j)
     possible_target_fields =
     [[i+1, j+2], [i+2, j+1], [i-2, j+1], [i-1, j-2], [i-2, j-1], [i+1, j-2], [i-1, j+2], [i+2, j-1]]
     possible_target_fields.select! {|field| field[0].between?(0, 7) && field[1].between?(0, 7)}
     return possible_target_fields
   end

   def self.possible_targets_bishop(board, i, j)
     possible_target_fields = []
     counter = 1
     while counter < 8 do
       possible_target_fields << [i + counter, j + counter] if path_free(board, i, j, i + counter, j + counter)
       possible_target_fields << [i - counter, j -  counter] if path_free(board, i, j, i - counter, j - counter)
       possible_target_fields << [i + counter, j - counter] if path_free(board, i, j, i + counter, j - counter)
       possible_target_fields << [i - counter, j + counter] if path_free(board, i, j, i - counter, j + counter)
       counter += 1
     end
     return possible_target_fields
   end

   def self.possible_targets_queen(board, i, j)
     possible_target_fields = []
     counter = 1
     while counter < 8 do
       possible_target_fields << [i + counter, j + counter] if path_free(board, i, j, i + counter, j + counter)
       possible_target_fields << [i - counter, j -  counter] if path_free(board, i, j, i - counter, j - counter)
       possible_target_fields << [i + counter, j - counter] if path_free(board, i, j, i + counter, j - counter)
       possible_target_fields << [i - counter, j + counter] if path_free(board, i, j, i - counter, j + counter)
       possible_target_fields << [i + counter, j] if path_free(board, i, j, i + counter, j)
       possible_target_fields << [i - counter, j] if path_free(board, i, j, i - counter, j)
       possible_target_fields << [i, j + counter] if path_free(board, i, j, i, j + counter)
       possible_target_fields << [i, j - counter] if path_free(board, i, j, i, j - counter)
       counter += 1
     end
     return possible_target_fields
   end

   def self.possible_targets_king(i, j)
     possible_target_fields =
     [[i+1, j], [i, j+1], [i-1, j], [i, j-1], [i-1, j-1], [i+1, j+1], [i-1, j+1], [i+1, j-1]]
     possible_target_fields.select! {|field| field[0].between?(0, 7) && field[1].between?(0, 7)}
     return possible_target_fields
   end

   def self.possible_targets_pawn(board, color, i, j)
     possible_target_fields = []

     case color
     when "white"
       # Normal move forward

       if i < 7
         possible_target_fields << [i+1, j] if board.fields[i+1][j].color == "none"
       end

       # First move forward
       if (i == 1)
         possible_target_fields << [i+2, j] if board.fields[i+1][j].color == "none" && board.fields[i+2][j].color == "none"
       end

       # Capture opponent
       if i < 7 && j < 7
         possible_target_fields << [i+1, j+1] if board.fields[i+1][j+1].color == "black"
       end
       if i < 7 && j > 0
         possible_target_fields << [i+1, j-1] if board.fields[i+1][j-1].color == "black"
       end

     when "black"
       # Normal move forward
       if i > 0
         possible_target_fields << [i-1, j] if board.fields[i-1][j].color == "none"
       end

       # First move forward
       if (i == 6)
         possible_target_fields << [i-2, j] if board.fields[i-1][j].color == "none" && board.fields[i-2][j].color == "none"
       end

       # Capture opponent
       if i > 0 && j < 7
         possible_target_fields << [i-1, j+1] if board.fields[i-1][j+1].color == "white"
       end
       if i > 0 && j > 0
         possible_target_fields << [i-1, j-1] if board.fields[i-1][j-1].color == "white"
       end
     end

     return possible_target_fields
   end

   private

   def inside_board
     @i_target.between?(0, 7) && @j_target.between?(0, 7) && @i_start.between?(0, 7) && @j_start.between?(0, 7)
   end

   def valid_start_field
     @piece != "none" && @board.fields[@i_start][@j_start].color == @color
   end

   def target_field_is_occupied_by_same_color
     @board.fields[@i_target][@j_target].color == @color
   end

   def self.path_free(board, i_start, j_start, i_end, j_end)

     # exclude fields that are outside of the board
     return false if i_start.between?(0, 7) == false
     return false if j_start.between?(0, 7) == false
     return false if i_end.between?(0, 7) == false
     return false if j_end.between?(0, 7) == false

     i_start <= i_end ? (i_small = i_start; i_large = i_end) : (i_small = i_end; i_large = i_start)
     j_start <= j_end ? (j_small = j_start; j_large = j_end) : (j_small = j_end; j_large = j_start)

     if i_start == i_end # check for rook & queen
       for j in j_small+1...j_large
         return false if board.fields[i_start][j].color != "none"
       end
     elsif j_start == j_end # check for rook & queen
       for i in i_small+1...i_large
        return false if board.fields[i][j_start].color != "none"
       end
     else # check for bishop & queen
       if i_start < i_end && j_start < j_end
         i = i_start + 1
         j = j_start + 1
         while i < i_end
           return false if board.fields[i][j].color != "none"
           i += 1
           j += 1
         end
       elsif i_end < i_start && j_end < j_start
         i = i_start - 1
         j = j_start - 1
         while i > i_end
           return false if board.fields[i][j].color != "none"
           i -= 1
           j -= 1
         end
       elsif i_start < i_end && j_end < j_start
         i = i_start + 1
         j = j_start - 1
         while i < i_end
           return false if board.fields[i][j].color != "none"
           i += 1
           j -= 1
         end
       else
         i = i_start - 1
         j = j_start + 1
         while i > i_end
           return false if board.fields[i][j].color != "none"
           i -= 1
           j += 1
         end
       end

     end
     return true
   end

end
