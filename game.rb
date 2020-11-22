require_relative 'deck'
require_relative 'player'
require_relative 'dealer'

class Game
  attr_accessor :player, :dealer, :bank, :deck, :bet, :status
  attr_reader :current_bet

  def initialize(player_name, money = 100, deck_count = 1)
    @na = 'N/a'.to_sym
    @deck = Deck.new(deck_count)
    @player = Player.new(player_name, money)
    @dealer = Dealer.new
    @players = [@player, @dealer]
    @bet = 0
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

      @bet = input
      @current_bet = input
    rescue StandardError => e
      puts e.message
      retry
    end
  end

  def clear
    system('clear')
  end

  def status_bar
    print 'Баланс:['
    print @player.balance.zero? ? "\u001B[31m 0 \u001B[0m" : "\u001B[32m#{@player.balance}\u001B[0m"
    print '] ставка:['
    print @bet.zero? ? "\u001B[31m#{@na}\u001B[0m" : "\u001B[32m#{@bet}\u001B[0m"
    print '] Очки:['
    if @player.hands.first.points.instance_of? Array
      print "\u001B[32m#{@player.points.max}\u001B[0m"
    elsif @player.hands.first.points.instance_of? Integer
      print @player.hands.first.points.zero? ? "\u001B[31m 0 \u001B[0m" : "\u001B[32m#{@player.hands.first.points}\u001B[0m"
    end
    print '] Статус:['
    print @status.nil? ? "\u001B[31m#{@status}\u001B[0m" : "\u001B[32m#{@status}\u001B[0m"
    print "]\n"
  end

  def can_play?
    raise ArgumentError, 'Недостаточно средств на балансе!' if @player.balance <= 0

    set_bet if @player.balance < @bet
    true
  rescue StandardError => e
    puts e.message
    false
  end

  def start_game
    exit unless can_play?
    @player.balance -= @bet
    @player.refresh
    @dealer.refresh
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

  def queue
    loop do
      break if over?
    end
  end

  def over?
    @players.each do |player|
      next unless player.hands.first.lose?

      @status = "Игрок: #{player.name} - проиграл"
      show_cards
      return true
    end
    false
  end

  def hit
    @player.add_card @deck.take_card
  end

  def winning
    player_lose = @player.hands.first.lose?
    dealer_lose = @dealer.hands.first.lose?
    if !player_lose && !dealer_lose
      return @player if @player.hands.first.points > @dealer.hands.first.points
      return @dealer if @player.hands.first.points < @dealer.hands.first.points
      return nil if @player.hands.first.points == @dealer.hands.first.points
    elsif player_lose
      @dealer
    elsif dealer_lose
      @player
    end
  end

  def give_bank(winner)
    if winner.nil?
      @player.balance += @bet
      @status = 'Ничья!'
    else
      money = @bet * 2
      winner.balance += money
      @status = winner.instance_of?(Player) ? "Выиграл +#{money}" : "\u001B[31mПроиграл -#{@bet}\u001B[0m"
    end
  end

  def show_cards(game_over = false)
    clear
    status_bar
    puts "Карты диллера:\n"
    game_over ? @dealer.hands.first.cards_show : @dealer.dealer_cards_show
    puts "Карты игрока #{@player.name}:\n"
    @player.show_cards
  end
end
