=begin

**Class:** RPSGame (orchestration engine)
	 **Objects**: new game instances
		 **attributes**: human player (Player.new)
											 computer player (Player.new)
											 display (MessageDisplay.new)
											 scoreboard (MessageDisplay.new)
	   **behaviors**: initialize (constructor)
										 play(start gameplay)
										 play_again?(continue/break gameplay loop)
  **Collaborator objects**: Player, Display

**Class:** Player
	**Objects:** Players (via subclasses)
		**attributes**:
										 name
										 move 
  **behaviors:** initialize (constructor)
	**Collaborator objects:** Move (via subclasses)

**Class:** Human < Player
	**Objects:** human players
		**attributes**: name, move (inherited from Player)
	  **behaviors:** 
										 get_name(initialize @name)
										 choose (pick a move)
**Collaborator objects:** Move 

**Class:** Computer < Player
	**Objects:**  computer players
		**attributes**: name, move (inherited from Player)
	  **behaviors:** 
										 get_name(initialize @name)
										 choose (pick a move)
**Collaborator objects:** Move

**Class:** Move
	**Objects:**  moves
		**attributes**: value
	  **behaviors:** 
										 initialize (constructor)
										 compare moves (greater than)
										 custom string representation
**Collaborator objects:** Move

**Class:** MessageDisplay
	**Objects**: display devices
		**attributes**: none relevant
	  **behaviors**: welcome (display welcome message)
										 goodbye (display goodbye message)
										 display_moves (display move chosen)
										 display_winner (display win status)
										
  **Collaborator objects**: none relevant

**Class:** Rule
		**Objects**: rules
		**attributes:** none relevant
=end


class RPSGame
	attr_accessor :human, :computer, :scoreboard
  attr_reader :display
	
	def initialize
    @display = MessageDisplay.new
    @scoreboard = MessageDisplay.new
    display.welcome
    @human = Player.new
		@computer = Player.new(player_type = :computer)
    display.challenge(human, computer)
	end

	def play
    loop do 
      human.choose
      computer.choose
      display.display_moves(human, computer)
      scoreboard.display_winner(human, computer)
      break unless play_again?
    end
		display.goodbye
	end

  def play_again?
    answer = ""
    loop do 
      puts "Would you like to play again? (yes/no)"
      answer = gets.downcase.chomp 
      break if answer == "yes" || answer == "no"
      puts "Answer invalid. Please type 'yes' or 'no'."
    end
      answer == "yes" ? true : false
  end
end

class Player
  attr_reader :player_type, :name
  attr_accessor :move

	def initialize(player_type = :human)
    @player_type = player_type
    @name = get_name
	end

  def human?
    player_type == :human
  end

  def get_name
    name = ""
    if self.player_type == :computer
      name = ["Hal-9000", "Wall-E", "Deep Blue", "Deckard", "R2-D2"].sample
    else 
      loop do 
        puts "Please type your name:"
        name = gets.chomp
        break unless name.empty?
        puts "Name cannot be empty."
        sleep(1)
      end
      name
    end
  end

	def choose
    moves = ["rock", "paper", "scissors"]
    if human? 
      choice = nil
      loop do
        sleep(1)
        puts
        puts "Please  type 'rock', 'paper', or 'scissors':"
        choice = gets.downcase.chomp
        break if moves.include?(choice)
        puts "Sorry, invalid choice. Try again."
        sleep(1)
        puts
        system("clear")
      end
      self.move = choice
    else
      self.move = moves.sample
    end
	end
  
  def tie?(other_player)
    self.move == other_player.move
  end

  def winner?(other_player)
    (self.move == "rock" && other_player.move == "scissors") ||
    (self.move == "paper" && other_player.move == "rock") ||
    (self.move == "scissors" && other_player.move == "paper")
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
    puts "All right, #{human.name}. Your opponent today is the #{["well-oiled", "awe-inspiring", "invincible", "never-halting", "calculating", "rusty"].sample} #{computer.name}. Let's get started."
  end

  def goodbye
    puts
    sleep(1)
    puts "Thanks for playing. Goodbye!"
  end

  def display_winner(human, computer)
    if human.tie?(computer)
      puts "It's a tie!"
      sleep(1)
      puts
    elsif human.winner?(computer)
      puts "And the winner is #{human.name}!"
      sleep(1)
      puts
    else
      puts "And the winner is #{computer.name}!"
      sleep(1)
      puts
    end
  end

  def display_moves(human, computer)
    puts
    puts "#{human.name} has chosen #{human.move}."
    sleep(1)
    puts "#{computer.name} has chosen #{computer.move}."
    sleep(1)
    puts
  end
end

class Move
	def initialize(kind)
	end
	
	def compare(move1, move2)
	end
end

class Rule
	def print
	end

end

system("clear")
RPSGame.new.play


