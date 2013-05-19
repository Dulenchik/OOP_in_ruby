class BookOrder 
  @@library = []
  attr_reader :title, :name, :order_date, :issue_date
  
  def initialize(title, name, order_date, issue_date)
    @title = title
    @name = name
    @order_date = order_date
    @issue_date = issue_date    
    @@library << self
  end
  
  class << self
    def smallest_period
      period = @@library.map {|order| order.issue_date.nil? ? nil : order.issue_date - order.order_date}
      period.delete(nil)
      period.min
    end
    
    def not_satisfied
      @@library.inject(0) { |total, order| order.issue_date.nil? ? total += 1 : total }
    end
    
    def most_active_reader(title)
      hash = @@library.inject(Hash.new(0)) do |amount, order|
        amount[order.name] += 1 if order.title.eql?(title)
        amount
      end
      begin
        hash.max_by { |key, value| value }.first
      rescue
        "Reader not found"
      end
    end
    
    def most_popular_book
      hash = @@library.inject(Hash.new(0)) do |amount, order|
        amount[order.title] += 1 
        amount
      end
      begin
        hash.max_by { |key, value| value }.first
      rescue
        "Book not found"
      end
    end
    
    def how_many_ordered(number)
      books = @@library.inject(Hash.new(0)) do |amount, order|
        amount[order.title] += 1
        amount
      end 
      begin
        title = books.sort_by { |key, value| value }[-number].first             
      rescue
        "Book not exist"
      else
        readers = Hash.new(true)
        @@library.each { |order| readers[order.name] = true if order.title.eql?(title)}
        readers.size
      end
    end
  end
end

NAMES = ["Masha", "Petya", "Vasya", "Fedya", "Katya"]
TITLES = ["The Magic Swan Geese", "Father Frost", "The Giant Turnip", "Kolobok", "Ivan the Fool"]
ORDER_DATES = []
ISSUE_DATES = [nil]

10.times { ORDER_DATES << Time.now + rand(11) * 86400 }
9.times { ISSUE_DATES << Time.now + (rand(11) + 10) * 86400 }
30.times{ BookOrder.new(TITLES[rand(5)], NAMES[rand(5)], ORDER_DATES[rand(10)], ISSUE_DATES[rand(10)]) }

puts "Smallest period: #{(BookOrder.smallest_period / 86400).to_i} day(-s)"
puts "Order not satisfied: #{BookOrder.not_satisfied}"
book = TITLES[rand(5)]
puts "Most active reader of '#{book}': #{BookOrder.most_active_reader(book)}"
puts "Most popular book: #{BookOrder.most_popular_book}"
puts "Number of readers: #{BookOrder.how_many_ordered(rand(3))}"