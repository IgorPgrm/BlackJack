class Dealer < Player
  def initialize
    super('Dealer', 100)
  end

  def face_down
    symb = '╳'
    puts '╭╶╶╶╶╶╶╶╶╶╶╮'
    9.times do
      print '╵'
      10.times do
        print symb
      end
      puts '╵'
    end
    puts '╰╶╶╶╶╶╶╶╶╶╶╯'
  end

  def dealer_cards_show
    show_cards_line = ''
    top = ''
    label = ''
    line = ''
    bottom = ''
    symb = '╵╳╳╳╳╳╳╳╳╳╳╵'
    @hands.first.cards.each do |card|
      top += '╭╶╶╶╶╶╶╶╶╶╶╮'
      if card == @hands.first.cards.first
        suit_name = "#{card.suit} #{card.name}"
        label += if card.name == 10
                   "╵      #{suit_name}╵"
                 else
                   "╵       #{suit_name}╵"
                 end
        line += '╵          ╵'
      else
        label += symb
        line += symb
      end
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
