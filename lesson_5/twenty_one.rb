require "pry"
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
    output("Whoever comes closest to 21 without going over (busting) wins.")
    puts "Let's get started."
    sleep(1.5)
    system("clear")
  end

  def display_challenge
    output("Your dealer is #{dealer.name}, the #{dealer.title}.")
  end

  def show_cards
    display_score
    player.show_hand
    dealer.show_hand
  end

  def display_turn(player)
    output("It's #{player.name}'s turn.")
  end

  def invalid_answer
    puts "Invalid answer. Try again."
    sleep(1)
  end

  def invalid_answer_play_again
    puts "Answer invalid. Please type 'yes' or 'no'."
    sleep(1)
  end

  def display_winner(winner, loser)
    output("#{winner.name} is the winner with #{winner.total} points "\
    "against #{loser.total}.")
  end

  def display_winner_bust(winner, loser)
    output("#{loser.name} has busted with #{loser.total} points. "\
    "#{winner.name} is the winner with #{winner.total} points.")
  end

  def display_score
    puts"::::: Twenty-One :::::      Score: #{player.name}: "\
     "#{player.score} | #{dealer.name}: #{dealer.score}"
     puts "=========================================================="
     puts
    sleep(0.5)
  end

  def display_busted(player)
    puts "#{player.name} has busted!"
    sleep(1)
  end



  def display_goodbye
    output("Thanks for playing. Goodbye!")
  end

  private

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
end

class Player
  include Displayable 

  attr_reader :name, :total
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
    output("#{name}'s total: #{total}")
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
   output("#{hand.last}")
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
    puts
    name
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
    hand.first(visible_cards).each {|card| puts card}
    mystery_card
    sleep(1)
    output("#{name}'s visible total: #{visible_total(visible_cards)}")
    puts
    sleep(0.5)
  end

  def visible_total(visible_cards)
    visible_total = hand.first(visible_cards).map(&:value).sum
    @visible_total = visible_total
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
    puts "\e[31m\u2666\e[0m"  + "\u2660" + + "\e[31m\u2665\e[0m" + "\u2663" + 
    " Mystery Card " "\e[31m\u2666\e[0m"  + "\u2660" + 
    "\e[31m\u2665\e[0m" + "\u2663" 
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
  HIT, STAY = ["hit", "h"], ["stay", "s"] 

  attr_accessor :deck, :stay_number
  attr_reader :player, :dealer

  def initialize
    @deck = CardDeck.new
    @stay_number = 0
  end

  def play
    display_welcome
    initialize_players
    display_challenge
    display_intro
    loop do 
      main_game_loop
      break unless play_again?
    end
    display_goodbye
  end

  private

  def initialize_players
    @player = Player.new
    @dealer = Dealer.new
  end

  def main_game_loop
    loop do
      deck.deal(player, dealer)
      show_cards
      single_round_loop
      break
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
      system("clear")
    end
  end

  def player_turn
    display_turn(player)
    loop do
      answer = hit_or_stay?(HIT, STAY)
      stay(player) && break if STAY.include?(answer)
      hit(player) if HIT.include?(answer)
      display_busted(player) && break if player.bust?
    end
  end

  def stay(player)
    self.stay_number += 1
    puts "#{player.name} has chosen to stay."
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
    sleep(1)
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
    sleep(0.1)
  end

  def hit_or_stay?(hit, stay)
    answer = nil
    loop do 
      puts "Do you want to (h)it or (s)tay?"
      answer = gets.chomp.downcase.strip
      break if  (HIT + STAY).include?(answer)
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
    player.score += 1
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
    reset if yes.include?(answer)
  end

  def reset
    output("Okay, let's play again.")
    system("clear")
    @deck = CardDeck.new
    @stay_number = 0
    player.reset
    dealer.reset
  end
end

 TwentyOneGame.new.play
