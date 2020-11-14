require_relative 'card'
class Deck
  attr_reader :count, :deck, :deck_count

  SUITS = ['♥', '♢', '♧', '♤'].freeze
  CARDS = [*(2..10), 'J', 'Q', 'K', 'A'].freeze

  def initialize(deck_count = 1)
    @deck_count = deck_count
    @deck = []
    @deck_count.times do
      SUITS.each do |suit|
        CARDS.each do |card|
          @deck << Card.new(suit, card)
        end
      end
    end
  end
end
