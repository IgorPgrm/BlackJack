require_relative 'card'
class Deck
  attr_reader :count, :cards, :deck_count

  SUITS = ['♥', '♢', '♧', '♤'].freeze
  CARDS = [*(2..10), 'J', 'Q', 'K', 'A'].freeze

  def initialize(deck_count = 1)
    @deck_count = deck_count
    @cards = []
    @deck_count.times do
      SUITS.each do |suit|
        CARDS.each do |card|
          @cards << Card.new(suit, card)
        end
      end
    end
  end
end
