class Player
  attr_reader :name, :balance, :cards

  def initialize(name, balance)
    @name = name
    @balance = balance
  end
end
