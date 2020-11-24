require_relative 'deck'
require_relative 'player'
require_relative 'dealer'

class Game
  attr_accessor :player, :dealer, :bank, :deck, :status
  attr_reader :current_bet

  def initialize(player_name, money = 100, deck_count = 1)
    @na = 'N/a'.to_sym
    @deck = Deck.new(deck_count)
    @player = Player.new(player_name, money)
    @dealer = Dealer.new
    @players = [@player, @dealer]
    @current_bet = 0
    @status = ''
    set_bet
    start_game
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

      @current_bet = input
      @player.current_hand.bet = input
    rescue StandardError => e
      puts e.message
      retry
    end
  end

  def clear
    system('clear')
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

  def can_play?
    raise ArgumentError, 'Недостаточно средств на балансе!' if @player.balance <= 0

    set_bet if @player.balance < @current_bet
    true
  rescue StandardError => e
    puts e.message
    false
  end

  def start_game
    exit unless can_play?
    @player.refresh
    @player.current_hand.bet = @current_bet
    @dealer.refresh
    @player.balance -= @player.current_hand.bet
    puts 'Раздача карт...'
    sleep(0.4)
    2.times do
      clear
      @players.each do |player|
        player.add_card @deck.cards.shift
        player.show_cards if player.instance_of? Player
        player.dealer_cards_show if player.instance_of? Dealer
        sleep(0.4)
      end
    end
  rescue StandardError => e
    puts e.message
  end

  def over?
    @player.lose?
  end

  def hand_full
    @player.current_hand.done!
    if @player.current_hand == @player.hands.last
      go_dealer
      open_cards
      show_cards(game_over: true)
    else
      @player.current_hand = @player.hands.last
    end
  end

  def go_dealer
    loop do
      break unless @dealer.hands.first.points < 17

      @dealer.add_card @deck.take_card
    end
  end

  def winning(hand)
    player_lose = hand.lose?
    dealer_lose = @dealer.hands.first.lose?
    if !player_lose && !dealer_lose
      return @player if hand.points > @dealer.hands.first.points
      return @dealer if hand.points < @dealer.hands.first.points
      return nil if hand.points == @dealer.hands.first.points
    elsif player_lose
      @dealer
    elsif dealer_lose
      @player
    end
  end

  def give_bank(winner)
    if winner.nil?
      @player.balance += @player.current_hand.bet
      @status += 'Ничья!'
    else
      money = @player.current_hand.bet * 2
      winner.balance += money
      @status += winner.instance_of?(Player) ? "+#{money}" : "-#{@player.current_hand.bet}"
      @player.current_hand.status = @status
    end
  end

  def show_cards(game_over: false)
    clear
    status_bar
    puts "Карты диллера:\n"
    game_over ? @dealer.hands.first.cards_show : @dealer.dealer_cards_show
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
    start_game
    clear
    show_cards
    menu
  end

  def show_info
    show_cards
    over? ? new_game_menu : menu
  end

  def take_card_scr
    @player.add_card @deck.take_card
    clear
  end

  def open_cards
    @player.hands.each do |hand|
      winner = winning(hand)
      give_bank(winner)
    end
  end

  def double
    @player.balance -= @player.current_hand.bet
    @player.current_hand.bet *= 2
    take_card_scr

    if @player.lose?
      @status = 'Проиграл'
    else
      go_dealer
      open_cards
      show_cards(game_over: true)
      new_game_menu
    end
  end

  def menu
    splited = @player.splited
    puts <<~MENU
      1 - Взять карту
      2 - Вскрыть карты
    MENU
    puts '3 - Удвоить ставку (+1 карта)' unless splited
    puts '4 - Сплит' if @player.can_split?
    puts '5 - Достаточно' if splited
    input = gets.chomp.to_i
    case input
    when 1
      take_card_scr
      show_info
    when 2
      go_dealer
      open_cards
      show_cards(game_over: true)
      new_game_menu
    when 3
      double unless splited
    when 4
      @player.split
      show_info
    when 5
      hand_full
      show_info
    end
  end
end
