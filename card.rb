class Card
  attr_reader :suit, :name, :cost, :hiden

  def initialize(suit, name)
    @suit = suit
    @name = name
    weight(name)
  end

  def weight(card)
    case card
    when 2..10
      @cost = card
    when 'J', 'Q', 'K'
      @cost = 10
    when 'A'
      @cost = 11
    end
  end

  def face_down
    symb = '╳'
    7.times do
      puts
      7.times do
        print symb
      end
    end
  end
end
