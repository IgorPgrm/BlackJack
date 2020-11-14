class Deck
  attr_reader :count, :deck

  SUITS = ['♥', '♢', '♧', '♤'].freeze
  CARDS = [*(2..10), 'J', 'Q', 'K', 'A'].freeze

  def initialize(count = 1)
    @count = count
    @deck = []
  end
end
