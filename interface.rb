require_relative 'game'

class Interface
  attr_accessor :status

  def initialize
    @status = ''
    set_name
    @main_game = Game.new(@user_name, 100)
    @player = @main_game.player
    set_bet
    play_game
  end

  def play_game
    clear
    @main_game.start_game
    puts 'Раздача карт...'
    @main_game.players.each do |player|
      player.show_cards if player.instance_of?(Player)
      player.dealer_cards_show if player.instance_of?(Dealer)
      sleep(0.4)
    end
    clear
    show_info
  end

  def set_name
    puts 'Введите своё имя:'
    @user_name = gets.chomp.to_s
  end

  def set_bet
    clear
    status_bar
    if @player.balance.zero?
      puts 'На балансе нет денег, невозможно изменить ставку'
      exit
    end
    begin
      puts "Введите сумму ставки от 1 до #{@player.balance}"
      input = gets.chomp.to_f
      raise ArgumentError, 'Неправильная сумма ставки!' unless input.positive? && input <= @player.balance.to_f

      @main_game.set_bet(input)
    rescue StandardError => e
      puts e.message
      retry
    end
  end

  def status_bar
    pch = @player.current_hand
    scr_bet = ''
    scr_points = ''
    print 'Баланс:['
    print @player.balance.zero? ? "\u001B[31m 0 \u001B[0m" : "\u001B[32m#{@player.balance}\u001B[0m"
    print '] ставка:['
    if @player.splited
      @player.hands.each do |hand|
        scr_bet += hand.bet.to_s
        scr_points += hand.points.to_s
        next if hand == @player.hands.last

        scr_bet += ' | '
        scr_points += ' | '
      end
    else
      scr_bet = @player.current_hand.bet.to_s
      scr_points = @player.current_hand.points
    end
    print pch.bet.zero? ? "\u001B[31m0\u001B[0m" : "\u001B[32m#{scr_bet}\u001B[0m"
    print '] Очки:['
    print scr_points
    print '] Статус:['
    print @status.nil? ? "\u001B[31m#{@status}\u001B[0m" : "\u001B[32m#{@status}\u001B[0m"
    print "]\n"
  end

  def clear
    system('clear')
  end

  def show_info
    show_cards
    @main_game.over? ? new_game_menu : menu
  end

  def menu
    splited = @player.splited
    puts <<~MENU
      1 - Взять карту
      2 - Вскрыть карты
    MENU
    puts '3 - Удвоить ставку (+1 карта)' unless splited && @player.can_double?(@current_hand.bet)
    puts '4 - Сплит' if @player.can_split?
    puts '5 - Достаточно' if splited
    input = gets.chomp.to_i
    clear
    @status = @main_game.status
    case input
    when 1
      @main_game.take_card
      @status = @main_game.status
      show_info
    when 2
      open_card_scr
    when 3
      double_scr unless splited && @player.can_double?
    when 4
      @player.split if @player.can_split?
      show_info
    when 5
      hand_done if splited
      show_info
    end
  end

  def open_card_scr
    @main_game.go_dealer unless @player.lose?
    @main_game.open_cards
    show_cards(game_over: true)
    new_game_menu
  end

  def double_scr
    @main_game.player.double
    @main_game.take_card
    open_card_scr
  end

  def show_cards(game_over: false)
    clear
    status_bar
    puts "Карты диллера:\n"
    game_over ? @main_game.dealer.hands.first.cards_show : @main_game.dealer.dealer_cards_show
    puts "Карты игрока #{@player.name}:\n"
    @player.show_cards
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
      set_bet
      start_new_game
    when 1
      start_new_game
    end
  end

  def start_new_game
    @player.current_hand.bet = @current_bet
    @status = ''
    play_game
    clear
    show_cards
    menu
  end

  def hand_done
    @main_game.hand_full
    open_card_scr if @player.current_hand == @player.hands.last
  end
end
