module Displayable
  def output(message)
    animation(message)
    puts
    sleep(1)
  end

  def display_welcome
    system("clear")
    output("Hello, and welcome to Twenty-One!")
    puts
  end

  def display_intro
    puts
    output("Whoever comes closest to 21 without busting wins.")
    puts
  end

  def display_challenge
    puts
    output("Your dealer is #{dealer.name}, the #{dealer.title}. "\
    "The first to win #{max_score} round(s) is the grand winner.")
  end

  def display_new_round
    output("Starting new round...")
    system("clear")
  end

  def display_turn(player)
    puts
    output("It's #{player.name}'s turn.")
  end

  def closing_round
    puts
    output("Wrapping up...")
    system("clear")
  end

  def display_winner(winner, loser)
    output("#{winner.name} is the winner with #{winner.total} points "\
    "against #{loser.total}.")
  end

  def display_winner_bust(winner, loser)
    puts
    output("#{loser.name} has busted with #{loser.total} points. "\
    "#{winner.name} is the winner.")
  end

  def display_grand_winner
    player.score > dealer.score ? player_win_message : dealer_win_message
  end

  def player_win_message
    output("#{player.name} is the grand winner with a score "\
       "of #{player.score} against #{dealer.score}.")
    output("Congratulations. There's still hope for humankind.")
    puts
  end

  def dealer_win_message
    output("#{dealer.name} is the grand winner with a score "\
      "of #{dealer.score} against #{player.score}.")
    output("This victory can only be attributable to human error. "\
      "Thanks for your cooperation.")
    puts
  end

  def display_score
    puts "::::: Twenty-One :::::      Score: #{player.name}: "\
     "#{player.score} | #{dealer.name}: #{dealer.score}"
    puts "=========================================================="
    puts
    sleep(0.5)
  end

  def display_busted(player)
    puts
    puts "#{player.name} has busted!"
    sleep(1)
  end

  def display_goodbye
    output("Thanks for playing. Goodbye!")
  end

  def animation(message)
    chars = message.to_s.chars
    chars.each_with_index do |chr, idx|
      if chars[idx - 1] == "." || chars[idx - 1] == ":"
        sleep(0.5)
        print chr
      else
        print chr
        sleep(0.045)
      end
    end
  end

  def invalid_answer
    puts "Invalid answer. Try again."
    sleep(1)
  end

  def invalid_answer_play_again
    puts "Answer invalid. Please type 'yes' or 'no'."
    sleep(1)
  end
end

class Player
  include Displayable

  attr_reader :name
  attr_accessor :score, :hand, :hide_hand

  def initialize
    @name = set_name
    @hand = []
    @total = total
    @score = 0
  end

  def show_hand
    output("#{name}'s hand:")
    puts hand
    sleep(1)
    output("Total: #{total}")
    puts
    sleep(0.5)
  end

  def hit(deck)
    hand << deck.cards.shift
    @total = total
    puts "#{name} chooses to hit!"
    sleep(1)
    puts "The following card is added to #{name}'s hand:"
    sleep(1)
    output(hand.last)
    output("Updating hand...")
    sleep(0.5)
    system("clear")
  end

  def bust?
    total > 21
  end

  def total
    total = hand.map(&:value).sum
    total > 21 && include_ace? ? (return adjust_for_ace) : total
    @total = total
  end

  def reset
    self.hand = []
    total
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

  def count_aces
    hand.select(&:ace?).count
  end

  def include_ace?
    count_aces != 0
  end

  def adjust_for_ace
    @total = hand.map(&:value).sum
    count_aces.times do
      @total -= 10
      break if @total <= 21
    end
    @total
  end
end

class Dealer < Player
  attr_accessor :visible_cards

  def initialize
    super
    @hide_hand = true
    @visible_cards = 1
  end

  def hit?
    total < 17
  end

  def show_hand
    hide_hand ? show_visible_hand : super
  end

  def show_visible_hand
    self.visible_cards = hand.size - 1
    output("#{name}'s visible hand:")
    hand.first(visible_cards).each { |card| puts card }
    mystery_card
    sleep(1)
    output("Visible total: #{visible_total(visible_cards)}")
    sleep(0.5)
  end

  def reset
    super
    self.hide_hand = true
  end

  def title
    ["card byter",
     "bit shuffler",
     "quantum fingers"].sample
  end

  private

  def set_name
    ["Hal-9000", "Skynet", "Wall-E"].sample
  end

  def mystery_card
    puts "\e[31m\u2666\e[0m"\
    "\u2660" + "\e[31m\u2665\e[0m" + "\u2663"\
    " Mystery Card " + "\e[31m\u2666\e[0m" + "\u2660"\
    "\e[31m\u2665\e[0m" + "\u2663"
  end

  def visible_total(visible_cards)
    visible_total = hand.first(visible_cards).map(&:value).sum
    @visible_total = visible_total
  end
end

class CardDeck
  attr_reader :cards

  def initialize
    @cards = initialize_card_deck
  end

  def deal(player, dealer)
    shuffle
    (player.hand << cards.shift(2)).flatten!
    (dealer.hand << cards.shift(2)).flatten!
  end

  private

  def shuffle
    cards.shuffle!
  end

  def initialize_card_deck
    Card::SUITS.each_with_object([]) do |suit, cards|
      Card::RANKS.each do |rank|
        cards << Card.new(suit, rank)
      end
    end
  end
end

class Card
  SUITS = [:diamonds, :spades, :hearts, :clubs]
  RANKS = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
    @value = value
  end

  def rank
    case @rank
    when 'J' then 'Jack'
    when 'Q' then 'Queen'
    when 'K' then 'King'
    when 'A' then 'Ace'
    else
      @rank
    end
  end

  def suit
    case @suit
    when :diamonds then "\e[31m\u2666\e[0m"
    when :spades then "\u2660"
    when :hearts then "\e[31m\u2665\e[0m"
    when :clubs then "\u2663"
    end
  end

  def value
    case @rank
    when "J", "Q", "K" then 10
    when "A" then calculate_ace
    else
      rank.to_i
    end
  end

  def to_s
    "#{suit} #{rank} of #{@suit.capitalize} #{suit}"
  end

  def ace?
    rank == "Ace"
  end

  def calculate_ace
    11
  end
end

class TwentyOneGame
  include Displayable
  HIT = ["hit", "h"]
  STAY = ["stay", "s"]

  attr_reader :player, :dealer, :deck

  def initialize
    @deck = CardDeck.new
    @stay_number = 0
    @max_score = max_score
  end

  def play
    display_welcome
    initialize_players
    display_intro
    loop do
      number_of_rounds
      display_challenge
      main_game_loop
      break unless play_again?
    end
    display_goodbye
  end

  private

  attr_accessor :stay_number, :max_score

  def initialize_players
    @player = Player.new
    @dealer = Dealer.new
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

  def main_game_loop
    loop do
      deck.deal(player, dealer)
      display_new_round
      show_cards
      single_round_loop
      break if grand_winner?
    end
  end

  def single_round_loop
    loop do
      self.stay_number = 0
      player_turn
      end_game && break if player.bust? || stay_number >= 2
      dealer_turn
      end_game && break if dealer.bust? || stay_number >= 2
      sleep(2)
    end
  end

  def player_turn
    display_turn(player)
    loop do
      answer = hit_or_stay
      stay(player) && break if STAY.include?(answer)
      hit(player) if HIT.include?(answer)
      display_busted(player) && break if player.bust?
    end
  end

  def stay(player)
    self.stay_number += 1
    puts "#{player.name} has chosen to stay."
    sleep(0.5)
    reveal_hand(player)
  end

  def show_cards
    display_score
    player.show_hand
    dealer.show_hand
  end

  def reveal_hand(player)
    if player.hide_hand == true
      player.hide_hand = false
      output("Revealing hand...")
      system("clear")
      show_cards
    else
      true
    end
  end

  def dealer_turn
    display_turn(dealer)
    sleep(0.5)
    dealer_hit_or_stay
  end

  def dealer_hit_or_stay
    loop do
      hit(dealer) if dealer.hit?
      display_busted(dealer) && break if dealer.bust?
      stay(dealer) && break if !dealer.hit?
      dealer.hide_hand = false
    end
  end

  def end_game
    if player.bust?
      dealer.score += 1
      display_winner_bust(dealer, player)
    elsif dealer.bust?
      player.score += 1
      display_winner_bust(player, dealer)
    else
      compare_totals
    end
    reset
  end

  def grand_winner?
    if player.score == max_score || dealer.score == max_score
      system("clear")
      display_score
      display_grand_winner
      grand_reset
    else
      false
    end
  end

  def hit_or_stay
    answer = nil
    loop do
      puts
      puts "Do you want to (h)it or (s)tay?"
      answer = gets.chomp.downcase.strip
      break if (HIT + STAY).include?(answer)
      invalid_answer
    end
    answer
  end

  def dealer_hit?
    dealer.total < 17
  end

  def hit(player)
    player.hit(deck)
    player.hide_hand = false
    show_cards
  end

  def compare_totals
    if player.total > dealer.total
      winner(player, dealer)
    elsif dealer.total > player.total
      winner(dealer, player)
    else
      puts "It's a tie!"
      sleep(1)
    end
  end

  def winner(winner, loser)
    display_winner(winner, loser)
    winner.score += 1
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
    grand_reset if yes.include?(answer)
  end

  def reset
    @deck = CardDeck.new
    @stay_number = 0
    player.reset
    dealer.reset
  end

  def grand_reset
    sleep(1)
    system("clear")
    reset
    player.score = 0
    dealer.score = 0
  end
end

TwentyOneGame.new.play
