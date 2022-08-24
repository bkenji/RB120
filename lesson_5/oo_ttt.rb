module Displayable
  def output(message)
    animation(message)
    puts
    sleep(1)
  end

  def display_welcome
    output("Hello, and welcome to Tic-Tac-Toe!")
    puts
  end

  def display_challenge
    system("clear")
    output("Your opponent is #{computer.name}, the #{computer.title}.")
    output("The first to win #{max_score} games is the grand winner."\
    " Let's get started.")
    system("clear")
  end

  def display_squares(board)
    if board.available.size > 1
      "#{board.available[0...-1].join(', ')} or #{board.available[-1]}."
    else
      board.available.join
    end
  end

  def display_plays_first
    output("Okay. #{current_player == human ? 'Human' : 'Computer'}"\
    " plays first. Loading....")
    system("clear")
  end

  def invalid_move(board)
    system("clear")
    board.display
    puts "Invalid choice. Please try again."
    sleep(1)
    system("clear")
    board.display
  end

  def invalid_answer_play_again
    puts "Answer invalid. Please type 'yes' or 'no'."
    sleep(1)
  end

  def display_winner
    output("#{current_player} is the winner.")
  end

  def display_score
    output("#{human.name}: #{human.score} |"\
    " #{computer.name}: #{computer.score}")
    sleep(0.5)
  end

  def display_grand_winner
    if human.score > computer.score
      human_win_message
    else
      computer_win_message
    end
  end

  def display_goodbye
    output("Thanks for playing. Goodbye!")
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
        sleep(0.045)
      end
    end
  end

  def human_win_message
    output("#{human.name} is the grand winner with a score "\
       "of #{human.score} against #{computer.score}.")
    output("Congratulations. There's still hope for humankind.")
    puts
  end

  def computer_win_message
    output("#{computer.name} is the grand winner with a score "\
      "of #{computer.score} against #{human.score}.")
    output("This victory can only be attributable to human error. "\
      "Thanks for your cooperation.")
    puts
  end
end

module AiEngine
  attr_accessor :human, :computer

  def move(board)
    if offensive_threat?(board, safety)
      attack(board)
    elsif defensive_threat?(board, safety)
      defense(board)
    elsif board.available.include?(5)
      center_move(board)
    else
      random_move(board)
    end
  end

  def defensive_threat?(board, safety)
    human_moves = board.squares.select do |_, sq|
      sq.value == opponent_marker
    end.keys
    threat_analysis(board, safety, human_moves)
    threat
  end

  def offensive_threat?(board, safety)
    threat_analysis(board, safety, moves)
    threat
  end

  def threat_analysis(board, safety, squares)
    TTTGame::WINNING_LINES.each do |line|
      safe_margin = line.difference(squares)
      safety = safe_margin if safe_margin.size <= safety.size
      open_sq = board.squares[safety.first].value == Board::INITIAL_STATE
      self.threat = safety.first if safety.size == 1 && open_sq
    end
  end

  def center_move(board)
    moves << 5
    board.update(5, marker)
    output("Calculating optimal square...")
    sleep(0.5)
    system("clear")
    board.display
    sleep(0.5)
  end

  def random_move(board)
    square = board.available.sample
    moves << square
    board.update(square, marker)
    puts " #{name} analyzing board..."
    sleep(1)
    system("clear")
    board.display
    sleep(0.5)
  end

  def defense(board)
    moves << threat
    board.update(threat, marker)
    puts "#{name} analyzing board..."
    sleep(0.5)
    output("Threat detected. Activate defense.") if threat
    self.threat = nil
    system("clear")
    board.display
    sleep(0.5)
  end

  def attack(board)
    moves << threat
    board.update(threat, marker)
    puts "#{name} analyzing board..."
    sleep(0.5)
    output("Winning move found. Attack mode.") if threat
    self.threat = nil
    system("clear")
    board.display
    sleep(0.5)
  end

  # def move(board)
  #   square = board.available.sample
  #   moves << square
  #   board.update(square, marker)
  #   puts " #{name} analyzing board..."
  #   sleep(1)
  #   system("clear")
  #   board.display
  #   sleep(0.5)
  # end
end

class Player
  include Displayable

  attr_reader :name
  attr_accessor :marker, :score, :moves

  def initialize
    @name = set_name
    @marker = marker
    @score = 0
    @moves = []
  end

  def to_s
    name
  end

  def reset_moves
    self.moves = []
  end

  def reset_score
    self.score = 0
  end
end

class Human < Player
  def move(board, square="")
    loop do
      puts "Choose a square: #{display_squares(board)}"
      square = gets.chomp.to_i
      break if board.available.include?(square)
      invalid_move(board)
    end
    moves << square
    board.update(square, marker)
    system("clear")
    board.display
  end

  private

  def set_name
    name = nil
    loop do
      puts "Please type your name:"
      name = gets.chomp.strip
      break unless name.empty?
      output("Name cannot be empty.")
    end
    puts
    output("Thank you, #{name}. ")
    name
  end

  def choose_square(square)
    loop do
      puts "Choose a square: #{display_squares(board)}"
      square = gets.chomp.to_i
      break if board.available.include?(square)
      invalid_move(board)
    end
  end
end

class Computer < Player
  attr_accessor :threat, :safety

  include AiEngine

  def initialize
    super
    @ai_defense = nil
    @ai_attack = nil
    @opponent_marker = opponent_marker
    @threat = nil
    @safety = [nil, nil, nil]
  end

  def opponent_marker
    self.opponent_marker = marker == "X" ? "O" : "X"
  end

  def title
    ["touring machine",
     "sillicon thrower",
     "terminator",
     "object oriented"].sample
  end

  private

  attr_writer :opponent_marker

  def set_name
    ["Hal-9000", "Skynet", "Wall-E"].sample
  end
end

class Board
  INITIAL_STATE = " "

  attr_accessor :squares

  def initialize
    @squares = initialize_squares
  end

  def display
    board_top
    board_middle
    board_bottom
  end

  def update(square, marker)
    squares[square].value = marker
  end

  def available
    squares.select { |_, square| square.value == INITIAL_STATE }.keys
  end

  def full?
    available.empty?
  end

  def reset
    self.squares = initialize_squares
  end

  private

  def initialize_squares
    new_board = {}
    (1..9).each { |key| new_board[key] = Square.new(INITIAL_STATE) }
    new_board
  end

  def board_top
    puts "+:::::::++:::::::++:::::::+"
    puts "|       ||       ||       |"
    puts "|   #{squares[1]}   ||   #{squares[2]}   ||   #{squares[3]}   |"
    puts "|       ||       ||       |"
  end

  def board_middle
    puts "+:::::::++:::::::++:::::::+"
    puts "|       ||       ||       |"
    puts "|   #{squares[4]}   ||   #{squares[5]}   ||   #{squares[6]}   |"
    puts "|       ||       ||       |"
  end

  def board_bottom
    puts "+:::::::++:::::::++:::::::+"
    puts "|       ||       ||       |"
    puts "|   #{squares[7]}   ||   #{squares[8]}   ||   #{squares[9]}   |"
    puts "|       ||       ||       |"
    puts "+:::::::++:::::::++:::::::+"
  end
end

class Square
  attr_accessor :value

  def initialize(value=Board::INITIAL_STATE)
    @value = value
  end

  def to_s
    value
  end
end

class TTTGame
  include Displayable

  attr_reader :board, :computer, :human

  PLAYERS = [@human, @computer]

  MARKERS = ["X", "O"]
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals

  def initialize
    system("clear")
    display_welcome
    initialize_players
    @max_score = max_score
  end

  def play
    loop do
      number_of_rounds
      who_plays_first
      display_challenge
      game_loop
      break unless play_again?
    end
    display_goodbye
  end

  private

  attr_accessor :current_player, :max_score, :first_move

  def display_goodbye
    output("Thanks for playing. Goodbye!")
  end

  def initialize_board
    @board = Board.new
    board.display
  end

  def initialize_players
    @human = Human.new
    @computer = Computer.new
  end

  def who_plays_first
    case first_to_move_input
    when "computer", "c" then self.current_player = computer
    when "human", "h" then self.current_player = human
    else
      output("Randomizing player...")
      self.current_player = [human, computer].sample
    end
    self.first_move = current_player
    assign_markers([human, computer])
    display_plays_first
  end

  def first_to_move_input
    answer = nil
    valid_answer = ["computer", "c", "human", "h", "random", "r"]
    loop do
      puts "Who should play first: Computer (C), Human (H), or Random (R)?"
      answer = gets.downcase.chomp.strip
      break if valid_answer.include?(answer)
      puts "Invalid choice. Please try again."
      sleep(1)
    end
    answer
  end

  def assign_markers(players)
    players = players.dup
    first_player = current_player
    players.delete(first_player)
    second_player = players.last
    first_player.marker = MARKERS.first
    second_player.marker = MARKERS.last
  end

  def game_loop
    loop do
      initialize_board
      single_round
      display_score
      reset_round
      alternate_first_move
      break if end_game?
    end
  end

  def single_round
    loop do
      current_player.move(board)
      system("clear")
      board.display
      break if win? || board.full?
      alternate_turns
    end
    result
  end

  def alternate_turns
    self.current_player = case current_player
                          when human then computer
                          else human
                          end
  end

  def alternate_first_move
    players = [human, computer]
    self.first_move = case first_move
                      when human then computer
                      else human
                      end
    self.current_player = first_move
    assign_markers(players)
    computer.opponent_marker
  end

  def win?
    result = WINNING_LINES.select do |line|
      line.difference(current_player.moves).empty?
    end
    !result.empty?
  end

  def result
    if win?
      display_winner
      current_player.score += 1
    elsif board.full?
      output("It's a tie!")
    end
  end

  def number_of_rounds
    answer = nil
    loop do
      puts "How many rounds do you want the game to last?"
      answer = gets.chomp
      break if answer == answer.to_i.to_s && answer.to_i.positive?
      puts "Invalid answer. Type a number."
      sleep(1)
    end
    self.max_score = answer.to_i
    output("Thank you.")
  end

  def end_game?
    if human.score == max_score || computer.score == max_score
      display_grand_winner
      reset_game_environment
    else
      false
    end
  end

  def play_again?
    answer = nil
    yes = ["yes", "y"]
    no = ["no", "n"]
    loop do
      puts "Would you like to play again? (yes/no)"
      answer = gets.downcase.chomp
      break if (yes + no).include?(answer)
      invalid_answer_play_again
    end
    reset_game_environment if yes.include?(answer)
  end

  def reset_round
    system("clear")
    board.reset
    human.reset_moves
    computer.reset_moves
  end

  def reset_game_environment
    reset_round
    human.reset_score
    computer.reset_score
  end
end

game = TTTGame.new
game.play
