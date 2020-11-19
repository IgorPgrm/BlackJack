require_relative 'game'
class Main
  def initialize
    puts 'Введите своё имя:'
    # input = gets.chomp.to_s
    @user_name = 'Igor'
    @main_game = Game.new(@user_name, 100)
    show_info
    menu
  end

  def new_game_menu
    puts <<NGM
    Игра окончена!
    1 - Начать новую игру?
    2 -Выход
NGM
    input = gets.chomp.to_i
    case input
    when 1
      @main_game.status = ''
      @main_game.start_game
      @main_game.clear
      @main_game.show_cards
      menu
    end
  end

  def show_info
    @main_game.show_cards
    @main_game.over? ? new_game_menu : menu
  end

  def menu
    puts <<~MENU
      1 - Взять карту
      2 - Вскрыть карты
      3 - Удвоить ставку (+1 карта)
      4 - Сплит
    MENU
    input = gets.chomp.to_i
    case input
    when 1
      @main_game.hit
      @main_game.clear
      show_info
    when 2
      @main_game.show_cards(true)
    end
  end
end

Main.new
