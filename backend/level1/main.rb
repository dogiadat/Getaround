require "../setup"

begin
  data_input = DataTranslator.import_from "data/input.json"

  Car.all_record = data_input["cars"]
  Rental.all_record = data_input["rentals"]

  rental_prices = []
  Rental.all_record.each do |rental|
    rental = Rental.find(rental["id"])
    rental_prices.push ({
      id: rental.id,
      price: rental.price_with_no_decrease
    })
  end

  data_output = { rentals: rental_prices }

  Dir.mkdir("result") unless Dir.exist?("result")
  DataTranslator.export_to"result/expected_output.json", data_output
rescue Exception => e
  puts e.message
end
