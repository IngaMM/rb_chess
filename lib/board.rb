#!/usr/bin/ruby
require './lib/field'

class Board

  attr_accessor :fields

  UNI = {
    white:
    {rook: "\u2656",
     knight: "\u2658",
     bishop: "\u2657",
     queen: "\u2655",
     king: "\u2654",
     pawn: "\u2659"
    },
    black:
    {rook: "\u265C",
     knight: "\u265E",
     bishop: "\u265D",
     queen: "\u265B",
     king: "\u265A",
     pawn: "\u265F"
   },
   none:
   {none: " "}
  }

  def initialize
    @fields =
    [[Field.new("white", "rook"), Field.new("white", "knight"), Field.new("white", "bishop"),
      Field.new("white", "queen"), Field.new("white", "king"),
      Field.new("white", "bishop"), Field.new("white", "knight"), Field.new("white", "rook")],
     [Field.new("white", "pawn"), Field.new("white", "pawn"), Field.new("white", "pawn"),
      Field.new("white", "pawn"), Field.new("white", "pawn"), Field.new("white", "pawn"),
      Field.new("white", "pawn"), Field.new("white", "pawn")],
     [Field.new, Field.new, Field.new, Field.new, Field.new, Field.new, Field.new, Field.new],
     [Field.new, Field.new, Field.new, Field.new, Field.new, Field.new, Field.new, Field.new],
     [Field.new, Field.new, Field.new, Field.new, Field.new, Field.new, Field.new, Field.new],
     [Field.new, Field.new, Field.new, Field.new, Field.new, Field.new, Field.new, Field.new],
     [Field.new("black", "pawn"), Field.new("black", "pawn"), Field.new("black", "pawn"),
      Field.new("black", "pawn"), Field.new("black", "pawn"), Field.new("black", "pawn"),
      Field.new("black", "pawn"), Field.new("black", "pawn")],
     [Field.new("black", "rook"), Field.new("black", "knight"), Field.new("black", "bishop"),
      Field.new("black", "queen"), Field.new("black", "king"),
      Field.new("black", "bishop"), Field.new("black", "knight"), Field.new("black", "rook")]]
  end

  def draw
    print_letter_line
    for i in (7).downto(0)
      print_section_line_1
      print_section_line_2
      print_piece_line(i)
      print_section_line_2
    end
    print_section_line_1
    print_letter_line
  end

  def clean
    # For testing purposes
    for i in 0..7
      for j in 0..7
        @fields[i][j].clear
      end
    end
  end

  def place_one_piece(i, j, color, piece)
    # For testing purposes
    @fields[i][j].occupy(color, piece)
  end

  private
  def print_letter_line
    5.times{print " "}; print "a"; 5.times{print " "}; print "b"
    5.times{print " "}; print "c"; 5.times{print " "}; print "d"
    5.times{print " "}; print "e"; 5.times{print " "}; print "f"
    5.times{print " "}; print "g"; 5.times{print " "}; print "h"
    3.times{print " "}; print "\n"
  end

  def print_section_line_1
    2.times{print " "}; 49.times{print "#"}; print "\n"
  end

  def print_section_line_2
    2.times{print " "};
    8.times{print "#"; 5.times{print " "}}
    print "#"; print "\n"
  end

  def print_piece_line(i)
    print i+1; print " ";
    for j in 0..7
      print "#"; 2.times{print " "}
      print UNI[@fields[i][j].color.to_sym][@fields[i][j].piece.to_sym].encode('utf-8')
      2.times{print " "}
    end
    print "#"; print " "; print i+1; print "\n"
  end

end
