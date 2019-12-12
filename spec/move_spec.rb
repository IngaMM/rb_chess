#spec/move_spec.rb
require './lib/move'
require './lib/board'

RSpec.describe Move do
  describe "#check" do
    it "returns the correct error message if a start field is outside of the board" do
      board = Board.new
      move = Move.new(board, "white", 10, 0, 0, 0)
      move.check
      expect(move.error_message).to eql("Invalid move. Outside of board.")
      expect(move.possible).to eql(false)
      move = Move.new(board, "white", 0, 10, 0, 0)
      move.check
      expect(move.error_message).to eql("Invalid move. Outside of board.")
      expect(move.possible).to eql(false)
    end

    it "returns the correct error message if a target field is outside of the board" do
      board = Board.new
      move = Move.new(board, "white", 0, 0, 10, 0)
      move.check
      expect(move.error_message).to eql("Invalid move. Outside of board.")
      expect(move.possible).to eql(false)
      move = Move.new(board, "white", 0, 0, 0, 10)
      move.check
      expect(move.error_message).to eql("Invalid move. Outside of board.")
      expect(move.possible).to eql(false)
    end

    it "returns the correct error message if a start field is not occupied by a piece of the right color" do
      board = Board.new
      move = Move.new(board, "black", 1, 1, 1, 3)
      move.check
      expect(move.error_message).to eql("Invalid move. Start field not occupied by a piece of your color.")
      expect(move.possible).to eql(false)
      move = Move.new(board, "black", 1, 4, 1, 3)
      move.check
      expect(move.error_message).to eql("Invalid move. Start field not occupied by a piece of your color.")
      expect(move.possible).to eql(false)
    end

    it "returns the correct error message if a target field is occupied by a piece of the same color" do
      board = Board.new
      move = Move.new(board, "black", 7, 0, 6, 0)
      move.check
      expect(move.error_message).to eql("Invalid move. Target field is already occupied by a piece of your color.")
      expect(move.possible).to eql(false)
    end

    it "evaluates correctly a move of the rook" do
      board = Board.new
      board.clean
      board.place_one_piece(3, 3, "black", "rook")
      possible_target_fields = [[2, 3], [1, 3], [0, 3], [4, 3], [5, 3], [6, 3], [7, 3],
                                [3, 2], [3, 1], [3, 0], [3, 4], [3, 5], [3, 6], [3, 7]]
      i = 0
      j = 0
      while i < 8 do
        while j < 8 do
          move = Move.new(board, "black", 3, 3, i, j)
          move.check
          expect(move.error_message).to eql("") if possible_target_fields.include? [i, j]
          expect(move.possible).to eql(true) if possible_target_fields.include? [i, j]
          if i != 3 && j != 3
            expect(move.error_message).to eql("Invalid move. Target field out of reach or another piece in the way.") if !possible_target_fields.include? [i, j]
          end
          expect(move.possible).to eql(false) if !possible_target_fields.include? [i, j]
          j += 1
        end
        j = 0
        i += 1
      end
    end

    it "evaluates correctly a move of the knight" do
      board = Board.new
      board.clean
      board.place_one_piece(3, 3, "white", "knight")
      possible_target_fields = [[5, 4], [4, 5], [2, 1], [1, 2], [5, 2], [4, 1], [2, 5], [1, 4]]
      i = 0
      j = 0
      while i < 8 do
        while j < 8 do
          move = Move.new(board, "white", 3, 3, i, j)
          move.check
          expect(move.error_message).to eql("") if possible_target_fields.include? [i, j]
          expect(move.possible).to eql(true) if possible_target_fields.include? [i, j]
          if i != 3 && j != 3
            expect(move.error_message).to eql("Invalid move. Target field out of reach or another piece in the way.") if !possible_target_fields.include? [i, j]
          end
          expect(move.possible).to eql(false) if !possible_target_fields.include? [i, j]
          j += 1
        end
        j = 0
        i += 1
      end
      end

    it "evaluates correctly a move of the bishop" do
      board = Board.new
      board.clean
      board.place_one_piece(3, 3, "white", "bishop")
      possible_target_fields = [[2, 2], [1, 1], [0, 0], [4, 4], [5, 5], [6, 6], [7, 7],
                                [2, 4], [1, 5], [0, 6], [4, 2], [5, 1], [6, 0]]
      i = 0
      j = 0
      while i < 8 do
        while j < 8 do
          move = Move.new(board, "white", 3, 3, i, j)
          move.check
          expect(move.error_message).to eql("") if possible_target_fields.include? [i, j]
          expect(move.possible).to eql(true) if possible_target_fields.include? [i, j]
          if i != 3 && j != 3
            expect(move.error_message).to eql("Invalid move. Target field out of reach or another piece in the way.") if !possible_target_fields.include? [i, j]
          end
          expect(move.possible).to eql(false) if !possible_target_fields.include? [i, j]
          j += 1
        end
        j = 0
        i += 1
      end
    end

    it "evaluates correctly a move of the queen" do
      board = Board.new
      board.clean
      board.place_one_piece(3, 3, "black", "queen")
      possible_target_fields = [[2, 3], [1, 3], [0, 3], [4, 3], [5, 3], [6, 3], [7, 3],
                                [3, 2], [3, 1], [3, 0], [3, 4], [3, 5], [3, 6], [3, 7],
                                [2, 2], [1, 1], [0, 0], [4, 4], [5, 5], [6, 6], [7, 7],
                                [2, 4], [1, 5], [0, 6], [4, 2], [5, 1], [6, 0]]
      i = 0
      j = 0
      while i < 8 do
        while j < 8 do
          move = Move.new(board, "black", 3, 3, i, j)
          move.check
          expect(move.error_message).to eql("") if possible_target_fields.include? [i, j]
          expect(move.possible).to eql(true) if possible_target_fields.include? [i, j]
          if i != 3 && j != 3
            expect(move.error_message).to eql("Invalid move. Target field out of reach or another piece in the way.") if !possible_target_fields.include? [i, j]
          end
          expect(move.possible).to eql(false) if !possible_target_fields.include? [i, j]
          j += 1
        end
        j = 0
        i += 1
      end
    end

    it "evaluates correctly a move of the king" do
      board = Board.new
      board.clean
      board.place_one_piece(3, 3, "black", "king")
      possible_target_fields = [[2, 3], [4, 3], [3, 2], [3, 4], [2, 2], [4, 4], [2, 4], [4, 2] ]
      i = 0
      j = 0
      while i < 8 do
        while j < 8 do
          move = Move.new(board, "black", 3, 3, i, j)
          move.check
          expect(move.error_message).to eql("") if possible_target_fields.include? [i, j]
          expect(move.possible).to eql(true) if possible_target_fields.include? [i, j]
          if i != 3 && j != 3
            expect(move.error_message).to eql("Invalid move. Target field out of reach or another piece in the way.") if !possible_target_fields.include? [i, j]
          end
          expect(move.possible).to eql(false) if !possible_target_fields.include? [i, j]
          j += 1
        end
        j = 0
        i += 1
      end
    end

    it "evaluates correctly a move of the pawn" do
      board = Board.new
      # Normal move forward (white)
      board.clean
      board.place_one_piece(3, 1, "white", "pawn")
      possible_target_fields = [[4, 1]]
      i = 0
      j = 0
      while i < 8 do
        while j < 8 do
          move = Move.new(board, "white", 3, 1, i, j)
          move.check
          expect(move.error_message).to eql("") if possible_target_fields.include? [i, j]
          expect(move.possible).to eql(true) if possible_target_fields.include? [i, j]
          if i != 3 && j != 1
            expect(move.error_message).to eql("Invalid move. Target field out of reach or another piece in the way.") if !possible_target_fields.include? [i, j]
          end
          expect(move.possible).to eql(false) if !possible_target_fields.include? [i, j]
          j += 1
        end
        j = 0
        i += 1
      end

      # Normal move forward (black)
      board.clean
      board.place_one_piece(3, 1, "black", "pawn")
      possible_target_fields = [[2, 1]]
      i = 0
      j = 0
      while i < 8 do
        while j < 8 do
          move = Move.new(board, "black", 3, 1, i, j)
          move.check
          expect(move.error_message).to eql("") if possible_target_fields.include? [i, j]
          expect(move.possible).to eql(true) if possible_target_fields.include? [i, j]
          if i != 3 && j != 1
            expect(move.error_message).to eql("Invalid move. Target field out of reach or another piece in the way.") if !possible_target_fields.include? [i, j]
          end
          expect(move.possible).to eql(false) if !possible_target_fields.include? [i, j]
          j += 1
        end
        j = 0
        i += 1
      end

      #First move forward (white)
      board.clean
      board.place_one_piece(1, 3, "white", "pawn")
      possible_target_fields = [[2, 3], [3, 3]]
      i = 0
      j = 0
      while i < 8 do
        while j < 8 do
          move = Move.new(board, "white", 1, 3, i, j)
          move.check
          expect(move.error_message).to eql("") if possible_target_fields.include? [i, j]
          expect(move.possible).to eql(true) if possible_target_fields.include? [i, j]
          if i != 1 && j != 3
            expect(move.error_message).to eql("Invalid move. Target field out of reach or another piece in the way.") if !possible_target_fields.include? [i, j]
          end
          expect(move.possible).to eql(false) if !possible_target_fields.include? [i, j]
          j += 1
        end
        j = 0
        i += 1
      end

      #First move forward (black)
      board.clean
      board.place_one_piece(6, 3, "black", "pawn")
      possible_target_fields = [[5, 3], [4, 3]]
      i = 0
      j = 0
      while i < 8 do
        while j < 8 do
          move = Move.new(board, "black", 6, 3, i, j)
          move.check
          expect(move.error_message).to eql("") if possible_target_fields.include? [i, j]
          expect(move.possible).to eql(true) if possible_target_fields.include? [i, j]
          if i != 6 && j != 3
            expect(move.error_message).to eql("Invalid move. Target field out of reach or another piece in the way.") if !possible_target_fields.include? [i, j]
          end
          expect(move.possible).to eql(false) if !possible_target_fields.include? [i, j]
          j += 1
        end
        j = 0
        i += 1
      end

      # Capture opponent (white)
      board.clean
      board.place_one_piece(3, 1, "white", "pawn")
      board.place_one_piece(4, 0, "black", "pawn")
      possible_target_fields = [[4, 1], [4, 0]]
      i = 0
      j = 0
      while i < 8 do
        while j < 8 do
          move = Move.new(board, "white", 3, 1, i, j)
          move.check
          expect(move.error_message).to eql("") if possible_target_fields.include? [i, j]
          expect(move.possible).to eql(true) if possible_target_fields.include? [i, j]
          if i != 3 && j != 1
            expect(move.error_message).to eql("Invalid move. Target field out of reach or another piece in the way.") if !possible_target_fields.include? [i, j]
          end
          expect(move.possible).to eql(false) if !possible_target_fields.include? [i, j]
          j += 1
        end
        j = 0
        i += 1
      end

      # Capture opponent (black)
      board.clean
      board.place_one_piece(3, 1, "black", "pawn")
      board.place_one_piece(2, 0, "white", "pawn")
      possible_target_fields = [[2, 1], [2, 0]]
      i = 0
      j = 0
      while i < 8 do
        while j < 8 do
          move = Move.new(board, "black", 3, 1, i, j)
          move.check
          expect(move.error_message).to eql("") if possible_target_fields.include? [i, j]
          expect(move.possible).to eql(true) if possible_target_fields.include? [i, j]
          if i != 3 && j != 1
            expect(move.error_message).to eql("Invalid move. Target field out of reach or another piece in the way.") if !possible_target_fields.include? [i, j]
          end
          expect(move.possible).to eql(false) if !possible_target_fields.include? [i, j]
          j += 1
        end
        j = 0
        i += 1
      end
    end

    it "returns the correct error message if another piece is in the way" do
      board = Board.new
      board.clean
      board.place_one_piece(3, 3, "black", "queen")
      board.place_one_piece(5, 3, "black", "pawn")
      move = Move.new(board, "black", 3, 3, 7, 3)
      move.check
      expect(move.error_message).to eql("Invalid move. Target field out of reach or another piece in the way.")

      board.clean
      board.place_one_piece(3, 3, "white", "bishop")
      board.place_one_piece(4, 4, "black", "pawn")
      move = Move.new(board, "white", 3, 3, 5, 5)
      move.check
      expect(move.error_message).to eql("Invalid move. Target field out of reach or another piece in the way.")

      board.clean
      board.place_one_piece(3, 3, "white", "rook")
      board.place_one_piece(2, 2, "black", "pawn")
      move = Move.new(board, "white", 3, 3, 0, 0)
      move.check
      expect(move.error_message).to eql("Invalid move. Target field out of reach or another piece in the way.")
    end
  end
end
