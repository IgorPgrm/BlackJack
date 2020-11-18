class Player
  attr_reader :name, :balance, :cards, :card_weight, :lose, :points

  def initialize(name, balance)
    @lose = false
    @name = name
    @balance = balance
    @cards = []
    @card_weight = '0'
    @points = 0
  end

  def add_card(card)
    @cards << card
    check_weight
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
    @cards.each do |card|
      top += '╭╶╶╶╶╶╶╶╶╶╶╮'
      suit_name = "#{card.suit} #{card.name}"
      label += if card.name == 10
                 "╵      #{suit_name}╵"
               else
                 "╵       #{suit_name}╵"
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

  def check_weight
    @points = 0
    aces_indexes = []
    aces_weight = []

    @cards.each_with_index do |card, index|
      aces_indexes << index if card.cost == 11
      @points += card.cost
    end

    if aces_indexes.empty?
      aces_weight = @points
    else
      case aces_indexes.length
      when 1
        aces_weight = [1, 11]
      when 2
        aces_weight = [2, 12]
      when 3
        aces_weight = [3, 13]
      end
      aces_weight.each_with_index do |weight, aces_index|
        @cards.each_with_index do |card, index|
          aces_weight[aces_index] += card.cost unless aces_indexes.include?(index)
        end
      end
    end

    aces_weight.delete_if { |ace| ace > 21 } if aces_weight.instance_of?(Array) && aces_weight.size.positive?
    @points = aces_weight
  end
end
