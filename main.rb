require_relative 'game'
class Main
  def initialize
    puts 'Введите своё имя:'
    # input = gets.chomp.to_s
    @user_name = 'Igor'
    @main_game = Game.new(@user_name, 100)
    @main_game.show_info
    @main_game.menu
  end
end

Main.new
