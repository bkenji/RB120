class RPSGame
  attr_accessor :human, :computer, :scoreboard
  attr_reader :display

  def initialize
    @display = MessageDisplay.new
    @scoreboard = MessageDisplay.new
    display.welcome
    @human = Human.new
    @computer = Computer.new
  end

  def play
    display.challenge(human, computer)
    loop do
      human.choose
      computer.choose
      display.moves(human, computer)
      scoreboard.display_winner(human, computer)
      break unless play_again?
    end
    display.goodbye
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (yes/no)"
      answer = gets.downcase.chomp
      break if answer == "yes" || answer == "no"
      puts "Answer invalid. Please type 'yes' or 'no'."
    end
    answer == "yes"
  end
end

class Player
  attr_reader :name
  attr_accessor :move

  def initialize
    @name = get_name
    @move = move
  end

  def winner?(other_player)
    self.move > other_player.move
  end
end

class Human < Player
  def get_name
    name = nil
    loop do
      puts "Please type your name:"
      name = gets.chomp
      break unless name.empty?
      puts "Name cannot be empty."
      sleep(1)
    end
    name
  end

  def choose
    choice = nil
    loop do
      sleep(1); puts
      puts "Please  type 'rock', 'paper', or 'scissors':"
      choice = gets.downcase.chomp
      break if Move::MOVES.include?(choice)
      puts "Sorry, invalid choice. Try again."
      sleep(1); puts; system("clear")
    end
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def get_name
    ["Hal-9000", "Wall-E", "Deep Blue", "Deckard", "R2-D2"].sample
  end

  def choose
    self.move = Move.new(Move::MOVES.sample)
  end
end

class Move
  attr_reader :value

  MOVES = ["rock", "paper", "scissors"]

  def initialize(value)
    @value = value
  end

  def to_s
    value
  end

  def >(other_move)
    (value == "rock" && other_move.value == "scissors") ||
      (value == "paper" && other_move.value == "rock") ||
      (value == "scissors" && other_move.value == "paper")
  end
end

class MessageDisplay
  def welcome
    sleep(1)
    puts "Hello, and welcome to Rock, Paper, Scissors!"
    puts
    sleep(1)
  end

  def challenge(human, computer)
    puts "All right, #{human.name}. Your opponent today is the "\
    "#{['well-oiled', 'calculating', 'never-halting', 'rusty'].sample}"\
    " #{computer.name}. Let's get started."
  end

  def goodbye
    puts; sleep(1)
    puts "Thanks for playing. Goodbye!"
  end

  def display_winner(human, computer)
    if human.winner?(computer)
      puts "And the winner is #{human.name}!"
      sleep(1); puts
    elsif computer.winner?(human)
      puts "And the winner is #{computer.name}!"
      sleep(1); puts
    else
      puts "It's a tie!"
    end
  end

  def moves(human, computer)
    puts
    puts "#{human.name} has chosen #{human.move}."
    sleep(1)
    puts "#{computer.name} has chosen #{computer.move}."
    sleep(1); puts
  end
end

class Rule
  def print; end
end

system("clear")
RPSGame.new.play

# ALGORITHM: Player class
# - Objects from the Player class are instantiated with the attributes `score` (defaulted to 0 upon instantiation) and `name`` (whose getter interface is to be accessed in greetings)
# -  the behavior `choose` allows a player to choose between `rock`, `paper`, or `scissors` moves.
#   - If the player is human, the choice is made via user input
#   - If the player is a computer, the choice is made randomly. (this seems to suggest that a method `is_human?`, allowing access to an attribute `player_type`,  may be desirable)
  # BEHAVIOR: Choose move
  # - If the player is human , get user input
  # - If the player is not human , choose move randomly between the following choices:
  #   - rock (r), paper (p), or scissors (s)