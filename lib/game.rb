#!/usr/bin/ruby

require "yaml"
require './lib/board'
require './lib/player'
require './lib/move'

class Game

  attr_accessor :board, :player, :situation_occuring, :game_over, :winner

  @@game_loaded = false
  @@file_to_save_and_load_game = "./lib/chess.yml"

  def initialize
    @board = Board.new
    @player = [Player.new("white"), Player.new("black")]
    @regex_field = /^[1-8][a-h]$/
    @situation_occuring = false # check or check mate (for testing purposes)
    @game_over = false
    @winner = ""
    @player_for_this_move = @player[0]
    @player_for_next_move = @player[1]
    @game_saved = false
  end

  def play
    @game_saved = false

    if @@game_loaded === false
      print_welcome_message
      select_player_names
    end

    @board.draw
    while @game_over == false do
      make_a_move(@player_for_this_move)
      break if @game_saved == true
      @board.draw
      check("check", @player_for_this_move, @player_for_next_move)
      check("check mate", @player_for_next_move, @player_for_this_move)
      @player_for_this_move, @player_for_next_move = @player_for_next_move, @player_for_this_move
    end
    announce_winner if @game_saved == false
  end

  def check(situation, winner, loser)
    @situation_occuring = false
    dangerous_piece = ""

    for i in 0..7 do
      for j in 0..7 do
        if @board.fields[i][j].color == loser.color && @board.fields[i][j].piece == "king"
          i_loser_king = i
          j_loser_king = j
        end
      end
    end

    for i in 0..7 do
      for j in 0..7 do
        if @board.fields[i][j].color == winner.color
          case @board.fields[i][j].piece
          when "rook"
            @situation_occuring = Move.possible_targets_rook(@board, i, j).include? [i_loser_king, j_loser_king]
            dangerous_piece = "rook"
          when "knight"
            @situation_occuring = Move.possible_targets_knight(i, j).include? [i_loser_king, j_loser_king]
            dangerous_piece = "knight"
          when "bishop"
            @situation_occuring = Move.possible_targets_bishop(@board, i, j).include? [i_loser_king, j_loser_king]
            dangerous_piece = "bishop"
          when "queen"
            @situation_occuring = Move.possible_targets_queen(@board, i, j).include? [i_loser_king, j_loser_king]
            dangerous_piece = "queen"
          when "king"
            @situation_occuring = Move.possible_targets_king(i, j).include? [i_loser_king, j_loser_king]
            dangerous_piece = "king"
          when "pawn"
            @situation_occuring = Move.possible_targets_pawn(@board, @board.fields[i][j].color, i, j).include? [i_loser_king, j_loser_king]
            dangerous_piece = "pawn"
          end

          if @situation_occuring
            2.times{print " "}; 49.times{print "#"}; print "\n"
            2.times{print " "}; print "#{situation.capitalize} for #{loser.name} by #{winner.name}'s #{dangerous_piece}!"; print "\n"
            2.times{print " "}; 49.times{print "#"}; print "\n"
            if (situation == "check mate")
              @game_over = true
              @winner = winner
            end
          end

        end
      end
    end
  end

  def self.load_game
    @@game_loaded = true
    YAML.load_file(@@file_to_save_and_load_game)
  end

  private

  def print_welcome_message
    2.times{print " "}; 49.times{print "#"}; print "\n"
    2.times{print " "}; 49.times{print "#"}; print "\n"
    2.times{print " "}; 49.times{print "#"}; print "\n"
    2.times{print " "}; 10.times{print "#"}
    print " Welcome to this chess game! "; 10.times{print "#"}; print "\n"
    2.times{print " "}; 49.times{print "#"}; print "\n"
    2.times{print " "}; 49.times{print "#"}; print "\n"
    2.times{print " "}; 49.times{print "#"}; print "\n"
  end

  def select_player_names
    2.times{print " "}; print "Give the name of the first player. Type 'computer' if the first player is the computer."; print "\n"
    2.times{print " "}; @player[0].name = gets.chomp
    2.times{print " "}; 49.times{print "#"}; print "\n"
    2.times{print " "}; print "Welcome #{@player[0].name}. Your color is #{@player[0].color}."; print "\n"
    2.times{print " "}; 49.times{print "#"}; print "\n"
    2.times{print " "}; print "Give the name of the second player. Type 'computer' if the second player is the computer."; print "\n"
    2.times{print " "}; @player[1].name = gets.chomp
    2.times{print " "}; 49.times{print "#"}; print "\n"
    2.times{print " "}; print "Welcome #{@player[1].name}. Your color is #{@player[1].color}."; print "\n"
    2.times{print " "}; 49.times{print "#"}; print "\n"
    2.times{print " "}; print "Press any key to continue "
    STDIN.getc
  end

  def make_a_move(player)
    2.times{print " "}; print "#{player.name.capitalize}, it is your turn."; print "\n"

    if player.name == 'computer'
      move = find_move_computer(player) # Returns a random valid move
    else
      valid_move = false
      while valid_move == false do

        # Select a start and target fields or save and end the game
        field = selected_field("start")
        return if @game_saved == true
        i_start = field[0]
        j_start = field[1]
        field = selected_field("target")
        return if @game_saved == true
        i_target = field[0]
        j_target = field[1]

        # Initialize a move and check it
        move = Move.new(@board, player.color, i_start, j_start, i_target, j_target)
        move.check
        if move.error_message != ""
          2.times{print " "}; print "#{move.error_message}"; print "\n"
        else
          valid_move = true
        end
      end
    end

    # Check if an opponent is removed
    if move.target_occupied_by_opponent == true
      opponent = "#{@board.fields[i_target][j_target].color.capitalize} #{@board.fields[i_target][j_target].piece}"
      2.times{print " "}; 49.times{print "#"}; print "\n"
      2.times{print " "}; print "#{opponent} removed."; print "\n"
      2.times{print " "}; 49.times{print "#"}; print "\n"
    end

    # Make the move
    move.execute
  end

  def selected_field(start_or_target)
    valid_field = false
    while valid_field == false do
      2.times{print " "}; print "Select a #{start_or_target} field, e.g. 1b or press enter to save and end the game."; print "\n"
      2.times{print " "}; field = gets.chomp
      if (field == "")
        save_game
        @game_saved = true
        return
      elsif (field =~ @regex_field) == 0
        valid_field = true
      else
        2.times{print " "}; print "Invalid field."; print "\n"
      end
    end

    field_as_array = []
    field_as_array[0] = field[0].to_i - 1
    field_as_array[1] = field[1].ord - 97
    return field_as_array
  end

  def announce_winner
    2.times{print " "}; print "#{@winner.name.capitalize} is the winner! Congratulations! Game over!"; print "\n"
    2.times{print " "}; 49.times{print "#"}; print "\n"
  end

  def save_game
    file = File.open(@@file_to_save_and_load_game, "w")
    file.puts YAML::dump(self)
    file.close
    2.times{print " "}; 49.times{print "#"}; print "\n"
    2.times{print " "}; print "Game saved to #{@@file_to_save_and_load_game}."; print "\n"
    2.times{print " "}; 49.times{print "#"}; print "\n"
  end

  def find_move_computer(player)
    possible_start_fields = []
    for i in 0..7 do
      for j in 0..7 do
        possible_start_fields << [i, j] if @board.fields[i][j].color == player.color
      end
    end

    target_field_found = false

    while target_field_found == false do

      start_field = possible_start_fields[rand(possible_start_fields.length)]
      i_start = start_field[0]
      j_start = start_field[1]

      possible_target_fields = []

      case @board.fields[i_start][j_start].piece
      when "rook"
         possible_target_fields = Move.possible_targets_rook(@board, i_start, j_start)
      when "knight"
        possible_target_fields = Move.possible_targets_knight(i_start, j_start)
      when "bishop"
        possible_target_fields = Move.possible_targets_bishop(@board, i_start, j_start)
      when "queen"
        possible_target_fields = Move.possible_targets_queen(@board, i_start, j_start)
      when "king"
        possible_target_fields = Move.possible_targets_king(i_start, j_start)
      when "pawn"
        possible_target_fields = Move.possible_targets_pawn(@board, @board.fields[i_start][j_start].color, i_start, j_start)
      end

      possible_target_fields.select! {|field| @board.fields[field[0]][field[1]].color != player.color} # avoid target fields which are occupied by the same color

      target_field_found = true if possible_target_fields.length != 0
    end

      target_field = possible_target_fields[rand(possible_target_fields.length)]
      i_target = target_field[0]
      j_target = target_field[1]

      2.times{print " "}; 49.times{print "#"}; print "\n"
      2.times{print " "}; print "The computer is moving the #{@board.fields[i_start][j_start].piece} from (#{i_start + 1}, #{(j_start + 97).chr('UTF-8')}) to (#{i_target + 1}, #{(j_target + 97).chr('UTF-8')})."; print "\n"
      2.times{print " "}; 49.times{print "#"}; print "\n"

      move = Move.new(@board, player.color, i_start, j_start, i_target, j_target)
      move.piece = @board.fields[i_start][j_start].piece
      return move
    end
end


puts "Do you want to load an existing game? If yes, please type 'load' otherwise press enter."
option = gets.chomp
if option === "load"
  g = Game.load_game
  2.times{print " "}; 49.times{print "#"}; print "\n"
  2.times{print " "}; print "Game loaded."; print "\n"
  2.times{print " "}; 49.times{print "#"}; print "\n"
else
  g = Game.new
end
g.play
