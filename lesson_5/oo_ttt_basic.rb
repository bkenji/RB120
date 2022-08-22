class Player
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
end

class Human < Player
  def move(board)
    square = ""
    loop do
      puts "Choose a square: #{board.available}"
      square = gets.chomp.to_i
      break if board.available.include?(square)
      system("clear")
      board.display
      puts "Invalid choice. Please try again."
      sleep(1.5)
      system("clear")
      board.display
    end
    moves << square
    board.update(square, marker)
    system("clear")
    board.display
    sleep(0.5)
  end

  private

  def set_name
    name = nil
    loop do
      puts "Please type your name:"
      name = gets.chomp.strip
      break unless name.empty?
      puts "Name cannot be empty."
      sleep(1)
    end
    puts "Thank you, #{name}."
    name
  end
end

class Computer < Player
  def move(board)
    square = board.available.sample
    moves << square
    board.update(square, marker)
    puts " #{name} analyzing board..."
    sleep(1)
    system("clear")
    board.display
    sleep(0.5)
  end

  private

  def set_name
    ["Hal-9000", "Wall-E", "Deckard", "Skynet"].sample
  end
end

class Board
  INITIAL_STATE = " "
  attr_reader :grid
  attr_accessor :squares

  def initialize(grid=3)
    @grid = grid
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

  # def setup(grid_size=3)
  #   self.grid = grid_size
  #    grid.times{build_row}
  #   h_bar
  # end

  private

  attr_writer :grid

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

  # def build_row(idx=9)
  #  h_bar
  #  interval(grid, idx)
  # end

  # def h_bar
  #  p ("+:::::::+" * grid)
  # end

  # def interval(grid, idx)
  #    space = "|       |"
  #    content =  "|   #{"n"}   |"
  #    space_row = space * grid
  #   p space_row
  #   p content * grid
  #   p space_row
  # end
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

class TTTGame # Orchestrating Engine
  MARKERS = ["X", "O"]
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals
  attr_reader :board, :computer, :human
  attr_accessor :current_player

  def initialize
    system("clear")
    display_welcome
    initialize_players
  end

  def play
    loop do
      who_plays_first
      initialize_board
      gameplay_loop
      display_score
      break unless play_again?
    end
    display_goodbye
  end

  private

  def display_welcome
    puts "Welcome to TIC-TAC-TOE."
    sleep(1)
    puts
  end

  def display_goodbye
    puts "Thanks for playing. Goodbye"
  end

  def initialize_board
    # add option to choose size of board
    @board = Board.new
    board.display # accepts optional integer argument for varying sizes
  end

  def initialize_players
    @human = Human.new
    @computer = Computer.new
  end

  def who_plays_first
    players = [computer, human]
    case first_to_move_input
    when "computer", "c" then self.current_player = computer
    when "human", "h" then self.current_player = human
    else self.current_player = players.sample
    end
    assign_markers(players)
    puts "#{current_player.name} will have the first move."
    sleep(1)
    system("clear")
  end

  def first_to_move_input
    answer = nil
    valid_answer = ["computer", "c", "human", "h", "random", "r"]
    loop do
      puts "Who should play first: Computer (C), Human (H), or Random (R)?"
      answer = gets.downcase.chomp.strip
      break if valid_answer.include?(answer)
      puts "Invalid choice. Please try again."
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

  def alternate_turns
    self.current_player = case current_player
                          when human then computer
                          else human
                          end
  end

  def win?
    result = WINNING_LINES.select do |line|
      line.intersection(current_player.moves) == line
    end
    !result.empty?
  end

  def result
    if win?
      puts "#{current_player} is the winner."
      current_player.score += 1
    elsif board.full?
      puts "It's a tie!"
    end
  end

  def gameplay_loop
    loop do
      current_player.move(board)
      system("clear")
      board.display
      break if win? || board.full?
      alternate_turns
    end
    result
  end

  def display_score
    puts "#{human.name} : #{human.score} | #{computer.name}: #{computer.score}"
  end

  def play_again?
    answer = nil
    yes = ["yes", "y"]
    no = ["no", "n"]
    loop do
      puts "Would you like to play again? (yes/no)"
      answer = gets.downcase.chomp
      break if (yes + no).include?(answer)
      puts "Answer invalid. Please type 'yes' or 'no'."
    end
    reset_game_environment if yes.include?(answer)
  end

  def reset_game_environment
    puts "All right. Let's play again!"
    sleep(1)
    system("clear")
    board.reset
    human.reset_moves
    computer.reset_moves
  end
end

game = TTTGame.new
game.play
