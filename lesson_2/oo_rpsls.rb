require "yaml"
MSG = YAML.load_file("oo_rpsls.yml")

module Displayable
  def output(message)
    animation(message)
    puts
    sleep(1)
  end

  def display_welcome
    output(MSG["welcome"])
    puts
  end

  def display_challenge
    system("clear")
    output("It's time, #{human.name}."\
     " Your opponent is #{computer.name}, the #{computer.title}.")
    output("The first to win #{score.max_score} games is the grand winner."\
    " Let's get started.")
    puts
  end

  def display_goodbye
    output(MSG["goodbye"])
  end

  def display_moves
    puts
    puts "#{human.name} has chosen #{human.move}."
    sleep(1)
    puts "#{computer.name} has chosen #{computer.move}."
    sleep(1)
    puts
  end

  def display_move_history
    output("Moves played by #{human.name} so far: #{human.move_history}")
    output("Moves played by #{computer.name} so far: #{computer.move_history}")
    puts
  end

  def display_winner
    if human.winner?(computer)
      display_human_win
    elsif computer.winner?(human)
      display_computer_win
    else
      output("It's a tie!")
    end
  end

  def display_score
    puts
    output("#{human.name}: #{score.human} |"\
       " #{computer.name}: #{score.computer}")
    puts
  end

  def display_grand_winner
    if score.human > score.computer
      human_win_message
    else
      computer_win_message
    end
  end

  private

  def animation(message)
    chars = message.to_s.chars
    chars.each_with_index do |chr, idx|
      if chars[idx - 1] == "." || chars[idx - 1] == "|"
        sleep(0.5)
        print chr
      else
        print chr
        sleep(0.05)
      end
    end
  end

  def display_human_win
    output(MSG["#{human.move}_#{computer.move}"])
    output("And this round's winner is #{human.name}!")
  end

  def display_computer_win
    output(MSG["#{computer.move}_#{human.move}"])
    output("And this round's winner is #{computer.name}!")
  end

  def human_win_message
    output("#{human.name} is the grand winner with a score "\
       "of #{score.human} against #{score.computer}.")
    output("Congratulations. There's still hope for humankind.")
    output("(At least when it comes to rock, paper, and scissors...)")
    puts
  end

  def computer_win_message
    output("#{computer.name} is the grand winner with a score "\
      "of #{score.computer} against #{score.human}.")
    output("Programmers like you are responsible "\
      "for the triumph of computers over humankind. Congratulations.")
    puts
  end
end

class Player
  include Displayable

  attr_accessor :name, :move
  attr_reader :move_history

  def initialize
    set_name
    @move = move
    @move_history = []
  end

  def winner?(other_player)
    move > other_player.move
  end

  def reset_history
    self.move_history = []
  end

  private

  attr_writer :move_history
end

class Human < Player
  def set_name
    name = nil
    loop do
      output("Please type your name:")
      name = gets.chomp.strip
      break unless name.empty?
      output("Name cannot be empty.")
    end
    puts
    self.name = name
  end

  def choose
    choice = nil
    loop do
      output(MSG["move_choice"])
      choice = gets.capitalize.chomp
      break if Move::MOVES.include?(choice)
      output("Sorry, invalid choice. Try again.")
    end
    self.move = Move.new(choice)
    move_history << move.value
  end
end

class Computer < Player
  attr_reader :title
  attr_accessor :ai_engine, :opponent

  def initialize(opponent)
    @ai_engine = [Engines::Hal9000.new(opponent),
                  Engines::R2D2.new(opponent),
                  Engines::Deckard.new(opponent),
                  Engines::WallE.new(opponent),
                  Engines::Skynet.new(opponent)].sample
    super()
    @title = ai_engine.title
    @opponent = opponent
  end

  def choose
    self.move = Move.new(ai_engine.personality(opponent))
    move_history << move.value
  end

  def set_name
    self.name = ai_engine.name
  end
end

module Engines
  class Hal9000 < Computer
    # Personality: Scissor-hands. Only chooses Scissors.

    def initialize(opponent)
      @name = "Hal-9000"
      @title = "scissor-hands"
      @opponent = opponent
      @personality = personality(opponent)
    end

    def personality(_opponent)
      "Scissors"
    end
  end

  class R2D2 < Computer
    # Personality: Randomizer. Chooses randomly.

    def initialize(opponent)
      @opponent = opponent
      @name = "R2D2"
      @title = "randomizer"
      @personality = personality(opponent)
    end

    def personality(_opponent)
      Move::MOVES.sample
    end
  end

  class WallE < Computer
    # Personality: Rock dispenser. Only chooses Rock.

    def initialize(opponent)
      @opponent = opponent
      @name = "Wall-E"
      @title = "rock dispenser"
      @personality = personality(opponent)
    end

    def personality(_opponent)
      "Rock"
    end
  end

  class Deckard < Computer
    # Personality: Replicates human moves (believing he is human).
    # Draws over 80% of the time.

    def initialize(opponent)
      @opponent = opponent
      @name = "Deckard"
      @title = "replicant"
      @personality = personality(opponent)
    end

    def personality(opponent)
      [[opponent.move.to_s] * 4, Move::MOVES.sample].flatten.sample
    end
  end

  class Skynet < Computer
    # Personality: Invincible. Wins over 90% of the time.

    def initialize(opponent)
      @opponent = opponent
      @name = "Skynet"
      @title = "invincible"
      @personality = personality(opponent)
    end

    def personality(opponent)
      [[winning_move(opponent)] * 9, Move::MOVES.sample].flatten.sample
    end

    def winning_move(opponent)
      case opponent.move.to_s
      when "Rock" then ["Spock", "Paper"].sample
      when "Paper" then ["Scissors", "Lizard"].sample
      when "Scissors" then ["Spock", "Rock"].sample
      when "Lizard" then ["Scissors", "Rock"].sample
      when "Spock" then ["Lizard", "Paper"].sample
      end
    end
  end
end

class Move
  attr_reader :value

  MOVES = ["Rock", "Paper", "Scissors", "Lizard", "Spock"]

  def initialize(value)
    @value = value
  end

  def to_s
    value
  end

  def >(other_move)
    rock_wins(other_move) ||
      paper_wins(other_move) ||
      scissors_wins(other_move) ||
      lizard_wins(other_move) ||
      spock_wins(other_move)
  end

  def rock_wins(other_move)
    (value == "Rock" && (other_move.value == "Scissors" ||
      other_move.value == "Lizard"))
  end

  def paper_wins(other_move)
    (value == "Paper" && (other_move.value == "Rock" ||
      other_move.value == "Spock"))
  end

  def scissors_wins(other_move)
    (value == "Scissors" && (other_move.value == "Paper" ||
       other_move.value == "Lizard"))
  end

  def lizard_wins(other_move)
    (value == "Lizard" && (other_move.value == "Paper" ||
      other_move.value == "Spock"))
  end

  def spock_wins(other_move)
    (value == "Spock" && (other_move.value == "Rock" ||
      other_move.value == "Scissors"))
  end
end

class Score
  include Displayable

  attr_accessor :human, :computer, :winner, :max_score

  def initialize(human: 0, computer: 0, max_score: 1)
    @human = human
    @computer = computer
    @max_score = max_score
  end

  def update(human, computer)
    if human.winner?(computer)
      self.human += 1 if self.human < max_score
    elsif computer.winner?(human)
      self.computer += 1 if self.computer < max_score
    else
      max?
    end
  end

  def max?
    human == max_score || computer == max_score
  end

  def reset
    self.human = 0
    self.computer = 0
  end
end

class RPSGame
  include Displayable

  attr_reader :human, :computer, :score

  def initialize
    display_welcome
    @human = Human.new
    @computer = Computer.new(human)
    @score = Score.new
  end

  def number_of_rounds
    answer = nil
    output("Thanks, #{human.name}.")
    loop do
      output("How many rounds do you want the game to last?")
      answer = gets.chomp
      break if answer == answer.to_i.to_s && answer.to_i.positive?
      output("Invalid answer. Please type a numeric character greater than 0.")
    end
    score.max_score = answer.to_i
    output("Thank you. Loading......")
  end

  def play
    loop do
      number_of_rounds
      display_challenge
      game_loop
      break unless play_again?
    end
    display_goodbye
  end

  def game_loop
    loop do
      single_round
      display_move_history
      break if end_game?
    end
  end

  def single_round
    game_match
    score_update
  end

  def game_match
    human.choose
    computer.choose
    display_moves
    display_winner
  end

  def score_update
    score.update(human, computer)
    display_score
  end

  def end_game?
    if score.max?
      display_grand_winner
      score.reset
      human.reset_history
      computer.reset_history
    else
      false
    end
  end

  def play_again?
    answer = nil
    loop do
      output("#{human.name}, would you like to play again"\
      " against #{computer.name}? (yes/no)")
      answer = gets.downcase.chomp
      break if answer == "yes" || answer == "no"
      output("Answer invalid. Please type 'yes' or 'no'.")
    end
    reset_game_environment if answer == "yes"
  end

  def reset_game_environment
    output("Resetting history.....")
    system("clear")
  end
end

system("clear")
RPSGame.new.play
