require_relative 'card'
class Deck
  attr_reader :count, :cards, :deck_count

  SUITS = %w[♥ ♦ ♣ ♠].freeze
  CARDS = [*(2..10), 'J', 'Q', 'K', 'A'].freeze

  def initialize(deck_count: 4, shuffle_times: 4)
    @deck_count = deck_count
    new_deck(@deck_count)
    shuffle_cards(count: shuffle_times)
    @cards = []
  end

  def new_deck(deck_count)
    deck_count.times do
      SUITS.each do |suit|
        CARDS.each do |card|
          @cards << Card.new(suit, card)
        end
      end
    end
  end

  def shuffle_cards(count: 4)
    count.times do
      cards.shuffle!
    end
  end

  def take_card
    new_deck(@deck_count) if deck_empty?
    
    cards&.shift
  end

  private

  def deck_empty?
    @cards.empty? || @cards.count < 4
  end
end
