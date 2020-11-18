require_relative 'deck'
require_relative 'player'
require_relative 'dealer'

class Game
  attr_accessor :player, :dealer, :money, :bank, :deck, :bet

  def initialize(player_name, money = 100, deck_count = 1)
    @na = 'N/a'.to_sym
    @money = money
    @deck = Deck.new(deck_count)
    @player = Player.new(player_name, @money)
    @dealer = Dealer.new
    @players = [@player, @dealer]
    @status = 0
    @bet = 0
    @status = 0
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
      puts input
      raise ArgumentError, 'Неправильная сумма ставки!' unless input.positive? && input <= @player.balance.to_f

      @bet = input
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
    print @money.zero? ? "\u001B[31m 0 \u001B[0m" : "\u001B[32m#{@money}\u001B[0m"
    print '] ставка:['
    print @bet.zero? ? "\u001B[31m#{@na}\u001B[0m" : "\u001B[32m#{@bet}\u001B[0m"
    print '] Очки:['
    if @player.points.instance_of? Array
      print "\u001B[32m#{@player.points.max}\u001B[0m"
    elsif @player.points.instance_of? Integer
      print @player.points.zero? ? "\u001B[31m 0 \u001B[0m" : "\u001B[32m#{@player.points}\u001B[0m"
    end
    print '] Статус:['
    print @status.zero? ? "\u001B[31m#{@status}\u001B[0m" : "\u001B[32m#{@status}\u001B[0m"
    print "]\n"
  end

  def start_game
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
  end

  def queue
    loop do
      break if over?
    end
  end

  def over?
    false
  end
end
