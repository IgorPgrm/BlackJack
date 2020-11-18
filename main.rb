require_relative 'game'
class Main
  def initialize
    puts 'Введите своё имя:'
    #input = gets.chomp.to_s
    input = "Igor"
    @main_game = Game.new(input, 100)
    show_info
    menu
    puts "Очки: #{@main_game.player.points}"
  end

  def show_info
    @main_game.status_bar
    @main_game.dealer.dealer_cards_show
    @main_game.player.show_cards
  end

  def menu
    @main_menu = ''
  end

  def hit
    @main_game.player.add_card @main_game.deck
  end
end

Main.new
