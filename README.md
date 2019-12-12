Chess

By I. Mahle

A project of The Odin Project: https://www.theodinproject.com/courses/ruby-programming/lessons/ruby-final-project

Instructions

1. Run ruby ./lib/game.rb
2. Follow the instructions to play the game

To run the tests with Rspec: Comment out the last part in lib/game.rb (from puts "Do you want..." onwards). Change back into the root directory of the program and type rspec in the console.

Discussion
I used the following technologies: Ruby with classes, methods and (de-)serialization. Testing with Rspec.

This is a command line chess game where two players (computer and/or human) can play against each other. The game can be saved at any time and later continued. No illegal moves are allowed and check or check mate are declared in the correct situations. The computer has a simple intelligence and makes a random legal move. Important parts of the program are tested with Rspec.

Requirements
Ruby, Rspec for testing
