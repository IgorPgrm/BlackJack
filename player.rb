require_relative 'hand'

class Player
  attr_reader :name, :lose
  attr_accessor :done, :balance, :hands

  def initialize(name, balance)
    @name = name
    @balance = balance
    refresh
  end

  def add_card(card)
    @hands.each do |hand|
      hand.add_card(card) unless hand.done
    end
  end

  def refresh
    @hands = []
    @hands << Hand.new
    @status = ''
    @cards = []
    @lose = false
    @done = false
    @card_weight = '0'
    @points = 0
  end

  def show_cards
    @hands.each(&:cards_show)
  end

  def can_split?
    @hands.first.cards.first.cost == @hands.first.cards.last.cost
  end

  def can_double?(bet)
    balance >= bet * 2
  end

end
