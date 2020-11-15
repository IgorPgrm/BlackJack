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
end
