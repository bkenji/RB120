# Twenty-One is a card game consisting of a dealer and a player, where participants try to get as close to 21 as possible, without going over it. Whoever comes closest to 21 without going over it is the winner.

# Module: Displayable
# Responsibility: Formatting and Displaying messages
# Behaviors:
# Collaborators:

# Class: TwentyOneGame 
# Responsibility: Game Orchestration
# States: 
# Behaviors: Win?, both_stay?, tie?, play
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
  def initialize
    @name = set_name
    @hand = []
    @score = 0
  end 

  def hit
  end

  def stay
  end

  def bust?
  end

  private

  def set_name
  end
end

class Dealer < Player

  def set_name
  end

  def hit
  end

  def stay
  end

end

class CardDeck
  INITIAL_DECK = [# 52 card objects]
  def initialize
    @cards = INITIAL_DECK
  end
end

class Card
  def initialize
    @rank
    @suit
    @value
  end
end

class TwentyOneGame
  def initialize
    @cards = CardDeck.new
    @player = Player.new
    @dealer = Dealer.new
  end

  def play
    welcome
    deal_cards
    player_turn
    - player_hit? (loop)
    - bust? or stay? (break loop)
    bust? (dealer wins -> display_winner)
    dealer_turn
    - dealer_hit? (up to score >= 17)
    - bust? or stay? (break loop)
    - bust? (player wins -> display_winner)
    - compare_scores
    - display_winner
    goodbye
  end
end

TwentyOneGame.new.play