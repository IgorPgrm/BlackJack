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
    @current_hand = hands.last if @current_hand.done && @current_hand == hands.first
    @current_hand.add_card card unless @current_hand.done
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
    two_cards = @hands.first.cards.count == 2
    cards_cost = @hands.first.cards.first.cost == @hands.first.cards.last.cost
    can_double?(@current_hand.bet) && two_cards && cards_cost
  end

  def split
    new_hand = Hand.new
    new_hand.add_card(@hands.first.cards.pop)
    new_hand.bet = @current_hand.bet
    @balance -= @current_hand.bet
    @hands << new_hand
    @splited = true
    @current_hand.check_weight
  end

  def can_double?(bet)
    balance >= bet * 2
  end

  def lose?
    @hands.each do |hand|
      next if hand.lose?

      return false
    end
    true
  end
end
