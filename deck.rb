require_relative 'card'
class Deck
  attr_reader :count, :cards, :deck_count

  SUITS = ['♥', '♦', '♣', '♠'].freeze
  CARDS = [*(2..10), 'J', 'Q', 'K', 'A'].freeze

  def initialize(deck_count = 1)
    @deck_count = deck_count
    new_deck(@deck_count)
  end

  def new_deck(deck_count)
    @cards = []
    deck_count.times do
      SUITS.each do |suit|
        CARDS.each do |card|
          @cards << Card.new(suit, card)
        end
      end
    end
    shuffle_cards
  end

  def shuffle_cards
    @cards.shuffle!.shuffle!.shuffle!.shuffle!
  end

  def take_card
    if @cards.empty?
      new_deck(@deck_count)
    else
      @cards&.shift
    end
  end
end
