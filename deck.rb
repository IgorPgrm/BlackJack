require_relative 'card'
class Deck
  attr_reader :count, :deck

  SUITS = ['♥', '♢', '♧', '♤'].freeze
  CARDS = [*(2..10), 'J', 'Q', 'K', 'A'].freeze

  def initialize(count = 1)
    @deck = []
    @count = count
    @count.times do
      SUITS.each do |suit|
        CARDS.each do |card|
          @deck << Card.new(suit, card)
        end
      end
    end
  end
end
