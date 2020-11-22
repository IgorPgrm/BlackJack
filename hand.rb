class Hand
  attr_reader :done, :cards, :card_weight, :points

  def initialize
    @cards = []
    @done = false
  end

  def lose?
    @points.nil? || @points > 21
  end

  def add_card(card)
    @cards << card
    check_weight
  end

  def done!
    @done = true
  end

  def cards_show
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
      aces_weight = aces_weight(aces_indexes.length)
      aces_weight.each_with_index do |_weight, aces_index|
        @cards.each_with_index do |card, index|
          aces_weight[aces_index] += card.cost unless aces_indexes.include?(index)
        end
      end
    end

    aces_weight.delete_if { |ace| ace > 21 } if aces_weight.instance_of?(Array) && aces_weight.size.positive?
    @points = aces_weight.max if aces_weight.instance_of?(Array)
    @points = aces_weight if aces_weight.instance_of?(Integer)
    @lose = true if points.nil? || points > 21
  end

  def aces_weight(count)
    case count
    when 1
      weight_mass = [1, 11]
    when 2
      weight_mass = [2, 12]
    when 3
      weight_mass = [3, 13]
    end
    weight_mass
  end
end
