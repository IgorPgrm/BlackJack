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
    2 - Изменить ставку
    0 -Выход
NGM
    input = gets.chomp.to_i
    case input
    when 0
      exit
    when 2
      @main_game.set_bet
      start_new_game
    when 1
      start_new_game
    end
  end

  def start_new_game
    @main_game.bet = @main_game.current_bet
    @main_game.status = ''
    @main_game.start_game
    @main_game.clear
    @main_game.show_cards
    menu
  end

  def show_info
    @main_game.show_cards
    @main_game.over? ? new_game_menu : menu
  end

  def take_card_scr
    @main_game.hit
    @main_game.clear
  end

  def open_cards
    winner = @main_game.winning
    @main_game.give_bank(winner)
    @main_game.show_cards(true)
    new_game_menu
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
      take_card_scr
      show_info
    when 2
      open_cards
    when 3
      @main_game.player.balance -= @main_game.bet
      @main_game.bet *= 2
      take_card_scr
      open_cards
    end
  end
end

Main.new
