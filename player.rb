class Player
  attr_reader :name, :balance, :cards, :card_weight

  def initialize(name, balance)
    @name = name
    @balance = balance
    @cards = []
    @card_weight = 0
  end

  def add_card(card)
    @cards << card
    @card_weight += card.cost
  end

  def show
    @cards.each do |card|
      puts "#{card.suit} #{card.name}"
    end
  end

  def show_cards
    show_cards_line = ''
    top = ''
    label = ''
    line = ''
    bottom = ''
    puts @cards.length
    @cards.each do |card|
      top += '╭╶╶╶╶╶╶╶╶╶╶╮'
      suitname = "#{card.suit} #{card.name}"
      label += if card.name == 10
                 "╵      #{suitname}╵"
               else
                 "╵       #{suitname}╵"
               end
      line += '╵          ╵'
      bottom += '╰╶╶╶╶╶╶╶╶╶╶╯'
    end
    show_cards_line += "#{top}\n#{label}\n"
    7.times do
      show_cards_line += "#{line}\n"
    end
    show_cards_line += bottom
    puts show_cards_line
  end
end
