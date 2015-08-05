class Board
  attr_reader :board, :solution, :pegs

  def initialize
    # - is a hint space
    # X is a blank space

    @hints = Array.new(12) { Array.new(4) {"-"} }
    @board = Array.new(12) { Array.new(4) {"X"} }
    @pegs = ["R", "G", "B", "T", "O", "M", "K", "E"]

    solution
  end

  def render
    # renders 12 rows
    # 4 columns for each peg
    puts
    12.times do |row|
      4.times do |column|
        print "#{ @board[row][column] }"
      end
      print "\s\s"

      4.times do |column|
        print "#{@hints[row][column]}"
      end
      puts
    end
    puts
    puts "Pegs:"

    # prints possible colored pegs
    8.times do |peg|
      print ( @pegs[peg] + "\s")
    end
    puts "\n\n"
  end

  def place_peg(input)
    # sets first element to input
    @board[0] = input

    # grabs hints for input
    @hints[0] = new_hint(input)

    # rotate input and hints to the 12th element
    @board.rotate!
    @hints.rotate!
  end

  def new_hint(input)
    new_hint = []

    # if current peg is in correct position, give hint as "*"
    # if current peg is in the solution but not in the correct solution, give hint as "!"
    # if current peg is not in the solution, return "-"
    4.times do |index|
      if @solution[index] == input[index]
        new_hint << "*"
      elsif @solution.include?(input[index])
        new_hint << "!"
      else
        new_hint << "-"
      end
    end

    new_hint
  end

  def solution
    # generates winning solution
    @solution = @pegs.sample(4)
  end

  def winner?
    # checks last element against solution to see if the player has guessed the solution
    board[11] == @solution
  end

end

class Player

  def initialize(board)
    @board = board
  end

  def place_peg(board)
  end

  def take_turn
    input = []

    # ensures that the input is valid, or the player can quit
    until valid_turn?(input)
      puts "Enter your pegs or 'q' to quit."
      input = gets.chomp.upcase.chars
      if input == 'Q'
        exit
      end

      unless valid_turn?(input)
        puts "Not a valid input"
      end
    end

    # returns input to place_peg method
    @board.place_peg(input)
  end

  def valid_turn?(input)
    # checks if the input is valid
    input.uniq.length == 4 && input.length == 4 && (input & @board.pegs).length == 4
  end

end

class Computer

  def initialize(board)
    @game = board
  end

  def take_turn
    # chooses a random set of 4 pegs
    @game.place_peg(["R", "G", "B", "T", "O", "M", "K", "E"].sample(4))
  end

end

class Game

  def play
    game = Board.new
    puts "Would you like to play? (y) or watch the computer? (n)"
    start_play = gets.chomp

    # asks player if he/she wants to play or watch a computer play
    until start_play == "y" || start_play == "n"
      puts "Please enter a valid input."
      start_play = gets.chomp
    end

    if start_play == "y"
      player = Player.new(game)
    else
      player = Computer.new(game)
    end

    12.times do
      system "clear"
      game.render
      player.take_turn

      # timer primarily for computer made moves
      sleep(0.5)

      if game.winner?
        system "clear"
        game.render
        puts "You Win!"
        break
      end

    end

    unless game.winner?
      system "clear"
      puts "You lost!"
      game.render
      print "The solution pegs were: \s"
      4.times do |peg|
        print(game.solution[peg] + "\s")
      end
      puts
    end
  end
end

game = Game.new
game.play