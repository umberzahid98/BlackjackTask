# player
class Player
  # amount is bet for person and money for dealer
  attr_accessor :name , :amount , :cards ,:value
  def initialize(name,amount,cards=[])
    @name=name
    @amount=amount
    @cards=[]
    @value=0
  end
end
# suits => club ,diamond, heart , spades
# card
class Card
  # card belongs to a suit, has a rank (Ace, Jack, King, Queen , 2-10), and they have values
  #Jack King Queen=10
  #Ace is 1 or 11 depending upon the player choice
  #2-10 cards value is equal to the number itself
  attr_accessor :suit, :rank, :value
  def initialize(rank,suit,value)
    @suit=suit
    @rank=rank
    @value=value
  end
end
# deck

class Deck

  attr_accessor :deck
  class << self
    def deck
      @deck
    end
  end
  def initialize
    # predefined ranks(Ace,Jack,King,Queen, 2-10)
    #clubs
    #faces and clubs will combine to make one card
    @ranks=["ace","jack","king","queeen",*(2..10)]
    @suits=["heart","diamond","club","spade"]
    @deck=[]
    @ranks.each {|rank|
      @suits.each {|suit|
      if rank.is_a? Integer
          value=rank
      elsif (rank=="ace")
        value=1
      else
      value=10
      end
      @deck<<Card.new(rank,suit,value)
    }
    }
    @deck.shuffle!
  end

end
# this module has game logic
module Functions
  def pick_card(player,dek)
    crd=dek.shift
    player.cards<< crd
    player.value+=crd.value
  end

  def get_player(no)
      puts " \n Hey Player #{no} enter your name i.e (amber)"
      name=gets
      puts "enter the bet you want to place i.e (10000)"
      bet=gets
      Player.new(name,bet)
  end
  def show_cards(bool,p)
      temp=bool
      puts "#{p.name}"
      if bool
        p.cards.each do |x|
          puts "#{x.suit}    #{x.value}    #{ x.rank} \n"
        end
        puts "\n#{p.name}  total value:#{p.value} \n"
      else
        val=0
        p.cards.each do |x|
          if temp
            puts "#{x.suit}    #{x.value}    #{ x.rank} \n"
            val+=x.value
          else
            temp=true
          end
          end
      puts "\n#{p.name} total value:#{val}\n"
    end
  end
  def player_playing(p,dek)
    puts "let's play the game now \n you are the Player  "
    temp=true
    while temp
    puts " choose \n 1 for hit \n 2 for stay"
    choice=gets
      if(choice.to_i==1)
        puts "you choosed hit"
        pick_card(p,dek)
        show_cards(true,p)
        if(p.value == 21)
          puts "BLACKJACK!!!! YOU WON ONE AND HALF OF YOUR BET #{p.amount.to_i + (p.amount.to_i)/2}"
          exit
        elsif (p.value>21)
          puts "Player is BUSTED!!! Dealer will get your bet amount#{p.amount}"
          exit
        end
      else
        temp=false
      end
    end
  end
  def dealer_playing(p,dek,p1)
    puts "you are the Dealer \n your cards:"
    show_cards(true,p)
    while true
      if p.value<17
        puts "you value is less than 17 you are picking card"
        pick_card(p,dek)
        show_cards(true,p)
      elsif p.value>21
        puts "Dealer is BUSTED!!! Player will get double his bet #{2*p1.amount.to_i}"
        exit
      else
        if p.value==p1.value
          puts "Its a TIE!! both of you have equal values "
          exit

        elsif p.value>p1.value
          puts "You Won the bet of PLayer #{p1.amount}"
          exit
        elsif p.value<p1.value
          puts "Player won his bet #{p1.amount}"
          exit
        end
      end
    end
  end
end




class Runner
  extend Functions
  dek=Deck.new.deck

# creating two people player and dealer
p1=get_player(1)
p2=get_player(2)
# giving two cards to player and dealer
2.times do
  pick_card(p1,dek)
end
2.times do
  pick_card(p2,dek)
end

show_cards(true,p1)
show_cards(false,p2)
#first turn for player to play his game
player_playing(p1,dek)
#turn for dealer
dealer_playing(p2,dek,p1)

end
