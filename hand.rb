class Hand
  def initialize
    @cards = []
  end

  def add_card(card)
    @cards << card
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

end
