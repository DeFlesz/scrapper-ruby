class Car
  attr_accessor :name, :price, :production_year, :kilometeres_driven, :fuel_capcity, :fuel_type, :thumbnail
  def initialize(name, price, production_year, kilometeres_driven, fuel_capcity, fuel_type, thumbnail)
    @name = name
    @price = price
    @production_year = production_year
    @kilometeres_driven = kilometeres_driven
    @fuel_capcity = fuel_capcity
    @fuel_type = fuel_type
    @thumbnail = thumbnail
  end
  def get_photo
    @thumbnail
  end
  def to_a
    [@name, @price, @production_year, @kilometeres_driven, @fuel_capcity, @fuel_type, @thumbnail]
  end
  def to_s
    "#{@name}, Cena: #{@price}, Rok produkcji: #{@production_year}, Licznik: #{@kilometeres_driven}, Pojemność: #{@fuel_capacity}, Rodzaj paliwa: #{@fuel_type}"
  end
end
