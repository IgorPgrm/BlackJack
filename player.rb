require_relative 'hand'

class Player
  attr_reader :name, :lose, :splited
  attr_accessor :done, :balance, :hands, :current_hand

  def initialize(name, balance)
    @name = name
    @balance = balance
    refresh
  end

  def add_card(card)
    @current_hand.add_card card
  end

  def refresh
    @hands = []
    @current_hand = Hand.new
    @hands << @current_hand
    @status = ''
    @cards = []
    @lose = false
    @done = false
    @card_weight = '0'
    @points = 0
    @splited = false
  end

  def show_cards
    @hands.each(&:cards_show)
  end

  def can_split?
    @hands.first.cards.count == 2 && @hands.first.cards.first.cost == @hands.first.cards.last.cost
  end

  def split
    new_hand = Hand.new
    new_hand.add_card(@hands.first.cards.pop)
    @hands << new_hand
    @splited = true
  end

  def can_double?(bet)
    balance >= bet * 2
  end
end
