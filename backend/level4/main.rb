require "../setup"
Dir["./models/*.rb"].each {|file| require file }


data_input = DataTranslator.import_from "data/input.json"

Car.all_record = data_input["cars"]
Rental.all_record = data_input["rentals"]

rental_prices = []
Rental.all_record.each do |rental|
  rental = Rental.find(rental["id"])
  rental_prices.push ({
    id: rental.id,
    actions: rental.actions
  })
end

data_output = { rentals: rental_prices }

DataTranslator.export_to"test/expected_output.json", data_output
