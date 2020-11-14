class Player
  attr_reader :name, :balance, :cards, :card_weight

  def initialize(name, balance)
    @name = name
    @balance = balance
    @cards = []
    @card_weight = 0
  end

  def add_card(card)
    @cards << card
    @card_weight += card.cost
  end

  def show_cards
    @cards.each do |card|
      puts "#{card.suit} #{card.name}"
    end
  end
end
