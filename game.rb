require_relative 'deck'
require_relative 'player'
require_relative 'dealer'

class Game
  attr_accessor :player, :players, :dealer, :bank, :deck
  attr_reader :current_bet, :status

  def initialize(player_name, money = 100, deck_count = 1)
    @na = 'N/a'.to_sym
    @deck = Deck.new(deck_count)
    @player = Player.new(player_name, money)
    @dealer = Dealer.new
    @players = [@player, @dealer]
    @current_bet = 0
    @status = ''
  end

  def set_bet(bet)
    @current_bet = bet
    @player.current_hand.bet = bet
  end

  def can_play?
    return false if @player.balance <= 0

    true
  end

  def start_game
    exit unless can_play?
    @player.refresh
    @player.current_hand.bet = @current_bet
    @dealer.refresh
    @player.balance -= @player.current_hand.bet
    2.times do
      @players.each do |player|
        player.add_card @deck.cards.shift
      end
    end
  end

  def over?
    @player.lose?
  end

  def hand_full
    @player.current_hand.done!
    @player.current_hand = @player.hands.last unless @player.current_hand == @player.hands.last
  end

  def go_dealer
    loop do
      break unless @dealer.current_hand.points <= 17

      @dealer.add_card @deck.take_card
    end
  end

  def winner(hand)
    player_lose = hand.lose?
    dealer_lose = @dealer.current_hand.lose?
    if !player_lose && !dealer_lose
      return @player if hand.points > @dealer.current_hand.points
      return @dealer if hand.points < @dealer.current_hand.points
      return nil if hand.points == @dealer.current_hand.points
    elsif player_lose
      @dealer
    elsif dealer_lose
      @player
    end
  end

  def give_bank(winner)
    if winner.nil?
      @player.balance += @player.current_hand.bet
    else
      money = @player.current_hand.bet * 2
      winner.balance += money
    end
  end

  def take_card
    @player.add_card @deck.take_card
  end

  def open_cards
    @player.hands.each do |hand|
      winner = winner(hand)
      give_bank(winner)
    end
  end
end
