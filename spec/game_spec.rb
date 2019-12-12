require './lib/game'

RSpec.describe Game do
  describe "#check" do
    it "recognizes check" do
      game = Game.new
      game.player[0].name = "Player1"
      game.player[1].name = "Player2"

      game.board.clean
      game.board.place_one_piece(3, 5, "white", "king")
      game.board.place_one_piece(4, 5, "black", "rook")
      game.check("check", game.player[1], game.player[0])
      expect(game.situation_occuring).to eql(true)

      game.board.clean
      game.board.place_one_piece(3, 5, "white", "king")
      game.board.place_one_piece(4, 6, "black", "bishop")
      game.check("check", game.player[1], game.player[0])
      expect(game.situation_occuring).to eql(true)

      game.board.clean
      game.board.place_one_piece(3, 5, "black", "king")
      game.board.place_one_piece(1, 4, "white", "knight")
      game.check("check", game.player[0], game.player[1])
      expect(game.situation_occuring).to eql(true)

      game.board.clean
      game.board.place_one_piece(3, 5, "white", "king")
      game.board.place_one_piece(4, 4, "black", "pawn")
      game.check("check", game.player[1], game.player[0])
      expect(game.situation_occuring).to eql(true)
    end

      it "recognizes check mate and ends the game and finds the correct winner" do
        game = Game.new
        game.player[0].name = "Player1"
        game.player[1].name = "Player2"

        game.board.clean
        game.board.place_one_piece(3, 5, "white", "king")
        game.board.place_one_piece(4, 5, "black", "rook")
        game.check("check mate", game.player[1], game.player[0])
        expect(game.situation_occuring).to eql(true)
        expect(game.game_over).to eql(true)
        expect(game.winner).to eql(game.player[1])

        game.board.clean
        game.board.place_one_piece(3, 5, "white", "king")
        game.board.place_one_piece(4, 6, "black", "bishop")
        game.check("check mate", game.player[1], game.player[0])
        expect(game.situation_occuring).to eql(true)
        expect(game.game_over).to eql(true)
        expect(game.winner).to eql(game.player[1])

        game.board.clean
        game.board.place_one_piece(3, 5, "black", "king")
        game.board.place_one_piece(1, 4, "white", "knight")
        game.check("check mate", game.player[0], game.player[1])
        expect(game.situation_occuring).to eql(true)
        expect(game.game_over).to eql(true)
        expect(game.winner).to eql(game.player[0])

        game.board.clean
        game.board.place_one_piece(3, 5, "white", "king")
        game.board.place_one_piece(4, 4, "black", "pawn")
        game.check("check mate", game.player[1], game.player[0])
        expect(game.situation_occuring).to eql(true)
        expect(game.game_over).to eql(true)
        expect(game.winner).to eql(game.player[1])
    end
  end
end
