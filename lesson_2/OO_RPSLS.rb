
require "yaml"
MSG = YAML.load_file("OO_RPSLS.yml")

module Displayable

  def output(message)
    chars = message.chars
    chars.each_with_index do |chr,idx|
      if chars[idx - 1] == "." || chars[idx -1] == "|"
        sleep(0.5)
        print chr
      else
        print chr
        sleep(0.05)
      end
    end
    puts
    sleep(1)
  end

  def display_welcome
    output(MSG["welcome"])
    puts
  end

  def display_challenge(human, computer)
    output("Hello, #{human.name}."\
     " Your opponent is the #{computer.title} #{computer.name}.")
    output("The first to win #{Score::MAX_SCORE} games will be the grand winner."\
    " Let's get started.")
    puts 
  end

  def display_goodbye
    output(MSG["goodbye"])
  end

  def display_moves(human, computer)
    puts
    puts "#{human.name} has chosen #{human.move}."
    sleep(1)
    puts "#{computer.name} has chosen #{computer.move}."
    sleep(1); puts
  end

  def display_winner(human, computer)
    if human.winner?(computer)
      output(MSG["#{human.move}_#{computer.move}"])
      output("And the winner is #{human.name}!")
    elsif computer.winner?(human)
      output(MSG["#{computer.move}_#{human.move}"])
      output("And the winner is #{computer.name}!")
    else
     output("It's a tie!")
    end
  end

  def display_score(human, computer, score)
    puts
    output("#{human.name} : #{score.human} | #{computer.name}: #{score.computer}")
    puts
  end

  def display_grand_winner(human, computer, score)
    if score.human > score.computer
      output("#{human.name} is the grand winner with a score of #{score.human} against #{score.computer}.")
      output("Congratulations. There's still hope for humans.")
      output("(At least when it comes to rock, paper, and scissors...)")
      puts
    else
      output("#{computer.name} is the grand winner with a score of #{score.computer} against #{score.human}.")
      output("Programmers like you are responsible "\
       "for the triumph of computers over humans. Congratulations.")
       puts
    end
  end
end

class RPSGame
  include Displayable

  attr_accessor :human, :computer, :scoreboard, :score
  attr_reader :display

  def initialize
    # @display = MessageDisplay.new
    # @scoreboard = MessageDisplay.new
    display_welcome
    @human = Human.new
    @computer = Computer.new
    @score = Score.new
  end

  def play
    loop do 
      system("clear")
      display_challenge(human, computer)
      loop do
        human.choose
        computer.choose
        display_moves(human, computer)
        display_winner(human, computer)
        score.update(human, computer)
        display_score(human, computer, score)
        if score.max? 
          (display_grand_winner(human, computer, score))
          score.reset
          break
        end
      end
      break unless play_again?(human, computer)
    end 
    display_goodbye
  end

  def play_again?(human, computer)
    answer = nil
    loop do
      output("#{human.name}, would you like to play again against #{computer.name}? (yes/no)")
      answer = gets.downcase.chomp
      break if answer == "yes" || answer == "no"
      output("Answer invalid. Please type 'yes' or 'no'.")
    end
    answer == "yes"
  end
end

class Player
  include Displayable
  
  attr_accessor :move, :name

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
      output("Please type your name:")
      name = gets.chomp
      break unless name.empty?
      output("Name cannot be empty.")
    end
    name
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
  end
end

class Computer < Player
  attr_reader :title
  def initialize
    super
    @title = ['well-oiled', 'calculating', 'never-halting', 'rusty'].sample
  end

  def get_name
    self.name = ["Hal-9000", "Wall-E", "Deep Blue", "Deckard", "R2-D2"].sample
  end

  def choose
    self.move = Move.new(Move::MOVES.sample)
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
    (value == "Rock" && (other_move.value == "Scissors" || other_move.value == "Lizard")) ||
      (value == "Paper" && (other_move.value == "Rock" || other_move.value =="Spock")) ||
      (value == "Scissors" && (other_move.value == "Paper" || other_move.value == "Lizard")) ||
      (value == "Lizard" && (other_move.value == "Paper" ||other_move.value == "Spock")) ||
      (value == "Spock" && (other_move.value == "Rock" || other_move.value == "Scissors"))
  end
end


class Score
  MAX_SCORE = 10
  attr_accessor :human, :computer, :winner

  def initialize(max_score: 0, human: 0, computer: 0)
    @human = human
    @computer = computer
  end

  def update(human, computer)
    if human.winner?(computer)
      self.human += 1 if self.human < MAX_SCORE
    elsif computer.winner?(human)
      self.computer += 1 if self.computer< MAX_SCORE
    else
      max?
    end
  end

  def max?
    human == MAX_SCORE || computer == MAX_SCORE
  end

  def reset
    self.human = 0
    self.computer = 0
  end
end



class Rule
  def print; end
end

system("clear")
RPSGame.new.play

