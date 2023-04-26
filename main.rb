require 'rubygems'
require 'nokogiri'
# library hell
# require 'prawn'
# require 'prawn-html'
# require 'wicked_pdf'
# require "wkhtmltopdf-binary"
require 'pdfkit'

require 'open-uri'

require 'csv'

require './car.rb'

doc = Nokogiri::HTML(URI.open("https://www.otomoto.pl/osobowe/chevrolet/camaro/seg-coupe?page=1"))
# [0].css('.ooa-ep0of3')[0]

# puts doc.css("article div img")[0] photo
# puts doc.css("article div h2 a")[0] title
# puts doc.css("article div div span:not(:has(svg))")[0] price
# puts doc.css("article div div ul li")[0]&.text year
# puts doc.css("article div div ul li")[1] kilometeres driven
# puts doc.css("article div div ul li")[2] capacity
# puts doc.css("article div div ul li")[3] fuel type
# lastdoc = nil
cars = []

print "Marka pojazdu: "
marka = gets.chomp
print "Typ nadwozia: "
typ = gets.chomp
print "Model pojazdu: "
model = gets.chomp

appendix = (marka == "" ? "" : "/"+marka) + (model == "" ? "" : "/"+model) + (typ == "" ? "" : "/seg-"+typ)
link = "https://www.otomoto.pl/osobowe#{appendix}"
puts link
begin

5.times do |x|
  # https://www.otomoto.pl/osobowe?page=#{x+1}
  # https://www.otomoto.pl/osobowe/chevrolet/camaro/seg-coupe?page=#{x+1}
  # doc = Nokogiri::HTML(URI.open("https://www.otomoto.pl/osobowe?page=#{x+1}"))
  # doc = Nokogiri::HTML(URI.open("https://www.otomoto.pl/osobowe/chevrolet/camaro/seg-coupe?page=#{x+1}"))
  doc = Nokogiri::HTML(URI.open(link+"?page=#{x+1}"))
  # if doc == lastdoc
  #   next
  # end



  doc.css('article').each do |article|
    # next if article.css('div img')[0]["href"] == nil || article.css("div h2 a")[0] = nil
    if article.css('div img')[0] == nil
      next
    end

    if article.css("div h2 a")[0] == nil
      next
    end

    name = article.css("div h2 a")[0]&.text
    price = article.css("div div span:not(:has(svg))")[0]&.text
    production_year = article.css("div div ul li")[0]&.text
    kilometeres_driven = article.css("div div ul li")[1]&.text
    fuel_capcity = article.css("div div ul li")[2]&.text
    fuel_type = article.css("div div ul li")[3]&.text
    thumbnail = article.css('div img')[0]['src']

    cars.push(Car.new(name, price, production_year, kilometeres_driven, fuel_capcity, fuel_type, thumbnail))
    puts "pobrano: #{name}"
    # article.css
  end

  # lastdoc = doc
end
rescue => HTTPError
  puts "błąd sieci, kończe..."
end

CSV.open("./output/cars.csv", "w") do |csv|
  csv << ["name", "price", "production_year", "kilometeres_driven", "fuel_capacity", "fuel_type", "thumbnail"]
  cars.each do |car|
    csv << car.to_a
  end
end

css = "
.car {
  margin: 4px;
  width: 210mm;
}

img{
  float: left;
  margin: auto;
  width: 85mm;
  height: 70mm;
  object-fit: cover;
}

table {
  float: right;
  border-collapse: collapse;
  width: auto;
  width: 125mm;
  height: 70mm;
}

th {
  width: 10%;
}

table, td, th {
  border: black solid 1px;
  text-align: left;
}
"

# image URI.open(car.get_photo)

html = String.new

cars.each do |car|
  html += "
    <div class='car'>
      <img src='#{car.thumbnail}'>
      <table>
        <tr>
          <th>Nazwa</th><td>#{car.name}</td>
        </tr>
        <tr>
          <th>Cena</th><td>#{car.price}</td>
        </tr>
        <tr>
          <th>Rok produkcji</th><td>#{car.production_year}</td>
        </tr>
        <tr>
          <th>Przejechane kilometry</th><td>#{car.kilometeres_driven}</td>
        </tr>
        <tr>
          <th>Pojemność baku</th><td>#{car.fuel_capcity}</td>
        </tr>
        <tr>
          <th>Rodzaj paliwa</th><td>#{car.fuel_type}</td>
      </table>
    </div>
    "
end

fhtml = "
  <head>
    <style>
      #{css}
    </style>
  </head>
  <body>
    #{html}
  </body>
"
# puts fhtml
kit = PDFKit.new(fhtml)
kit.to_file("./output/cars.pdf")


# Prawn::Document.generate("cars.pdf") do
#   font_families.update("OpenSans" => {
#     :normal => "./OpenSans-VariableFont_wdth,wght.ttf"
#   })
#   font "OpenSans"
#   cars.each do |car|
#     # csv << car.to_a
#     image URI.open(car.get_photo)
#     car.to_s.split(", ").each do |part|
#       text part
#     end
#     # text "#{car.to_s}"
#     # text "aaaa"
#   end
# end
