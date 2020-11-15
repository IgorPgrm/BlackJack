require_relative 'game'
class Main
  def initialize
    puts 'Введите своё имя:'
    input = gets.chomp.to_s
    @main_game = Game.new(input, 100)
    show_info
    menu
  end

  def clear
    system('clear')
  end

  def show_info
    @main_game.player.show_cards
  end

  def menu
    @main_menu = ""
  end

  def hit
    @main_game.player.add_card @main_game.deck
  end
end

Main.new
