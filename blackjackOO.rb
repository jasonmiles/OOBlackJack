class Card
  attr_accessor :suit, :face_value

  def initialize(s, fv)
    @suit = s
    @face_value = fv
  end

  def pretty_output
    "The #{find_face_value} of #{find_suit}"
  end

  def to_s
    pretty_output
  end

  def find_suit
    ret_val = case suit
                when 'H' then 'Hearts'
                when 'D' then 'Diamonds'
                when 'S' then 'Spades'
                when 'C' then 'Clubs'
              end
    ret_val
  end

  def find_face_value
    ret_val = case face_value
                when '1' then 'One'
                when '2' then 'Two'
                when '3' then 'Three'
                when '4' then 'Four'
                when '5' then 'Five'
                when '6' then 'Six'
                when '7' then 'Seven'
                when '8' then 'Eight'
                when '9' then 'Nine'
                when '10' then 'Ten'
                when 'J' then 'Jack'
                when 'Q' then 'Queen'
                when 'K' then 'King'
                when 'A' then 'Ace'
              end
    ret_val
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    ['H', 'D', 'S', 'C'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    scramble!
  end

  def scramble!
    cards.shuffle!
  end

  def deal_one
    cards.pop
  end

  def size
    cards.size
  end
end

module Hand
  def show_hand
    puts "---- #{name}'s Hand ----"
    cards.each do|card|
      puts "=> #{card}"
    end
    puts "=> Total: #{total}"
  end

  def total
    face_values = cards.map{|card| card.face_value }

    total = 0
    face_values.each do |val|
      if val == "A"
        total += 11
      else
        total += (val.to_i == 0 ? 10 : val.to_i)
      end
    end

    #correct for Aces
    face_values.select{|val| val == "A"}.count.times do
      break if total <= 21
      total -= 10
    end

    total
  end

  def add_card(new_card)
    cards << new_card
  end

  def is_busted?
    total > 21
  end

  def is_blackjack?
    total == 21
  end
end

class Player
  include Hand

  attr_accessor :name, :cards

  def initialize(n)
    @name = n
    @cards = []
  end

end

class Dealer
  include Hand

  attr_accessor :name, :cards

  def initialize
    @name = "Dealer"
    @cards = []
  end
end


class Game
  
  attr_accessor :dealer, :player, :deck, :gameover
  def initialize
    @player = Player.new("Jason")
    @dealer = Dealer.new
    @deck = Deck.new
    @gameover = false
  end

  def first_deal
    2.times do 
      dealer.add_card(deck.deal_one)
    end
    2.times do 
      player.add_card(deck.deal_one)
    end
  end

  def print_hands
    system 'clear'
    dealer.show_hand
    player.show_hand
  end

  def player_loop
    loop do
      if player.total > 21
        puts "Player is bust. Dealer wins."
        @gameover = true
        break
      end
      puts "Hit or stay?"
      answer = gets.chomp.downcase
      if answer == "hit"
        player.add_card(deck.deal_one)
        puts "Player hits..."
        sleep(0.5)
        print_hands
      elsif answer == "stay"
        break
      end
    end
  end

  def dealer_loop
    loop do
      if dealer.is_busted?
        puts "Dealer bust. #{player.name} wins!"
        @gameover = true
        break
      elsif dealer.total < 17
        puts "Dealer deals himself a card..."
        sleep(0.5)
        dealer.add_card(deck.deal_one)
        print_hands
      else
        break
      end
    end
  end

  def play
    first_deal
    print_hands
    if player.is_blackjack?
      "Congratulations, you got blackjack! You win."
    elsif dealer.is_blackjack?
      "Dealer got blackjack. Dealer wins."
    end
    player_loop
    dealer_loop if !gameover
    if !gameover
      puts "Dealer has #{dealer.total} and player has #{player.total}."
      if dealer.total > player.total
        puts "Dealer wins."
      elsif dealer.total < player.total
        puts "Player wins."
      else
        puts "It's a tie!"
      end
    end
  end
end

loop do
  Game.new.play
  puts "Would you like to play again? Y/N"
  answer = gets.chomp.downcase
  if answer == 'y'
    next
  elsif answer == 'n'
    break
  end
end

