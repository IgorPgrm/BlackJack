require_relative 'deck'
require_relative 'player'
require_relative 'dealer'

class Game
  attr_accessor :player, :money, :bank, :deck

  def initialize(player_name, money = 100, deck_count = 1)
    @money = money
    @deck = Deck.new(deck_count)
    @player = Player.new(player_name, @money)
    @dealer = Dealer.new
    @players = [@player, @dealer]
    start_game
  end

  def start_game
    puts 'Выдаём карты...'
    2.times do
      @players.each do |player|
        puts "Player: #{player.name} +1"
        player.add_card @deck.cards.shift
      end
    end
  end


end
