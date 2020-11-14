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
    puts '->'
    @deck.cards.shuffle!.shuffle!.shuffle!.shuffle!
    @deck.cards.each do |card|
      puts "#{card.suit} #{card.name}"
    end
    puts 'Выдаём карты...'
    2.times do
      @players.each do |player|
        puts "Player: #{player}"
        player.add_card @deck.cards.shift
      end
    end

    puts 'Выданы карты:'
    @player.show_cards
    puts "Очки: #{@player.card_weight}"
    puts "У Диллера: #{@dealer.card_weight}"
  end
end
