require_relative 'game'
class Main
  def initialize
    puts 'Введите своё имя:'
    input = gets.chomp.to_s
    @main_game = Game.new(input, 100)
  end

  def clear
    system('clear')
  end
end

Main.new
