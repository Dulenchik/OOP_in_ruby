class MailSorting
  @@parcels = []
  attr_reader :city, :street, :house, :apartment, :destination, :value

  def initialize(city, street, house, apartment, destination, value)
    @city = city
    @street = street
    @house = house
    @apartment = apartment
    @destination = destination
    @value = value
    @@parcels << self
  end

  class <<self
    def number_of_parcels(city)
      @@parcels.inject(0) { |total, parcel| parcel.city.eql?(city) ? total += 1 : total }
    end

    def parcels_with_value_higher(value)
      @@parcels.inject(0) { |total, parcel| parcel.value > value ? total += 1 : total }
    end

    def most_popular_address
      hash = @@parcels.inject(Hash.new(0)) do |amount, parcel|
        amount["#{ parcel.city }, #{ parcel.street } #{ parcel.house }/#{ parcel.apartment }"] += 1 
        amount
      end
      begin
        hash.max_by { |key, value| value }.first
      rescue
        "Address not found"
      end
    end
  end
end

CITIES = ["Dnipropetrovsk", "Kyiv", "Lviv"]
STREETS = ["Gagarin", "Bogdan Khmelnitsky", "Taras Shevchenko"]
HOUSES = [rand(50), rand(50), rand(50), rand(50)]
APARTMENTS = (1..10).to_a
DESTINATIONS = ["Masha", "Petya", "Vasya", "Fedya", "Katya"]
VALUES = (1..10).to_a.map { |value| value * 2 }

30.times { MailSorting.new(CITIES[rand(3)], STREETS[rand(3)], HOUSES[rand(4)], APARTMENTS[rand(10)], DESTINATIONS[rand(5)], VALUES[rand(10)]) }
city = CITIES[rand(3)]
value = 10

puts "Number of parcels sent to #{ city }: #{ MailSorting.number_of_parcels(city) } parcel(-s)"
puts "Parcels with value higher #{ value }: #{ MailSorting.parcels_with_value_higher(value) } parcel(-s)"
puts "Most popular address: #{ MailSorting.most_popular_address }"