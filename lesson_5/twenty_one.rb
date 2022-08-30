require "pry"

# Twenty-One is a card game consisting of a dealer and a player, where participants try to get as close to 21 as possible, without going over it. Whoever comes closest to 21 without going over it is the winner.

# Module: Displayable
# Responsibility: Formatting and Displaying messages
# Behaviors:
# Collaborators:

# Class: TwentyOneGame 
# Responsibility: Game Orchestration
# States: deck, player, dealer
# Behaviors: win? show_cards, player_turn, dealer_turn
# Collaborators: Player, Dealer, CardDeck

# Class: Player
# Responsibility:
# States: Name, Score, Hand
# Behaviors: Hit, Stay, Bust?
# Collaborators:  Card

# Class: Dealer < Player
# Responsibility: 
# States: (from Player)
# Behaviors: Hit (Stay, Bust? from Player)
# Collaborators: 

# Class: CardDeck
# Responsibility: Keep track of all cards
# States:
# Behaviors:
# Collaborators: Card

# Class: Card
# Responsibility: Define the value of individual cards
# States: 
# Behaviors:
# Collaborators:


class Player
  attr_reader :hand, :total

  def initialize
    @name = set_name
    @hand = []
    @total = total
  end 

  def hit(deck)
    hand << deck.cards.shift
    @total = total
  end

  def bust?
    # if total > 21, loses game
  end

  def total
    total = hand.map(&:value).sum
    @total = total
  end

  private

  def set_name
  end
end

class Dealer < Player

  def set_name
  end

  def hit
    #special hit rules for Dealer
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

  def calculate_ace
    11
  end

  def to_s
    "#{suit} #{rank} of #{@suit.capitalize} #{suit} with a value of #{value}"
  end


end

class TwentyOneGame
  attr_accessor :deck
  attr_reader :player, :dealer

  def initialize
    @deck = CardDeck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def play
    welcome
    main_game_loop
    goodbye
  end

  private

  def welcome
    puts "Welcome to Twenty-One!"
  end

  def goodbye
    puts "Thank you for playing Twenty-One. Goodbye!"
  end

  def main_game_loop
    loop do
      deck.deal(player, dealer)
      show_cards
      single_round_loop
      # compare_totals
      # display_winner
      # play_again?
    end
  end

  def show_cards
    puts "Player's hand:"
    puts player.hand
    puts "Player's total: #{player.total}"
    puts
    puts "Dealer's hand:"
    puts dealer.hand
    puts "Dealer's total: #{dealer.total}"
  end

  def single_round_loop
    loop do
      player_turn
      dealer_turn
      break
    end
  end

  def player_turn
    hit, stay = ["hit", "h"], ["stay", "s"] 
    puts "Player's turn..."
    sleep(2)
    loop do
      puts "Do you want to (h)it or (s)tay?"
      answer = hit_or_stay?(hit, stay)
      hit.include?(answer) ? player_hit : break
      break if player.bust?
    end
  end

  def dealer_turn
    puts "Dealer's turn now..."
    sleep(2)
    loop do
      break
      dealer_hit? # up to total >= 17
      break if bust? || stay? 
    end
    bust? # player wins -> display_winner
    stay? # player_turn
  end

  def hit_or_stay?(hit, stay)
    answer = nil
    loop do 
      answer = gets.chomp.downcase.strip
      break if  (hit + stay).include?(answer)
      puts "Invalid answer. Try again."
    end
    answer
  end


  def player_hit
    player.hit(deck)
    p "Player HIT"
    sleep(2)
    p player.hand
    p player.total
  end

  def dealer_hit
  end

  def bust?
  end

  def stay?
    p "Stay!!!!!!"
  end

  def compare_totals
  end

  def display_winner
  end

  def play_again?
  end
end

 TwentyOneGame.new.play












